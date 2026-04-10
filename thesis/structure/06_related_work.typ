/*
• This is where all the relevant terms and topics are introduced, which are used in particular in the Methods section, and therefore need to be understood by the reader.
 At the same time, existing approaches are named and discussed, and cited with
appropriate references. 
Classification should always be made in terms of their significance for the objectives of your thesis.
 It is not a problem to make the following argument:
– Problem X is also examined in [..], but with the focus on…, which is not the main focus here.
– The approach in X appears to be suitable, so it is worth examining algorithm Y in closer detail.
– According to [..], the software package X represents a standard in the field of ..., so it should also be used for the work in this thesis.
*/

= Related work <rel_work>

== Existing work

As of 2026, the Rust ecosystem remains in a state of deliberate ABI instability, a condition that has persisted despite years of community advocacy and formal proposals. The most significant attempt to address this were RFC #1675 @rfc-1675 and RFC #600 @rfc-600 ("Make Rust ABI stable enough to provide plugins functionality"), which proposed a "stable modular ABI" to enable runtime loading of Rust libraries without C interop. However, the proposal was ultimately deferred, with the compiler team citing the high cost of freezing internal representations that are critical for future optimizations, such as constant evaluation and monomorphization strategies @rfc-1675. Additionally, it was proposed to allow for a modular ABI, where a developer can specify the ABI by using macro system. @internals-modular-abi. Recent discourse at conferences like RustConf and FOSDEM reinforces this stance; speakers such as Niko Matsakis and others have emphasized that stabilizing the ABI would "lock in" implementation details, potentially hindering the compiler's ability to evolve (Matsakis, RustConf 2023). Instead of a native solution, the community has converged on pragmatic workarounds. The prevailing consensus, reflected in technical talks and blog posts from 2023-2024, is that the C ABI remains the only reliable standard for binary interoperability, forcing developers to adopt verbose extern "C" interfaces or rely on third-party crates like abi_stable to simulate stability through ``#[repr(C)]`` wrappers and runtime checks (NullDeref, 2023; Arroyo Blog, 2023). While experimental efforts continue to explore WebAssembly as a language-agnostic ABI alternative, no native Rust-to-Rust stable ABI has been implemented, leaving plugin developers to navigate a fragmented landscape of manual FFI management and abstraction layers.

TODO: Fix links with the concrete answer of the dev team...

// Add here: Why safety is not considered?

Currently only rust std library and ferrocene compiler verified. Therefore, most code that needs to be verified is already limited and the solutions that can be used for Plugins are limited. Not the focus of this thesis. // TODO: Add reference to safety verification


== Foundational Concepts

To contextualize the challenges of plugin systems in Rust, it is essential to establish precise definitions of the core architectural components involved: the ABI, how stable the Rust Type System is for the ABI, plugin architectures, and dynamic linking mechanisms.

=== Application Binary Interface (ABI)

While the Application Programming Interface (API) defines the source-code level contract between software components (function names, argument types, and headers), the Application Binary Interface (ABI) operates at a lower level, governing the interaction between compiled machine code.

*Definition*: According to the System V Application Binary Interface, the standard for Unix-like operating systems, the ABI is "an interface between two binary program modules" (System V ABI, 2023). It encompasses:

- *Calling Conventions*: How function arguments are passed (registers vs. stack), how return values are delivered, and who is responsible for cleaning up the stack (caller vs. callee).
- *Data Layout*: The memory alignment, padding, and byte-ordering (endianness) of data structures.
- *Name Mangling*: The algorithm used by compilers to encode function names (including type information) into symbol names for the linker.
- *Exception Handling*: The mechanism for propagating errors or exceptions across module boundaries.

Relevance to Rust: In the context of Rust, the lack of a standardized ABI is a deliberate design choice. As noted by the Rust compiler team, the ABI is "deliberately unstable" to allow the compiler to optimize memory layouts and calling conventions aggressively without being constrained by backward compatibility requirements (Rust Internals, 2020). This contrasts with the C ABI, which is strictly defined and stable, serving as the de facto standard for binary interoperability.

=== Rust Types and ABI Instability

@stabby-tutorial-abi-stable-types

*Product types* (or structs): is it ordered? is it aligned?

C is always aligned and source-ordered.

Rust fields also also aligned, but the ordered is minimized for memory usage.

Rust can enforce this by using #[repr(C)], but this is not the default, and the compiler can change the layout for optimization purposes. This means that without explicit annotations, the memory layout of a Rust struct is not guaranteed to be stable across different compiler versions or optimization levels, which can lead to binary incompatibility when used in a plugin system.



*Sum types* (or enums): how to distinguih the variants? where is the data?

Not supported by C. Can be done using a tagged union, but you need to give each type a specific number (usually a enum).

Rust may be put in a niche (like common padding or using type's forbidden value).

Example with ``Cow<'a, str>``: Can waste 7 bytes for padding on a 64-bit architecture.

Rust guarantees that the layout of a sum type is not clashing with the layout of a product type.

*Unit types* (()): are they zero-sized? what about references?

Doesn't exist in C as zero-sized type. ZSTs are undefined behavior.

#line()

As Pierre states, for a stable ABI all linkees must agree on an ABI for each symbol @stabby-tutorial-abi-stable-types (double check, maybe i need to link the talk instead...).

Note stable due to changes in compiler version, optimization level, target architecture, using `-Z randomize-layout` and so on. This is a fundamental problem for plugin systems in Rust, as the host and the plugin may be compiled with different versions of the compiler or different optimization flags, leading to binary incompatibility.

A few examples as to why the rust ABI is not stable yet can be found in niche optimizations: enums with muiltiple data variant optimizations (1.65), field ordering optimizations (1.67), `Cow<str>` regression (1.70), and more.



=== Plugin Systems

A plugin system is a software architecture pattern that allows a host application to be extended by third-party modules (plugins) without modifying the host's source code or recompiling the entire system.

Definition: In software engineering literature, a plugin is defined as "a software component that adds a specific feature to an existing computer program" (Gamma et al., 1994). Key characteristics include:

- *Extensibility*: The ability to add new functionality post-deployment.
- *Modularity*: Plugins are isolated units that interact with the host through a well-defined interface.
- *Dynamic Loading*: Plugins are typically loaded at runtime rather than linked statically at compile time.

Architectural Patterns: Plugin systems generally follow one of two patterns:

- *Static Linking*: Plugins are compiled into the host binary. This offers performance benefits but lacks runtime flexibility.
- *Dynamic Linking*: Plugins are separate binary files loaded into the host process memory space at runtime. This is the primary focus of this thesis, as it necessitates strict ABI compatibility or robust isolation mechanisms.

The primary challenge in Rust plugin systems is ensuring that the host and the plugin, potentially compiled with different compiler versions or optimization flags, agree on the binary representation of data and function calls.


=== Dynamic Linking and Runtime Loading

Dynamic Linking is the process of resolving references to external libraries or modules at runtime, rather than at compile time (link time).

Mechanism: In Unix-like systems, this is achieved through the dlopen (dynamic open), dlsym (dynamic symbol lookup), and dlclose (dynamic close) system calls. In Windows, the equivalents are LoadLibrary, GetProcAddress, and FreeLibrary.

Process Flow:

- *Discovery*: The host application locates the plugin binary file (e.g., .so, .dll, .dylib).
- *Loading*: The operating system maps the plugin's code and data segments into the host's virtual memory space.
- *Resolution*: The host resolves symbol addresses (function pointers) within the loaded plugin.
- *Execution*: The host invokes the plugin's functions via the resolved pointers.

*Challenges in Rust*: Dynamic linking in Rust is complicated by the language's ownership model and panic handling. Since Rust does not guarantee a stable ABI, a plugin compiled with Rust version 1.70 might use a different struct layout or calling convention than a host compiled with version 1.75. Furthermore, if a plugin panics, the unwinding behavior must be contained; otherwise, it can lead to undefined behavior or crashes in the host process. As described in implementation guides, "panics cannot cross the FFI boundary" without explicit handling, such as wrapping function bodies in catch_unwind or using ABI-stable libraries like abi_stable @null-deref.

No comprehensive comparison between possible solutions for plugin systems in Rust has been done yet. There are some simple comparisons, but they don't cover the full range of options and trade-offs.


// #lorem(100)

// The complexity of Rust's type system, particularly its support for product types (tuples and structs) and sum types (enums), is a primary driver behind the language's unstable ABI. Product types, which aggregate multiple values into a single unit, present challenges regarding memory layout; while #[repr(C)] can force a C-compatible layout, the default Rust representation may reorder fields for padding optimization or align data differently based on the target architecture, leading to binary incompatibility between compiler versions. The situation is more profound with sum types, which represent a value that can be one of several variants (e.g., Option<T> or Result<T, E>). Unlike C-style unions, Rust enums often employ sophisticated memory optimizations, such as niche value exploitation, where unused bit patterns in a variant's data are repurposed to store the discriminant (the tag indicating which variant is active). For instance, Option<&T> is often represented as a single pointer where null signifies None, eliminating the need for an extra integer field. Because these optimizations are internal implementation details subject to change based on compiler heuristics, the memory layout of a sum type is not guaranteed to remain stable across builds. As noted in the Rust internals community, "the compiler is free to rearrange the memory layout of structs... and apply target-specific or optimization-driven changes without any guarantee that two builds... will emit identical binary interfaces" (Rust Internals, 2020). Consequently, passing complex sum or product types across a dynamic library boundary without explicit #[repr(C)] annotations or ABI-stable wrappers risks undefined behavior, as the host and plugin may interpret the same bit pattern as entirely different data structures.
