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

- Performance Overhead
- Development Complexities
- Language Limitations
- Safety
- Interoperability

In the following section we will introduce these points in more detail and explain how we will analyze them in the context of plugin systems in Rust.

=== Performance Overhead <perf_overhead>

When measuring our plugins, we expect that the execution time of the plugin's internal functionality to be relatively similar across different approaches. However, the setup time for each approach is expected to vary, with approaches that require more complex initialization (e.g. loading a dynamic library, setting up IPC communication, serialization) are more likely to require more time.

We expect that the IPC approach will have higher performance overhead compared to the other approaches due to the need for serialization and deserialization of data, as well as the communication overhead between processes. This is because IPC typically involves more complex interactions between processes, which can introduce additional latency compared to approaches that operate within a single process. We expect the measurements for the Rust ABI and C ABI approaches to be more similar to each other, as they both involve loading and executing code within the same process, albeit with different calling conventions and potential overhead from FFI in the case of the C ABI approach.

To measure the results, we are using the *criterion* and *gungraun* crate for our benchmarks. The results of these will be separated into setup time and function execution time, separated into "single fuse" (1 array element) and "multi fuse" (1,000,000 elements).

The separation for the function execution time into "single fuse" and "multi fuse" is important, as it allows us to understand how the performance of each approach scales with the number of sensors. The "single fuse" case will give us insight into the overhead of each approach when dealing with a small amount of data, while the "multi fuse" case will show us how well each approach handles larger amounts of data and whether there are any performance bottlenecks that arise as the number of sensors increases.

As noted by the criterion documentation, the criterion crate is a statistics-driven micro-benchmarking library, which aims to provide strong statistical confidence in detecting and estimating the size of performance improvements and regressions @doc-criterion. From the gungraun documentation we can gather, that "gungraun is a one-shot benchmarking harness and framework which uses Valgrind's Callgrind, Cachegrind, and DHAT to provide extremely accurate and consistent measurements of Rust code, making it perfectly suited to run in environments like a CI" @doc-gungraun. Here we are in particular interested in the amount of instructions and the estimated execution cycles. It is important to understand, that not each instruction requires the same amount of execution cycles, and that the number of instructions is not necessarily a good indicator for the performance of a particular approach. 

We hope by combining both of these tools, we can get a comprehensive understanding of the performance characteristics of each approach, and how they compare to each other in terms of setup time and function execution time. If the instruction count is notably higher than other approaches, but uses the same amount of execution cycles, and likely a similar amount of time, then this is not necessarily a bad result for the approach. However, if the instruction count is notably higher and also uses more execution cycles, then this is likely a bad result for the approach.

In Rust benchmarking, wrapping inputs and intermediate values in ```rust std::hint::black_box``` is essential to prevent the compiler from optimizing away the code you intend to measure. Because Rust's optimizer is aggressive, it may detect that a function's result is unused or that an input is constant, leading it to eliminate the entire computation or to remove it out of a loop, resulting in artificially low (and inaccurate) timing data. The ```rust std::hint::black_box``` function acts as an opaque barrier, signaling to the compiler that the value is unknown and must be treated as having side effects, thereby forcing it to execute the code exactly as written within the benchmark. @doc-black-box Each benchmark will be run with and without black_box to compare the results and understand the impact of compiler optimizations on our measurements.

Finally, we will compare the results to the benchmark to a baseline implementation that does not use any plugin system, to understand the overhead introduced by each approach compared to a direct implementation of the functionality within the host application. This will allow us to quantify the performance impact of using a plugin system as percentages and to identify any significant differences between the approaches we are evaluating. Using this quantified value, we can then understand how fast each approach is compared to the baseline.


=== Development complexities <development_complexities> 

When using external crates, they usually come with their own learning curve and documentation. This can add to the development time, especially if the crate is not well-documented or has a complex API. Additionally, integrating external crates into an existing codebase can sometimes lead to compatibility issues or require significant refactoring. Quantifying this is difficult, as it depends on the developer's experience, familiarity with the crate, and the specific requirements of the project. 
We have decided to instead focus on a qualitative analysis of the development complexities, based on the given available data by the crates maintainers and our experience during the implementation of each approach. This will include factors such as the ease of use of the crate's API, the quality of its documentation, and any challenges faced during integration.

We expect that the dynamic library loading approaches (Rust ABI and C ABI) may have higher development complexities compared to the IPC approach, due to the need to manage dynamic libraries, handle FFI (in the case of C ABI), and ensure compatibility between the plugin and host application. The IPC approach may have lower development complexities in terms of integration, as it allows for more decoupled communication between processes, but it may require more complex software design to handle serialization and inter-process communication effectively.

We will evaluate each approach with a ++, +, 0, - or \-\- based on the following criteria:

- *++*: The approach is straightforward to implement, with a clear and well-documented API, and requires a low amount of additional setup or configuration. The crate offers good documentation and examples, making it easy for developers to understand and use effectively.
- *+*: The approach is generally manageable to implement, but may require some additional setup or configuration. The crate has decent documentation, but may have some gaps or areas that are not well-explained, which could lead to some challenges during development.
- *0*: The approach is neutral in terms of complexity, with neither significant advantages nor disadvantages in terms of implementation effort or documentation quality.
- *-*: The approach is complex to implement, with a steep learning curve, a poorly documented API, or significant additional setup or configuration required. 
- *\-\-*: The approach is very complex to implement, with a very steep learning curve, a poorly documented API, or significant additional setup or configuration required. Alternatively, the approach may have significant disadvantages for the developers, where it feels impossible to use effectively.

=== Language Limitations <limitations>

Each approach may come with some limitations for the developers use of the Rust language. In general, we want to see how an approach is limiting the use of the existing Rust features, capabilities and ecosystem.

Many of the approaches will refer to the C ABI, which is a common way to achieve a interoperability between Rust and other programming languages, but it also comes with some limitations in terms of the types of data that can be easily represented and the need to use unsafe code to interact with C libraries. Some Rust Types cannot be easily represented in C, which can lead to limitations in the C ABI approach. We also expect that the IPC approach may have limitations in terms of the types of data that can be easily serialized and deserialized, which could impact the flexibility of this approach. Typically, pointers and references are difficult to represent in C, while IPC might even struggle with more complex data structures that require custom serialization logic.

In some cases, Limitations may overlap with @development_complexities, as certain they may require additional development effort to work around or mitigate. For example, if a particular approach has limitations in terms of the types of data that can be easily represented or serialized, this may require additional development effort to implement custom serialization logic or to design the plugin architecture in a way that avoids these limitations.

Therefore we evaluate each approach with a 0, - or \-\- based on the following criteria:

- *0*: The approach has no significant limitations for developers, and can be used effectively in a wide range of scenarios without requiring significant workarounds or mitigation strategies.
- *-*: The approach has some limitations that may require developers to implement workarounds or mitigation strategies in order to use it effectively. These limitations may impact the flexibility or usability of the approach, but they are not insurmountable and can be managed with some additional effort.
- *\-\-*: The approach has significant limitations that may make it difficult or impractical for developers to use effectively or potentially even impossible to use in certain scenarios. 

=== Interoperability <interoperability>

Interoperability refers to the ability of a plugin system to work seamlessly with other libraries and tools, allowing for easy integration and compatibility with a wide range of use cases. This is an important factor to consider when evaluating different approaches to plugin systems, as it can impact the flexibility and usability of the system in real-world applications.

We perform a qualitative assessment of the interoperability of each approach based on the available documentation.

This is in many cases the core of a plugin system, as it determines how easily plugins can be integrated into the host application and how well they can interact with other libraries and tools. A plugin system with good interoperability will allow developers to easily create and integrate plugins that can work with a wide range of libraries and tools, while a plugin system with poor interoperability may require significant effort to create and integrate plugins, and may limit the functionality of the plugins that can be created.

While an ABI might the solution for the interoperability between an Application to it's plugins, it might not be the best solution for the interoperability between the plugins and other libraries and tools. Typically in cases, where high performance is not required, a communication over IPC might be a better solution for the interoperability between the plugins and other libraries and tools. Using simple data formats like JSON can already achieve the same effect, while typically being easier to implement and maintain than a complex ABI. However, this comes with the trade-off of potentially higher performance overhead due to the need for serialization and deserialization of data, as well as the communication overhead between processes.

In our test case, we only test the interoperability of the plugin system from a Rust Plugin to a Rust Host Application. For the rating, we are still interested in the operability to other languages.

Our rating for each approach will be assigned as ++, +, 0 based on the following criteria:

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

When developing a plugin system in Rust, there are several potential approaches that can be taken, each with its own set of advantages and disadvantages. In this section we will introduce different crates and give an overview of their functionality. Here, we mainly differentiate between ABI-based approaches @abi-approaches and IPC-based approaches @ipc-approaches. We will have a closer look at the chosen approach in the next section @selected_approach. The provided list doesn't represent all possible approaches, but rather common crates and methods that are used within the Rust ecosystem for plugin development. We purposefully added some newer crates, which are not as widely used, to give a more comprehensive overview of the available options for plugin development in Rust.

=== ABI approaches <abi-approaches>

Here, various crates and approaches to utilize the ABI <abi> for plugin systems in Rust are introduced, including the unstable Rust ABI, the abi_stable crate, the bindgen crate for C bindings, and the pyo3 crate for Python bindings. Each of these approaches has its own set of advantages and disadvantages in terms of performance, development complexity, limitations, and interoperability. The section also briefly mentions the use of WebAssembly (Wasm) as a potential approach for plugin systems in Rust.

==== Unstable Rust ABI

It is possible to load other Rust Libraries as plugins using the currently unstable Rust ABI. However, this approach is complicated by the fact that the Rust ABI is not stable. This means that the layout of data structures, the calling conventions, and other Aspects of the ABI can change between different versions of the Rust compiler, which can lead to compatibility issues when trying to load plugins compiled with different versions of Rust. Additionally, the Rust ABI is not designed for interoperability with other programming languages, which can further complicate the development of a plugin system that needs to interact with libraries or tools written in other languages.

==== abi_stable crate

The abi_stable crate enables stable, version-independent interoperability between Rust libraries and executables by generating a custom, C-like ABI that bypasses Rust's unstable internal layout guarantees, allowing dynamically linked shared objects to communicate safely even when compiled with different Rust compiler versions or feature flags. It achieves this through a macro-heavy approach (`#[sabi]`) that enforces strict trait bounds and generates wrapper code to handle memory layout, vtables, and function pointers, effectively creating a "Rust FFI" that is safer than raw extern "C" for complex types. However, this stability comes with significant trade-offs: the generated code introduces non-trivial runtime overhead due to extra indirection and dynamic dispatch, the API is verbose and requires extensive boilerplate that can obscure the underlying logic, and it currently lacks support for many modern Rust features like async/await or generic specialization, making it less suitable for performance-critical paths or projects prioritizing minimal binary size compared to simpler extern "C" or cxx solutions.

==== rust-bindgen

The bindgen crate automates the creation of Rust FFI bindings by parsing C or C++ header files using Clang to generate Rust extern blocks and struct definitions that mirror the original C API, effectively eliminating the manual, error-prone process of translating C types into Rust equivalents. It operates by invoking Clang to analyze the header syntax tree, resolving macros and complex type definitions, and outputting a Rust source file that can be integrated into a build script (build.rs) to ensure bindings stay synchronized with header changes. However, this automation introduces significant downsides: the generated code is often verbose, unreadable, and difficult to maintain manually, leading to large binary sizes; it tightly couples the Rust build process to the presence of a compatible Clang installation and the exact C headers, complicating cross-compilation and CI pipelines; and because it exposes the raw C API directly, it frequently forces developers to wrap the generated unsafe code in safe abstractions to prevent memory safety issues, adding an extra layer of development overhead despite the initial automation. @crate-bindgen

==== pyo3 (Python bindings) 

The pyo3 crate enables seamless bidirectional interoperability between Rust and Python by leveraging the Python C API to expose Rust functions, structs, and enums as native Python objects while allowing Rust code to call Python functions and manipulate Python objects with type safety. It operates through a macro-driven system where the `#[pyclass]` and `#[pymethods]` attributes generate the necessary C bindings and glue code, automatically handling reference counting, memory management, and the conversion of Rust types (like `Vec` or `String`) into their Python equivalents (like `list` or `str`) via the `IntoPy` and `FromPyObject` traits. By utilizing the Global Interpreter Lock (GIL) guard to ensure thread safety during Python interactions and providing a high-level API that abstracts away the complexities of the underlying C API, pyo3 allows developers to write performance-critical Python extensions in Rust that feel and behave like idiomatic Python code, all while maintaining the safety guarantees of the Rust compiler.

==== Wasm (WebAssembly)

Using WebAssembly with Rust involves compiling Rust code to the `wasm32-unknown-unknown` target, a process streamlined by tools like wasm-pack and wasm-bindgen that bridge the gap between Rust's memory model and JavaScript's environment. By annotating Rust functions with ```rust #[wasm_bindgen]```, developers can automatically generate the necessary glue code to export Rust functions to JavaScript and import JS functions into Rust, handling complex type conversions (such as mapping Rust ```rust Strings``` to JS ```js strings``` and ```rust Vecs``` to typed ```js arrays```) and managing memory ownership across the boundary. This workflow typically starts by installing the `wasm32` target via `rustup`, writing Rust logic with the `wasm-bindgen` crate, running ```wasm-pack build``` to generate a .wasm binary and corresponding JavaScript/TypeScript bindings, and finally loading the resulting module in a browser or Node.js environment to execute high-performance, sandboxed code that interacts seamlessly with the host application.


=== Interprocess Communication (IPC) <ipc-approaches>

An alternative to using the ABI for plugin systems in Rust is to use Interprocess Communication (IPC) to allow plugins to communicate with the host application. This approach involves running the plugin as a separate process and communicating with it through a defined protocol, such as JSON-RPC or gRPC. The main advantage of this approach is that it allows for greater flexibility and decoupling between the host application and the plugins, as they can be developed and deployed independently, and can even be written in different programming languages. However, this approach also comes with some disadvantages, such as increased complexity in terms of software design and potential performance overhead due to the need for serialization and deserialization of data, as well as the communication overhead between processes. Additionally, this approach may require more effort to ensure that the communication protocol is robust and secure, especially if sensitive data is being transmitted between the host application and the plugins.

==== grpc-rust crate

The grpc-rust crate provides a Rust implementation of the gRPC protocol, allowing developers to create high-performance, language-agnostic RPC (Remote Procedure Call) services that can be used for interprocess communication in plugin systems. By defining service interfaces using Protocol Buffers and generating Rust code with the grpcio-compiler, developers can easily create gRPC servers and clients that communicate over HTTP/2, enabling efficient and scalable communication between the host application and plugins. However, while gRPC offers strong performance and a rich feature set (such as streaming and built-in authentication), it also introduces additional complexity in terms of setup and maintenance, as it requires managing Protocol Buffer definitions, handling serialization/deserialization overhead, and ensuring proper error handling and security measures are in place for interprocess communication. @crate-grpc-rust

Additionally, this approach is not specialized for plugin systems and will require further design and implementation work to create a plugin architecture that effectively utilizes gRPC for communication between the host application and plugins. This may involve defining a clear protocol for how plugins should register themselves, how they will be discovered by the host application, and how they will handle requests and responses in a way that is consistent with the overall design of the plugin system. 

==== rustbridge crate

As stated by the rustbridge crate entry, "rustbridge lets you write shared library plugins in Rust that can be called from Java, Kotlin, C\#, Python, Go, Erlang, or another version of Rust — without dealing with the C ABI directly." @crate-rustbridge

To accomplish this, they wrap a Rust plugin in a `rbp` bundle, which is a zip file containing the plugin's shared library and a manifest file that describes the plugin's API and metadata. The rustbridge runtime then loads the `rbp` bundle, reads the manifest to understand the plugin's API, and uses dynamic loading to call the plugin's functions from the host application. This approach abstracts away the complexities of dealing with the C ABI directly, allowing developers to write plugins in Rust that can be easily integrated into applications written in various programming languages. However, this approach also introduces some overhead due to the need for dynamic loading and the additional layer of abstraction provided by the rustbridge runtime, which may impact performance compared to more direct approaches like using the unstable Rust ABI or the abi_stable crate. 

Communication is done by JSON-RPC, which is a remote procedure call (RPC) protocol encoded in JSON. It allows for communication between a client and a server, where the client can call methods on the server and receive responses. This means that the plugin can be developed in Rust and communicate with the host application using a standardized protocol, which can be easily implemented in various programming languages. However, this also means that there may be some performance overhead due to the need for serialization and deserialization of data, as well as the communication overhead between processes.

In addition, a developer can write the communication protocol by themselves, by using the binary transport layer provided by rustbridge, which allows for more efficient communication between the host application and the plugin, but also requires more effort to implement and maintain compared to using a standardized protocol like JSON-RPC. @crate-rustbridge-transport-layers


== Selected approach and detailed solutions <selected_approach>

When choosing the approach for further analysis, we decided to take a closer look at the *Unstable Rust ABI*, the *abi_stable* crate, the *stabby* crate and on the *rustbridge* crate. We chose those, because they represent a good variety of approaches to plugin systems in Rust, ranging from direct ABI manipulation to IPC-based communication. 

The *Unstable Rust ABI* approach is interesting because it represents the most direct way to load Rust plugins, but it also comes with significant challenges due to the instability of the Rust ABI.

To provide stability to the Rust ABI, the *abi_stable crate* generates a custom, C-like ABI that allows for version-independent interoperability between Rust libraries and executables. This approach is interesting because it provides a solution to the instability of the Rust ABI, but it also comes with its own set of trade-offs in terms of performance and complexity. 

The creator of the *stabby crate* want to achieve the same goal as the abi_stable crate, but with different goals. The stabby crate generates a custom ABI that is designed to be stable across different versions of Rust, but it does so by using a more lightweight and flexible approach compared to the abi_stable crate. This makes it an interesting alternative to the abi_stable crate, as it may offer better performance and ease of use while still providing stability for plugin systems in Rust.

Finally, we used the *rustbridge crate* as an example for an IPC-based approach to plugin systems in Rust, using JSON-RPC to communicate between processes. Its main focus are plugins written in Rust, which can then be used in various languages, making it especially versatile for interoperability. In addition it also allows to transport data via a binary transport layer, which gives a developer a lot of freedom to design their own communication protocol.

Due to the scope of this thesis, we did not invest time into the WebAssembly (Wasm) approach, as it is different compared to the other approaches, and it would require a significant amount of additional research and implementation effort to properly evaluate it in the context of plugin systems in Rust. 
WebAssembly (Wasm) is not covered in this paper.

/*

=== Rust Types and ABI Instability

// ADD SOURCE HERE
Relevance to Rust: In the context of Rust, the lack of a standardized ABI is a deliberate design choice. As noted by the Rust compiler team, the ABI is "deliberately unstable" to allow the compiler to optimize memory layouts and calling conventions aggressively without being constrained by backward compatibility requirements (Rust Internals, 2020). This contrasts with the C ABI, which is strictly defined and stable, serving as the de facto standard for binary interoperability.


@stabby-tutorial-abi-stable-types

// ADD PICTURES AND MEMORY LAYOUT EXAMPLES HERE

*Product types* (or structs): is it ordered? is it aligned?

C is always aligned and source-ordered.

Rust fields are also aligned, but the order is minimized for memory usage.

Rust can enforce this by using #[repr(C)], but this is not the default, and the compiler can change the layout for optimization purposes. This means that without explicit annotations, the memory layout of a Rust struct is not guaranteed to be stable across different compiler versions or optimization levels, which can lead to binary incompatibility when used in a plugin system.



*Sum types* (or enums): how to distinguish the variants? where is the data?

Not supported by C. Can be done using a tagged union, but you need to give each type a specific number (usually a enum).

Rust may be put in a niche (like common padding or using type's forbidden value).

Example with ``Cow<'a, str>``: Can waste 7 bytes for padding on a 64-bit architecture.

Rust guarantees that the layout of a sum type is not clashing with the layout of a product type.

*Unit types* (()): are they zero-sized? what about references?

Doesn't exist in C as zero-sized type. ZSTs are undefined behavior.

#line()

As Pierre states, for a stable ABI all linkees must agree on an ABI for each symbol @stabby-tutorial-abi-stable-types (double check, maybe i need to link the talk instead...).

Note stable due to changes in compiler version, optimization level, target architecture, using `-Z randomize-layout` and so on. This is a fundamental problem for plugin systems in Rust, as the host and the plugin may be compiled with different versions of the compiler or different optimization flags, leading to binary incompatibility.

A few examples as to why the rust ABI is not stable yet can be found in niche optimizations: enums with multiple data variant optimizations (1.65), field ordering optimizations (1.67), `Cow<str>` regression (1.70), and more.

The primary challenge in Rust plugin systems is ensuring that the host and the plugin, potentially compiled with different compiler versions or optimization flags, agree on the binary representation of data and function calls.

/*Benches are run with the following set of configurations:
- run app "regularly" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)
*/

*/