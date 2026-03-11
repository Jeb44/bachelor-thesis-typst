= Development Complexity

Pure Quantitative measurement not possible, but general qualitative evaluation of the development complexity of each approach.

Imporatnt? Introduce "Limitations" here too??

My personal priority for measurements:
- Documentation (Seitenanzahl, etc.)
- Logical Complexity (different name... ) i.e. ECS changes how you think of your Code
- Restrictions (like Types; FFI boundaries)
- Memory and Runtime effects
- Robustness: Unstable Rust ABI 

Useful measurements:
- Unsafe Code / Memory Safety / Undefined Behaviour
- Error Recovery / Error Messages Clarity
- Lines of Code
- Learning Curve
- Community Support (aktive Developer, offene Issues, ...)

Not quite as useful measurements:
- Code Readability
- Code Maintainability
- Breaking changes between versions
- Tooling
- Dependency depth


For me currently a bit too early to give my personal ratings. By trying to implement each approach, I hope to get better understanding of each approach.

= Scientific Methods

If trying for quantitative measurements, we can use the following metrics:

Structural Metrics:

- Cyclomatic Complexity - Measures independent control-flow paths (McCabe, 1976)
- Cognitive Complexity - Weights nesting and readability for human comprehension
- Halstead Metrics - Derived from operator/operand counts
- Coupling Between Objects (CBO) and Lack of Cohesion of Methods (LCOM) - Measure module interdependencies


Functional Size Measurement:

- COSMIC Framework - Quantifies complexity by counting data movements and manipulations within functional processes (Common Software Measurement International Consortium)
- Number of Overridden Methods (NOD) and Number of Children (NOC) - Object-oriented metrics shown to correlate strongly with development effort



== For Unstable Rust ABI

Documentation is generally good, but the specific details about the unstable Rust ABI and its implications for dynamic loading can be a bit sparse. The documentation often assumes a certain level of familiarity with Rust's internals.

Implementing dynamic loading is otherwise relative simple for the developer. However, the complexity arises from understanding the implications of using an unstable ABI, such as potential breaking changes and the need for careful management of memory safety and error handling. In addition, version compatibility can be a concern, as changes to the unstable ABI could potentially break existing code that relies on it. This is espcially gruesome when you have to define a version for the whole code base...

Since we are sticking to Rust, all Rust features are accessible.

Libloading only does low level symbol loading: https://users.rust-lang.org/t/libloading-segfault/56848
Everything is a '\*const c_void'

Notes about Vtable:
- VTables aren't stable ABI
- VTable becomes invalid when library is unloaded
- cross-boundary requires the exact same compiler version (so the same vtable is created)
per-trait per-type combination at compile time - stored in read-only data secion (.rodata), not exported as named symbols?

Libray/Symbol in libloading: https://users.rust-lang.org/t/how-to-avoid-library-and-symbol-drops-in-crate-libloading/85701

ELF (Linux): https://man7.org/linux/man-pages/man5/elf.5.html / https://gabi.xinuos.com/
┌─────────────────────────┐
│ ELF Header              │ ← Entry point, section count
├─────────────────────────┤
│ Program Headers         │ ← Memory segments to map
├─────────────────────────┤
│ Section Headers         │ ← Symbol tables, strings
├─────────────────────────┤
│ .text (code)            │ ← Executable instructions
├─────────────────────────┤
│ .data (initialized)     │ ← Global variables
├─────────────────────────┤
│ .dynsym (dynamic sym)   │ ← Exported symbols
├─────────────────────────┤
│ .dynstr (string table)  │ ← Symbol names
├─────────────────────────┤
│ .rel/.rela (relocations)│ ← Address fixups
└─────────────────────────┘

*Library::open() and Symbol::get()*:
1. Open file
  └─> OS validates format, checks permissions
2. Map into memory
  └─> Memory-mapped file (mmap on Unix, CreateFileMapping
  on Windows) - lazy page faults on access
3. Process relocations
  └─> Fix up addresses in code/data that reference
  absolute locations (PIE libraries may skip this)
4. Resolve dependencies
  └─> Load any other libraries this one depends on
5. Run initialization
  └─> Execute .init_array / CRT startup code
6. Symbol lookup
  └─> Search .dynsym for symbol name, return address

Adress calculation: actual_address = base_load_address + symbol_offset
Type casting:

let ptr = dlsym(handle, b"my_function");  // Returns *mut c_void
let func = transmute::<\*mut c_void, fn()>(ptr);  // Type cast
