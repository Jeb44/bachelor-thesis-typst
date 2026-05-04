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

We start by discussing the foundational concepts that underpin plugin systems and their relevance to Rust. This includes an exploration of what plugin systems are, how they enable extensibility in software applications, and the mechanisms through which plugins communicate with their host applications. Then, we delve into current state of the art in Rust plugin systems, highlighting the challenges posed by Rust's unstable ABI and the various approaches that have been proposed or implemented to address these challenges. 

== Foundational Concepts

To contextualize the challenges of plugin systems in Rust, it is essential to establish a few definitions, ranging from the concept of plugins in software design to how developers can communicate with other pieces of software.

=== Plugin Systems

A plugin is a "computer software that adds new functions to a host program without altering the host program itself" @britannica-plugin. A plugin system is a software architecture pattern that allows a host application to be extended by third-party modules (plugins) without modifying the host's source code or recompiling the entire system. Key characteristics include extensibility, modularity, and dynamic loading capabilities.

- *Extensibility*: The ability to add new functionality post-deployment.
- *Modularity*: Plugins are isolated units that interact with the host through a well-defined interface.
- *Dynamic Loading*: Plugins are typically loaded at runtime rather than linked statically at compile time.

One typical way to visualize plugin systems is through the metaphor of a jigsaw puzzle, where the host application provides one or more interfaces and the plugins are pieces that fit into these interfaces to extend functionality <plugin-figure>.

#figure(
  image("../res/plugins_figure.svg"),
  caption: "Illustration between host application and plugins and their connections by the Apple developers"
) <plugin-figure>

When designing a plugin system, developers must consider how the host and plugins will communicate, which leads to the concept of dynamic linking - using an Application Binary Interface (ABI) - or inter-process communication (IPC).

When writing a Plugin systems, developers generally follow one of two patterns:

- *Static Linking*: Plugins are compiled into the host binary. This offers performance benefits but lacks runtime flexibility.
- *Dynamic Linking*: Plugins are separate binary files loaded into the host process memory space at runtime.

In this thesis, the focus is on dynamic linking, as it necessitates strict ABI compatibility or robust isolation mechanisms.

=== Application Binary Interface (ABI) <abi> 

While the Application Programming Interface (API) defines a "sets of standardized requests that allow different computer programs to communicate with each other" @britannica-api like function names and argument types, the Application Binary Interface (ABI) operates at a lower level, governing the interaction between compiled machine code.

This covers aspects such as, illustrated in @abi-figure:

- *Calling Conventions*: How function arguments are passed (registers vs. stack), how return values are delivered, and who is responsible for cleaning up the stack (caller vs. callee).
- *Data Layout*: The memory alignment, padding, and byte-ordering (endianness) of data structures.
- *Name Mangling*: The algorithm used by compilers to encode function names (including type information) into symbol names for the linker.
- *Exception Handling*: The mechanism for propagating errors or exceptions across module boundaries.

#figure(
  image("../res/abi_figure.svg"),
  caption: [The ABI as a contract between caller and callee: how a function call crosses the boundary (top), and how struct field layout differs between `#[repr(C)]` and `#[repr(Rust)]` (bottom).]
) <abi-figure>

*Challenges in Rust*: Dynamic linking in Rust is complicated by the language's ownership model and panic handling. Since Rust does not guarantee a stable ABI, a plugin compiled with Rust version 1.70 might use a different struct layout or calling convention than a host compiled with version 1.75. Furthermore, if a plugin panics, the unwinding behavior must be contained; otherwise, it can lead to undefined behavior or crashes in the host process. As described in implementation guides, "panics cannot cross the FFI boundary" without explicit handling, such as wrapping function bodies in `catch_unwind` or using ABI-stable libraries like `abi_stable` @null-deref-abi-stable.

*Foreign Function Interface (FFI)*: An FFI is the mechanism by which a program written in one language calls functions defined in another language. In practice this means crossing a compiled-language boundary — for example, Rust calling a C function, or C calling a Rust function. Because different languages may use different calling conventions, name-mangling schemes, and data representations, an FFI requires both sides to agree on a shared ABI. In Rust, this is expressed with `extern "C"` blocks and `#[no_mangle]` annotations, which instruct the compiler to use the stable C calling convention instead of Rust's own (unstable) one. The term "FFI boundary" therefore refers to the point in code where execution crosses from one language's runtime into another.

=== Virtual Dispatch Tables (VTables)

A *virtual dispatch table* (vtable) is a compiler-generated data structure that enables runtime polymorphism. When a Rust value is used through a `dyn Trait` reference — i.e., a trait object — the compiler does not know at compile time which concrete type implements the trait, so it cannot inline or statically resolve the method calls. Instead, it creates a fat pointer: a pair of (data pointer, vtable pointer). The vtable is a table of function pointers, one per method of the trait, pointing to the concrete implementations for that specific type.

For example, given a trait `Fuser` with a method `fuse`, a `Box<dyn Fuser>` holding a `ConcreteFuser` will carry a pointer to a vtable that contains the address of `ConcreteFuser::fuse`. Calling `fuser.fuse(...)` becomes an indirect call through the vtable, which incurs a small overhead compared to a direct (monomorphised) function call, but allows any type implementing `Fuser` to be used interchangeably at runtime.

*Relevance to plugin systems*: VTables are inherently tied to the ABI of the compiler that generated them. Because Rust does not guarantee a stable ABI, the layout of a vtable — the order and representation of function pointers — may differ between compiler versions or even between compilation units. This means that a `dyn Trait` object created in a plugin compiled with one version of the Rust compiler cannot safely be passed to a host compiled with a different version: the host would read function pointers from wrong offsets in the vtable, leading to undefined behavior. Additionally, if the shared library that contains the function implementations is unloaded while a vtable referencing it still exists, any subsequent call through that vtable will dereference dangling pointers. Crates such as `abi_stable` work around this by replacing Rust's native vtables with manually constructed, `#[repr(C)]`-stable equivalents whose layout is explicitly fixed.

=== Dynamic Linking and Runtime Loading

Dynamic Linking is the process of resolving references to external libraries or modules at runtime, rather than at compile time (link time).

Mechanism: In Unix-like systems, this is achieved through the `dlopen` (dynamic open), `dlsym` (dynamic symbol lookup), and `dlclose` (dynamic close) system calls. In Windows, the equivalents are `LoadLibrary`, `GetProcAddress`, and `FreeLibrary`.

Process Flow, as illustrated in @dynamic-linking-figure:

- *Discovery*: The host application locates the plugin binary file (e.g., .so, .dll, .dylib).
- *Loading*: The dynamic linker (on Linux: `ld-linux.so`) maps the plugin's code and data segments into the host's virtual memory space using the `mmap` system call. `mmap` (memory-map) instructs the kernel to project a region of a file directly into the process's virtual address space without copying it into a conventional buffer — the file's contents become accessible as ordinary memory pages, loaded on demand. `ld-linux.so` is the OS-provided program interpreter that is invoked automatically when an ELF binary is executed; it parses the binary's dependencies, locates the required shared libraries on disk, `mmap`s them into the process's address space, and patches all relocation entries so that symbol references point to the correct memory addresses before `main` is called.
- *Resolution*: The host resolves symbol addresses (function pointers) within the loaded plugin using `dlsym`.
- *Execution*: The host invokes the plugin's functions via the resolved pointers. Because all segments reside in the same address space, calls are direct function-pointer jumps with no serialization overhead.

#figure(
  image("../res/dynamic_linking_figure.svg"),
  caption: [How the dynamic linker maps shared libraries into the host process's virtual address space at runtime, enabling direct function-pointer calls without serialization.]
) <dynamic-linking-figure>

In Rust, one crate has emerged regularly when loading dynamic libraries: `libloading` @crate-libloading, which provides a safe abstraction over platform-specific dynamic loading APIs. However, using `libloading` still requires careful management of ABI compatibility and error handling, as it does not solve the underlying issues of Rust's unstable ABI or panic safety., 

=== Inter-Process Communication (IPC)

Inter-Process Communication (IPC) refers to the mechanisms that allow processes to exchange data and signals. Unlike dynamic linking, where a plugin is loaded directly into the host process's address space, IPC keeps the host and plugin in separate, isolated processes that communicate through an OS-managed channel, as illustrated in <ipc-figure>.

#figure(
  image("../res/ipc_figure.svg"),
  caption: [Two isolated processes communicating through an IPC channel.]
) <ipc-figure>

Common IPC methods include:
- *Shared Memory*: Multiple processes access the same memory region for communication, requiring synchronization mechanisms to prevent race conditions
- *Message Passing*: Processes send messages to each other through queues, pipes, or sockets, which can be synchronous or asynchronous
- *Remote Procedure Calls (RPC)*: A higher-level abstraction where a process can invoke a procedure in another process as if it were a local function call, often implemented over network protocols

Relevance to Rust: While IPC can be used to enable communication between a Rust host and plugins, it introduces additional complexity and overhead compared to in-process dynamic linking. Moreover, Rust's ownership model and safety guarantees can complicate the design of IPC mechanisms, as shared memory requires careful synchronization, and message passing may involve serialization and deserialization of complex data structures, which can be error-prone and inefficient. As such, while IPC is a viable approach for plugin systems, it is often considered a last resort when ABI stability cannot be achieved through dynamic linking.

== Existing work

As of 2026, the Rust ecosystem remains in a state of intentional ABI instability, a condition that has persisted despite years of community advocacy and formal proposals. Many proposals were held, such as RFC #1675 @rfc-1675, RFC #600 @rfc-600 and discussion in the Rust Programming Language Forums, like "A Stable Modular ABI for Rust" @internals-12347, which proposes to enable runtime loading of Rust libraries without C interop. However, the proposal was ultimately deferred, with the compiler team citing the high cost of freezing internal representations that are critical for future optimizations, such as constant evaluation and monomorphization strategies @rfc-1675. Instead of a native solution, the community has converged on pragmatic workarounds, where the usage of the C ABI is the only reliable standard for binary interoperability, forcing developers to adopt verbose ```rust extern "C"``` interfaces or rely on third-party crates like abi_stable to simulate stability through ```rust #[repr(C)]``` wrappers and runtime checks @null-deref-plugin-impl @null-deref-abi-stable. While experimental efforts continue to explore WebAssembly as a language-agnostic ABI alternative, no native Rust-to-Rust stable ABI has been implemented, leaving plugin developers to navigate a fragmented landscape of manual FFI management and abstraction layers. 

No comprehensive comparison between possible solutions for plugin systems in Rust has been done yet. There are some simple comparisons, but they don't cover the full range of options and trade-offs.

