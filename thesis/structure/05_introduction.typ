
/*
 Introduce the problem, explain the significance of the problem and the motivation for
the thesis.
 Just by reading your Introduction and your section Conclusion and future work, a reader
unfamiliar with the subject area should be able to understand which problem you are
solving in which field, and within what scope you found a solution.
*/


= Introduction


== Motivation

=== Plugin Systems need dynamic linking

Rust does not have a stable ABI, which means that the compiler can make changes to the way it generates code that can break compatibility with existing binaries. This makes it difficult to create plugins that can be loaded at runtime, as the plugin and the host application may not be compatible.

=== Staying true to Rust's features

When leaving the Rust ecosystem (like using C Abi), you lose some of the features that Rust provides, such as memory safety and type safety. This can make it more difficult to write plugins that are safe and reliable.

== Research Questions

Understanding the advantages and disadvantages of different approaches to designing a plugin system in Rust can help developers make informed decisions about how to implement their own plugin systems. This research can also contribute to the broader understanding of how to design extensible systems in Rust, which can benefit the Rust community as a whole. (Okay that last sentence just screams AI :))


