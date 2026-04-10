
/*
 Introduce the problem, explain the significance of the problem and the motivation for
the thesis.
 Just by reading your Introduction and your section Conclusion and future work, a reader
unfamiliar with the subject area should be able to understand which problem you are
solving in which field, and within what scope you found a solution.
*/

= Introduction <intro>

// First: Why plug ins?

Plugin architectures have become a cornerstone of modern software engineering, enabling systems to scale and adapt without monolithic rewrites. As highlighted by Apple's technical documentation, "Plug-in architectures are an attractive solution for developers seeking to build applications that are modular, customizable, and easily extensible" @apple-plugin.



// Second: Why Rust?


// Third: Rust difficult to dynamically extend



// Third: 





/*
Modern software systems increasingly demand flexibility and extensibility. Plugin architectures have emerged as a fundamental pattern for achieving this goal, enabling applications to load additional functionality at runtime without recompilation. From web browsers loading extensions to IDEs supporting custom language servers, plugin systems underpin much of today's software ecosystem.

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

