
/*
 Introduce the problem, explain the significance of the problem and the motivation for
the thesis.
 Just by reading your Introduction and your section Conclusion and future work, a reader
unfamiliar with the subject area should be able to understand which problem you are
solving in which field, and within what scope you found a solution.
*/

= Introduction <intro>

// First: Why plug ins?
Modern software systems increasingly demand flexibility and extensibility. Plugin architectures have emerged as a fundamental pattern for achieving this goal, enabling applications to load additional functionality at runtime without recompilation. As highlighted by Apple's technical documentation, "Plug-in architectures are an attractive solution for developers seeking to build applications that are modular, customizable, and easily extensible" @apple-plugin.

// Second: Why Rust? and why ABI bad for plugins?
The rise of the rust language popularity has led to an increased interest in using Rust for plugin development. Rust has established itself as a powerful systems programming language that offers memory safety guarantees and performance characteristics. However, the language's design philosophy prioritizes compile-time guarantees over binary stability, resulting in an intentionally unstable Application Binary Interface (ABI). Small changes in your written code, can impact the resulting binary in a way that it is not compatible with the previous version. With that being said, we can circumvent this problem by using other approaches.

// Other options: C ABI
One popular approach is to use C ABI-compatible interfaces, which can provide a stable interface for plugins while still allowing developers to write their plugins in Rust. The C ABI has been the backbone for many plugin systems in various programming languages, including the Rust ecosystem. But this approach requires the careful handling of unsafe code and can lead to some performance overhead due to the need for FFI (Foreign Function Interface) calls. In addition, this can lead to the loss of Rust's safety guarantees, as the C ABI does not provide the same level of safety as Rust's native interfaces. 

// Other options: IPC
Another approach is to use Inter-Process Communication (IPC) mechanisms, which can provide a more flexible and scalable architecture for plugin systems. However, this approach can also introduce additional complexity and overhead, as it requires the management of separate processes and communication channels. This will impact the performance of the plugin system, as IPC can introduce latency and reduce the overall efficiency of the system. However, it can provide better isolation and security for plugins, as they run in separate processes. 

// Research Questions
In this thesis, we are interested in understanding how different approaches within the Rust Ecosystem try to solve this problem, and therefore we want to evaluate them based on the performance overhead using a simple benchmark, the resulting development complexity, language limitations and interoperability.




/*

Rust has gained significant adoption for systems programming due to its unique combination of memory safety guarantees and zero-cost abstractions. These properties make it theoretically well-suited for plugin development, where security and performance are often critical concerns. However, Rust's design philosophy prioritizes compile-time guarantees over binary stability, resulting in an intentionally unstable Application Binary Interface (ABI). This creates a fundamental tension: how can developers build robust plugin systems in a language that explicitly avoids guaranteeing binary compatibility? This will also 
*/

/*
== Motivation

=== Plugin Systems need dynamic linking

Rust does not have a stable ABI, which means that the compiler can make changes to the way it generates code that can break compatibility with existing binaries. This makes it difficult to create plugins that can be loaded at runtime, as the plugin and the host application may not be compatible.

=== Staying true to Rust's features

When leaving the Rust ecosystem (like using C Abi), you lose some of the features that Rust provides, such as memory safety and type safety. This can make it more difficult to write plugins that are safe and reliable.

== Research Questions

Understanding the advantages and disadvantages of different approaches to designing a plugin system in Rust can help developers make informed decisions about how to implement their own plugin systems. This research can also contribute to the broader understanding of how to design extensible systems in Rust, which can benefit the Rust community as a whole. (Okay that last sentence just screams AI :))
*/

