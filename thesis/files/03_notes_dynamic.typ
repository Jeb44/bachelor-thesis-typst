= Notes that i learned about dynamic plugin approach =w=

== Rust ABI

Same Compiler Version! Version 2024 requires some "unsafe" code...

Loading requires some unloading. 

After loading, we need to "pin" the data, otherwise it will be dropped after the function call, which can lead to a segfault. @rust-ref-dylib




