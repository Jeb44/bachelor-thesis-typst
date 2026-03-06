= Stable Rust ABI (crate)

Calling Conventions, Where is Data saved and all that...

Some Source for this: https://doc.rust-lang.org/reference/items/static-items.html#static-items 

Rust ABI is not stable, which means that we cannot guarantee that the same binary will work with different versions of the compiler. This is a problem for dynamic plugins, as they need to be compiled separately from the main application.

https://doc.rust-lang.org/reference/abi.html


= "Technology"


== Introduction


== Analysis


=== Performance


=== Development complexities


=== Limitations


=== Safety


=== interoperability


== Evaluation?

