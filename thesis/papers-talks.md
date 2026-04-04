# Introduction

Document for pre-sorting rust talks and papers...

## From Rust to C and Back Again

An introduction to "foreign functions"

*From*: Seattle Rust Group, April 2025

*By*: Jack O'Connor

[Talk](https://www.youtube.com/watch?v=B4yNqR0WgYQ)
[Slides](https://jacko.io/rust_c/slides/)
[Repo](https://github.com/oconnor663/rust_c/tree/seattle_rust)
[Long Version](https://www.youtube.com/watch?v=LLAUzghhNHg)
[Long Version Repo](https://github.com/oconnor663/rust_c)

Shows how to set up build scripts for rust (which can compile "other" C or Rust code) and then itegrate it into your app.

**TODO**: Watch the long version =w=

## Shipping Rust to Python, Typescript and Ruby Users

*From*: Seattle Rust Group, April 2025

*By*: Sam, Jijin

[Talk](https://www.youtube.com/watch?v=Zs6Uer3VAyQ)
[Slides](https://docs.google.com/presentation/d/1jY7m_Ywg8lxSSrOxwCXIuAVvY8j_qdAc58tKN7ht6-Q/edit?slide=id.p&pli=1#slide=id.p)
[pyo3-demo](https://github.com/sxlijin/pyo3-demo)
[Releated Talk "Shipping Rust to Python, Typescript, and Ruby Users"](https://www.youtube.com/watch?v=ve33hCLHbcg)

Talk shows what Rust objects need to implement for Rust, NodeJS and Ruby objects. Ruby is not working super well with Rust...
Rust Future don't work well in Python and requries manual signal handling (because tokio takes control "over pthon"). Use Async Bridges from crates 'pyo3' or 'napi'.

## Fine! I'll just make my own stable ABI

*From*: RustConf 2023

*By*: Pierre Avital, PhD

[Talk](https://www.youtube.com/watch?v=qkh8Fs2c4mY)

First up: IPC should be prefered over Dynamic linked plugins
But: IPC are slower due to serialization

ABI: Calling conventions (registers, return, arguements, "how to call"), Type representation (Product *structs*, Sum *snum*, unit *()*). For each of those different criterias can be analyzed (fields overload, aligned, variants, data, zero-sized, references, ...).

Rust ABI not stable. Changes like compiler version, optimization levels or compiler flags like '-Z randomize-layout' can change the ABI.

Presenter shows their own implementation for a ABI using their crate 'stabby'!
*NOTE*: non-nightly >= 1.78 versions of Rust have performance issues
Main advantage here is the reduction of the size for sum-types (enums)

Stabby uses C ABI, but warns for suboptimal struct layouts (same logic to C where the order inside the field defines the memory layout). It will build a stable V-table for traits (assuming all parameters (exect self) are **sized**)! Allows for reflections!

Limitations are:

- Enums cannot be *pattern matched*, but it can be worked around
- cannot impl IStable for *generic lifetimes*
- ...

## async & FFI - not exactly a love story

Async programming in Rust isn't a simple affair when running a pure-rust application. Unsurprisingly, when trying to combine Rust with another language, and expose async interfaces that cross the language barrier, there are plenty of potential mistakes to make. In this talk we'll discuss some of the pitfalls awaiting those who try to cross the language barrier.

[Talk](https://www.youtube.com/watch?v=z3tpB94VKwU)
[Related Talk "Programming for Every Language, Everywhere, All at Once"](https://www.youtube.com/watch?v=43Tmqn-sFsk)

Explains FFI (got enough of that for now) but also **Marshalling**: Convert data to useable form through FFI, string endcoding, endianess, callbacks, ensure that garbage collector doesn't mess things up...

## Miri, Undefined Behavior and Foreign Functions

Do you want to write unsafe Rust but don't know how to check its soundness? Do you suspect that your program has Undefined Behavior but you have no way to test it? Are you looking for a cool Rust-related project to contribute to? Then this talk is for you.

*From*: RustFest Global 2020

[Talk](https://www.youtube.com/watch?v=ltayS6B8kGM)
[Talk Website](https://rustfest.global/session/12-miri,-undefined-behavior-and-foreign-functions/)

Goes into "undefinded behaviour" and why it's bad, but also the good and bad part about it... **Miri** can detect *almost* all cases of UB when interpreting rust code. Miri's engine is responsible to compile time function evaluations!

He then also explains where Miri (MIR) is used during the compilation process of Rust.

Miri *cannot* detect data races. And is slow! It can also emulate foreign functions (shims).

## Diplomat - Idiomatic Multi-Language APIs

*From*: Rust Zürisee March 2024

*By*: Robert Bastian

[Talk](https://www.youtube.com/watch?v=q5gh-XX1_Ws)
[Repo](https://github.com/robertbastian/diplomat)

[Diplomat is an] experimental Rust tool for *generating FFI definitions* allowing many other languages to call Rust code. With Diplomat, you can simply define Rust APIs to be exposed over FFI and get high-level C, C++, and JavaScript bindings automatically!

## JavaScript at the speed of Rust: Oxc

*From*: ViteConf 2025

*By*: Jim Dummett

[Talk](https://www.youtube.com/watch?v=ofQV3xiBgT8)

Interesting in general, but doesn't touch upon plugin and dynamic and so on...

## Fine-Grained C++ Interop

Adopting Rust in large C++ projects presents a difficult choice: perform a costly, large-scale rewrite, or refactor code to accommodate the limitations of traditional interop solutions such as bindgen or cxx. This talk will discuss how high-fidelity Rust/C++ interoperability can offer a seamless path for gradual adoption using language and compiler extensions.

*From*: RustConf 2025

*By*: Tyler Mandry & Taylor Cramer

[Talk](https://www.youtube.com/watch?v=Z5M4NIWoMJQ)

Old code is good, but migrating to newer tools (rust, cargo, ...) brings a consistent base. New code can be tricky and prone to errors. How to port?

Covers:

- State of Interops
- Missing Pieces
- Call for "better Rust"

Tools: *bindgen/cbindgen* (rust to c, c to rust), *cxx* (tries to solve the problem of bindgen), *zngur* (similar to cxx, but can specify size and alignment, therefore hard to use), *crubit* (project at google, tries to get maximum coverage of both APIs)

## Memory Safety Everywhere with Both Rust and

This talk will compare and contrast some of the interesting differences in the approaches taken in Rust and what we’re exploring in the Carbon Language experiment. Carbon was created to find out what a maximally incremental path to evolve and migrate off of C++ and onto a programming language with memory safety might look like, and whether it would be an effective way to bring memory safety to the largest-scale and most-brownfield of C++ software ecosystems.

*From*: RustConf 2025

*By*: Chandler Carruth

[Talk](https://www.youtube.com/watch?v=FYLuom6gg_s)

Talks about "Carbon"... Not interesting for me...

## Rust Interop: Memory Safety Across Foreign Function Boundaries

This talk explores how developers can bind, encapsulate, and call foreign functions, and identify disparities between Rust’s memory model and foreign memory models that make these tasks difficult. The talk also gives recommendations on *community guidelines and tooling* that can make Rust’s promise of static safety a reality across foreign boundaries.

*From*: RustConf 2024

*By*: Joannah Nanjekye

[Talk](https://www.youtube.com/watch?v=ohG-qxd4x6s)
[Related Paper](https://dl.acm.org/doi/10.1145/3605158.3605849)

The Paper itself is more about Python tho... The talk discusses the "Rust side" of things...

Definitely need to recheck!

Talks about theses technical challenges:

- *Memory model*
- *Pointer stability*
- *Lifetime complexity*
- Generation and verification
- Memory Allocation

## Rust and C++

Rust was designed to interoperate with other languages, but this interoperability is primarily based on C data structures and functions. This is limiting for C++ applications, because instances of C++ classes do not have a standardized representation in C. How can we expose Rust interfaces to C++ and the other way around?

*From*: EuroRust 2022

*By*: Tobias Hunger

[Talk](https://www.youtube.com/watch?v=WQAMJDS1tv4)

Demostrates cxx crate and how to integrate it into your build system.

## Runtime Scripting for Rust Applications

Rust is a statically typed, ahead of time compiled and memory safe programming language. But sometimes, the restrictions Rust puts on us developers can be a hindrance, for example when prototyping new application ideas or when you want your end users to be able to change your application’s runtime behavior. Thankfully, we can embed dynamically typed scripting languages with a lower learning curve into our Rust applications to get the best of both worlds.

In this talk, we will have a look at the scripting languages available to the Rust ecosystem and compare how well they integrate into Rust. Finally, we go through the process of embedding such a scripting runtime, Deno, into a Rust application and investigate how we can expose operations from our host applications to our scripts as well as share state between them.

*From*: EuroRust 2024

*By*: Niklas Korz

[Talk](https://www.youtube.com/watch?v=M8dpH3rO-2M)

Goes into various scripting languagues for rust, like WebAssembly, Rhai, Mun, Lua (mlua), Python, JS.

'deno_ast' is a transpiler...

## Safety in an Unsafe World

Rust doesn’t just support memory safety, it supports “X-safety”: The ability to teach Rust about arbitrary safety properties, only permitting X-safe code to compile. This talk will explore how this technique has been used to defend against everything from network protocol bugs to cryptographic vulnerabilities, demonstrate novel results based on Joshua’s research, and argue that if we take this aspect of Rust seriously, we can fundamentally reshape how software is written in safety-critical environments.

*From*: RustConf 2024

*By*: Joshua Liebow-Feeser

[Talk](https://www.youtube.com/watch?v=Ba7fajt4l1M)

Interesting, but not main focus of my thesis. Good for reasoning about handling "unsafe" code.

## Demystifying unsafe code

Unsafe code is something we, as Rust programmers, have a complicated relationship with. Some shrug it off as "it's fine, it's just C", while others declare any use of unsafe as irresponsible and a strike against any code that uses it. Many of us sit somewhere in between, often because we are unsure what this unsafe thing even really is. Is it truly as disastrous as some say, or is it really just harmless and overblown as others claim? In this talk, we explore the pages of the nomicon and take a look at what unsafe really means, why it is dangerous, why it is sometimes useful nonetheless, and how to deal with it responsibly.

*From*: Rust NYC

*By*: Jon Gjengset

[Talk](https://www.youtube.com/watch?v=QAz-maaH0KM)

## Dude, Where's My C?

*From*: Rust Global @ RustConf 2024

*By*: Walter Pearce

[Talk](https://www.youtube.com/watch?v=LZli45PPlss)

Analysis of unsafe code and crates...

Unsafe code VS. external unsafety are completely unrelated

Tool: Painter -> Graph of Rust Ecosystem... Sandboxed build of the world

## a

*From*: 

*By*: 

[Talk]()