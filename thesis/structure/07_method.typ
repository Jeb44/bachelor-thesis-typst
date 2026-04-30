/*
 This is where to describe everything that makes your thesis an independent piece of work.
 Essentially, this is where to describe how your solution works.
 Typically, the individual aspects are simply arranged one after the other in the
document structure, with suitable subheadings.
 The chosen solution naturally also includes your line of argument about which other
variants might have been an option, and the reasons why you decided upon this
particular solution.
The following substructure is typical:
 3.1 Analysis of the requirements
 3.2 Potential approaches and problems
 3.3 Selected approach and detailed solutions
When working with highly conceptual software components or implementation
components, the following subheadings are generally added in addition:
 3.4 Software design
 3.5 Implementation
The Implementation section contains no listings, but examines the software
environment and addresses all those points which are not self-explanatory for the
route from the design to a specific software structure.

For a "software-heavy" Bachelor thesis, you'll know you're on the right level of abstraction if you can give your Bachelor thesis to someone and they are able to re-implement your work in a different programming language.
If this is possible, then you have covered all the relevant details on the level of the design and the structure, independently of a particular programming language.
Implementation details on the level of specific C/C++/Java constructs are generally only added (and then frequently only as an appendix), if these concern less relevant implementations of the interrelationships otherwise already presented. UML diagrams generally provide sufficient and adequate means of expression.
*/

= Methods <methods>

== Analysis of the requirements

Goal of the research was to analyze the following points:

- @perf_overhead[Performance Overhead]
- @development_complexities[Development Complexities]
- @limitations[Limitations]
- @safety[Safety]
- @interoperability[Interoperability]



=== Performance Overhead <perf_overhead>

/*
#figure(
  align(left, ```rust
  fn main() {
    println!("Hello world!")
  }
  ```),
  caption: [Rust Code],
)
*/

//awawaw `criterion` wawawaw `gungraun` wawawawaw `black_box` wawawaw
//inline code ```rust fn hewwo() -> Library { ... } ```

When measuring our plugins, we expect that the execution time of the plugin's internal functionality to be relatively similar across different approaches. However, the setup time for each approach is expected to vary, with approaches that require more complex initialization (e.g. loading a dynamic library, setting up IPC communication, serialization) are more likely to require more time.

We expect that the IPC approach will have higher performance overhead compared to the other approaches due to the need for serialization and deserialization of data, as well as the communication overhead between processes. This is because IPC typically involves more complex interactions between processes, which can introduce additional latency compared to approaches that operate within a single process. We expect the measurements for the Rust ABI and C ABI approaches to be more similar to each other, as they both involve loading and executing code within the same process, albeit with different calling conventions and potential overhead from FFI in the case of the C ABI approach.

To measure the results, we are using the _criterion_ and _gungraun_ crate for our benchmarks. The results of these will be separated into setup time and function execution time, which allows us to analyze the overhead of each approach in more detail.

As noted by the criterion documentation, the criterion crate is a statics-driven micro-benchmarking library, which aims to provide strong statistical confidence in detecting and estimating the size of performance improvements and regressions @doc-criterion. As stated by the gungraun documentation, "gungraun is a one-shot benchmarking harness and framework which uses Valgrind's Callgrind, Cachegrind, and DHAT to provide extremely accurate and consistent measurements of Rust code, making it perfectly suited to run in environments like a CI" @doc-gungraun.

We hope by combining both of these tools, we can get a comprehensive understanding of the performance characteristics of each approach, and how they compare to each other in terms of setup time and function execution time.

In Rust benchmarking, wrapping inputs and intermediate values in black_box is essential to prevent the compiler from optimizing away the code you intend to measure. Because Rust's optimizer is aggressive, it may detect that a function's result is unused or that an input is constant, leading it to eliminate the entire computation or to remove it out of a loop, resulting in artificially low (and inaccurate) timing data. The ```rust std::hint::black_box``` function acts as an opaque barrier, signaling to the compiler that the value is unknown and must be treated as having side effects, thereby forcing it to execute the code exactly as written within the benchmark. @doc-black-box Each benchmark will be run with and without black_box to compare the results and understand the impact of compiler optimizations on our measurements.



=== Development complexities <development_complexities> 

When using external crates, they usually come with their own learning curve and documentation. This can add to the development time, especially if the crate is not well-documented or has a complex API. Additionally, integrating external crates into an existing codebase can sometimes lead to compatibility issues or require significant refactoring. Quantifying this is difficult, as it depends on the developer's experience, familiarity with the crate, and the specific requirements of the project. 
We have decided to instead focus on a qualitative analysis of the development complexities, based on the given available data by the crates maintainers and our experience during the implementation of each approach. This will include factors such as the ease of use of the crate's API, the quality of its documentation, and any challenges faced during integration. After summarizing these, we will 

We expect that the dynamic library loading approaches (Rust ABI and C ABI) may have higher development complexities compared to the IPC approach, due to the need to manage dynamic libraries, handle FFI (in the case of C ABI), and ensure compatibility between the plugin and host application. The IPC approach may have lower development complexities in terms of integration, as it allows for more decoupled communication between processes, but it may require more complex software design to handle serialization and inter-process communication effectively.

We will evaluate each approach with a ++, + or 0 based on the following criteria:

- *++*: The approach is straightforward to implement, with a clear and well-documented API, and requires minimal additional setup or configuration. The crate offers good documentation and examples, making it easy for developers to understand and use effectively.
- *+*: The approach is generally manageable to implement, but may require some additional setup or configuration. The crate has decent documentation, but may have some gaps or areas that are not well-explained, which could lead to some challenges during development.
- *0*: The approach is neutral in terms of complexity, with neither significant advantages nor disadvantages in terms of implementation effort or documentation quality.
- *-*: The approach is complex to implement, with a steep learning curve, a poorly documented API, or significant additional setup or configuration required. Alternatively, the approach may have significant disadvantages for the developers. 

=== Limitations <limitations>

Each approach may come with some limitations for the developers. In general, we want to see if an approach may require more complex software design, which could be a limitation for developers who are not familiar with this type of architecture.

Some Rust Types cannot be easily represented in C, which can lead to limitations in the C ABI approach. We also expect that the IPC approach may have limitations in terms of the types of data that can be easily serialized and deserialized, which could impact the flexibility of this approach. Typically, pointers and references are difficult to represent in C, while IPC might even struggle with more complex data structures that require custom serialization logic.

As the ABI solutions have different limitations
Because we are also working with different ABI solutions, there can be complexities in regards of their restrictions and limitations.

In some cases, Limitations may overlap with @development_complexities, as certain limitations may require additional development effort to work around or mitigate. For example, if a particular approach has limitations in terms of the types of data that can be easily represented or serialized, this may require additional development effort to implement custom serialization logic or to design the plugin architecture in a way that avoids these limitations.

// Explain +, = and -? >w<

=== Interoperability <interoperability>

We perform a qualitative assessment of the interoperability of each approach based on the available documentation. In our sample code, we only test the interoperability of the plugin system from a Rust Plugin to a Rust Host Application. 

We will rate each approach with a ++, +, 0 based on the following criteria:

- *++*: The approach provides seamless interoperability with other libraries and tools, allowing for easy integration and compatibility with a wide range of use cases.
- *+*: The approach has good interoperability with other libraries and tools, but may require some additional configuration or workarounds to achieve full compatibility.
- *0*: The approach has limited interoperability with other libraries and tools, making it difficult to integrate with existing codebases or to use in a wide range of scenarios. In some cases, the approach may be completely incompatible with certain libraries or tools, which can significantly limit its usefulness in real-world applications.


=== Safety <safety>

The Rust Language is designed with safety in mind, and it provides strong guarantees against common programming errors such as null pointer dereferences, buffer overflows, and data races. Typically, errors occur through the careless usage of unwinding. @nomicon_unwinding

Yet, this does not result in formal verifications, like DO-178C or IEC 61508, which are often required in safety-critical domains. However, the Rust ecosystem has been making strides in this area, with efforts to achieve certifications for certain subsets of the Rust language and libraries, such as the recent achievement of IEC 61508 (SIL 2) certification for a subset of the Rust core library by Ferrous Systems @rust-blog-safety-critical @ferrous-systems-iec-61508.

From this, we can infer that while Rust provides strong safety guarantees, the level of safety can depend on the specific approach used for plugin integration. For example, approaches that involve unsafe code (such as FFI in the C ABI approach) may require more careful handling to ensure safety, while approaches that operate entirely within safe Rust (such as the Rust ABI approach) may provide stronger safety guarantees by default. The IPC approach may also have its own safety considerations, such as ensuring that data is properly validated and that communication channels are secure.

For this thesis, we do not consider it appropriate to perform a quantitative or qualitative analysis of the safety of each approach, as this would require a detailed examination of the specific implementation and usage patterns, which may be beyond the scope of this research. 



== Potential approaches and problems

// CONTINUE HERE QWQ

When developing a plugin system in Rust, there are several potential approaches that can be taken, each with its own set of advantages and disadvantages. In this section we will introduce different crates and give an overview of their functionality. We will have a closer look at the choosen approach in the next section @selected_approach.

=== Unstable Rust ABI

It is possible to load other Rust Libraries as plugins, using the Rust ABI. However, this approach is complicated by the fact that the Rust ABI is not stable. 

=== abi_stable crate

The abi_stable crate enables stable, version-independent interoperability between Rust libraries and executables by generating a custom, C-like ABI that bypasses Rust's unstable internal layout guarantees, allowing dynamically linked shared objects to communicate safely even when compiled with different Rust compiler versions or feature flags. It achieves this through a macro-heavy approach (`#[sabi]`) that enforces strict trait bounds and generates wrapper code to handle memory layout, vtables, and function pointers, effectively creating a "Rust FFI" that is safer than raw extern "C" for complex types. However, this stability comes with significant trade-offs: the generated code introduces non-trivial runtime overhead due to extra indirection and dynamic dispatch, the API is verbose and requires extensive boilerplate that can obscure the underlying logic, and it currently lacks support for many modern Rust features like async/await or generic specialization, making it less suitable for performance-critical paths or projects prioritizing minimal binary size compared to simpler extern "C" or cxx solutions.

=== rust-bindgen

The bindgen crate automates the creation of Rust FFI bindings by parsing C or C++ header files using Clang to generate Rust extern blocks and struct definitions that mirror the original C API, effectively eliminating the manual, error-prone process of translating C types into Rust equivalents. It operates by invoking Clang to analyze the header syntax tree, resolving macros and complex type definitions, and outputting a Rust source file that can be integrated into a build script (build.rs) to ensure bindings stay synchronized with header changes. However, this automation introduces significant downsides: the generated code is often verbose, unreadable, and difficult to maintain manually, leading to large binary sizes; it tightly couples the Rust build process to the presence of a compatible Clang installation and the exact C headers, complicating cross-compilation and CI pipelines; and because it exposes the raw C API directly, it frequently forces developers to wrap the generated unsafe code in safe abstractions to prevent memory safety issues, adding an extra layer of development overhead despite the initial automation.

=== cbindgen crate

The cbindgen crate facilitates Rust-to-C interoperability by scanning Rust source code annotated with specific attributes (like `#[no_mangle]` and `repr(C)`) to automatically generate C header files (.h) and corresponding documentation, allowing C or C++ projects to consume Rust libraries as if they were native C code without needing to parse Rust syntax directly. It works by traversing the Rust AST to extract public functions, structs, and enums, translating Rust types into their C equivalents (e.g., mapping `u32` to `uint32_t` and `Option<T>` to a union or pointer pattern) and handling complex scenarios like callbacks and string lifetimes through configurable build scripts. However, its effectiveness is limited by the requirement that Rust code must strictly adhere to C-compatible layouts and calling conventions, often necessitating manual refactoring of idiomatic Rust code to fit these constraints; additionally, it struggles with advanced Rust features like generics, traits, and complex lifetimes which have no direct C equivalent, forcing developers to write verbose wrapper functions or accept that the generated headers may be incomplete or require significant manual patching to be usable in a C environment.

=== stabby crate

=== Other Rust Bindings 

==== pyo3 (Python bindings) 

The pyo3 crate enables seamless bidirectional interoperability between Rust and Python by leveraging the Python C API to expose Rust functions, structs, and enums as native Python objects while allowing Rust code to call Python functions and manipulate Python objects with type safety. It operates through a macro-driven system where the `#[pyclass]` and `#[pymethods]` attributes generate the necessary C bindings and glue code, automatically handling reference counting, memory management, and the conversion of Rust types (like `Vec` or `String`) into their Python equivalents (like `list` or `str`) via the `IntoPy` and `FromPyObject` traits. By utilizing the Global Interpreter Lock (GIL) guard to ensure thread safety during Python interactions and providing a high-level API that abstracts away the complexities of the underlying C API, pyo3 allows developers to write performance-critical Python extensions in Rust that feel and behave like idiomatic Python code, all while maintaining the safety guarantees of the Rust compiler.

==== Wasm (WebAssembly)

Using WebAssembly with Rust involves compiling Rust code to the `wasm32-unknown-unknown` target, a process streamlined by tools like wasm-pack and wasm-bindgen that bridge the gap between Rust's memory model and JavaScript's environment. By annotating Rust functions with #[wasm_bindgen], developers can automatically generate the necessary glue code to export Rust functions to JavaScript and import JS functions into Rust, handling complex type conversions (such as mapping Rust Strings to JS strings and Vecs to typed arrays) and managing memory ownership across the boundary. This workflow typically starts by installing the wasm32 target via rustup, writing Rust logic with the wasm-bindgen crate, running wasm-pack build to generate a .wasm binary and corresponding JavaScript/TypeScript bindings, and finally loading the resulting module in a browser or Node.js environment to execute high-performance, sandboxed code that interacts seamlessly with the host application.


=== Interprocess Communication (IPC)

different structure. communication over serialization

positive: interoperability, less complexity during development

negative: performance overhead, more complex software design

==== rust_bridge crate

==== other ipc crates? (overview)


== Selected approach and detailed solutions <selected_approach>

When choosing the approach for further analysis, we decided onto the take a closer look at the *Unstable Rust ABI*, the *abi_stable* crate, the *stabby* crate and on the *rust_bridge* crate. We choose those, because they represent a good variety of approaches to plugin systems in Rust, ranging from direct ABI manipulation to IPC-based communication. 

The Unstable Rust ABI approach is interesting because it represents the most direct way to load Rust plugins, but it also comes with significant challenges due to the instability of the Rust ABI.

The abi_stable crate is interesting because it provides a solution to the instability of the Rust ABI, but it also comes with its own set of trade-offs in terms of performance and complexity.
The stabby crate is interesting because it has a more fundamental approach (NOT HAPPY WITH THIS PHRASING!!) to plugin systems in Rust, and it also has a focus on safety and ease of use. Finally, the rust_bridge crate is interesting because it represents an IPC-based approach to plugin systems in Rust, which has its own set of advantages and disadvantages compared to the other approaches.


WebAssembly (Wasm) is not covered in this paper.

C ABI: abi_stable and stabby

Rust: ... well unstable

IPC: rust_bridge


/*Benches are run with the following set of configurations:
- run app "regularly" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)
*/

