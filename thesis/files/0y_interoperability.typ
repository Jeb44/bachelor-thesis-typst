see lumo uwu

== Interoperability

Interoperability Categorization (European Open Science Cloud (EOSC) framework):
- Syntactical Level
- Technical Level
- Semantic Level

Rust: FFI (Foreign Function Interface)

Targeting "C ABI" will allow for wider interoperability with other languages that can also target C ABI, such as C, C++, Python (via ctypes), and many others.

Unstable Rust ABI is not guaranteed to be stable across compiler versions, and it may change without warning. This means that if you are writing Rust code that will be called from other languages, you should not rely on the Rust ABI being stable. Instead, you should use the C ABI, which is a well-defined and widely supported calling convention that is stable across different compilers and platforms.

'#[no_mangle]' is used to prevent the Rust compiler from changing the name of the function, which is necessary for interoperability with other languages that expect a specific function name.

'extern "C"' or 'extern "Rust"'. 

"unsafe" code blocks to cross boundaries.


== Sources:
- EOSC "Technical and semantic interoperability in cross-domain use cases": https://fair-impact.eu/technical-and-semantic-interoperability-cross-domain-use-cases
- Zenodo "D6.1 - Guidelines for the usage of components for technical and semantic interoperability in cross-domain use cases": https://zenodo.org/records/15527557
- https://doc.rust-lang.org/std/ffi/index.html
- https://doc.rust-lang.org/nomicon/ffi.html
- "Rust and Co Comparison": https://blog.jetbrains.com/rust/2025/06/12/rust-vs-go/
- 


