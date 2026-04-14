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

When measuring our plugins, we expect that the execution time of the plugin's internal functionality to be relatively similar across different approaches. However, the setup time for each approach is expected to vary, with approaches that require more complex initialization (e.g. loading a dynamic library, setting up IPC communication, serialization) likely to require more time.

We expect that the IPC approach will have higher performance overhead compared to the other approaches due to the need for serialization and deserialization of data, as well as the communication overhead between processes. This is because IPC typically involves more complex interactions between processes, which can introduce additional latency compared to approaches that operate within a single process. We expect the measurements for the Rust ABI and C ABI approaches to be more similar to each other, as they both involve loading and executing code within the same process, albeit with different calling conventions and potential overhead from FFI in the case of the C ABI approach.

To measure the results, we are using the _criterion_ and _gungraun_ crate for our benchmarks. The results of these will be separated into setup time and function execution time, which allows us to analyze the overhead of each approach in more detail.

As noted by the criterion documentation, the criterion crate is a statics-driven micro-benchmarking library, which aims to provide strong statistical confidence in detecting and estimating the size of performance improvements and regressions @doc-criterion. As stated by the gungraun documentation, "gungraun is a one-shot benchmarking harness and framework which uses Valgrind's Callgrind, Cachegrind, and DHAT to provide extremely accurate and consistent measurements of Rust code, making it perfectly suited to run in environments like a CI" @doc-gungraun.

We hope by combining both of these tools, we can get a comprehensive understanding of the performance characteristics of each approach, and how they compare to each other in terms of setup time and function execution time.

In Rust benchmarking, wrapping inputs and intermediate values in black_box is essential to prevent the compiler from optimizing away the code you intend to measure. Because Rust's optimizer is aggressive, it may detect that a function's result is unused or that an input is constant, leading it to eliminate the entire computation or hoist it out of the loop, resulting in artificially low (and inaccurate) timing data. The std::hint::black_box function acts as an opaque barrier, signaling to the compiler that the value is unknown and must be treated as having side effects, thereby forcing it to execute the code exactly as written within the benchmark. @doc-black-box Each benchmark will be run with and without black_box to compare the results and understand the impact of compiler optimizations on our measurements.

=== Development complexities <development_complexities> 

When using external crates, they usually come with their own learning curve and documentation. This can add to the development time, especially if the crate is not well-documented or has a complex API. Additionally, integrating external crates into an existing codebase can sometimes lead to compatibility issues or require significant refactoring. Quantifying this is difficult, as it depends on the developer's experience, familiarity with the crate, and the specific requirements of the project. 
We have decided to instead focus on a qualitative analysis of the development complexities, based on the given available data by the crates maintainers and our experience during the implementation of each approach. This will include factors such as the ease of use of the crate's API, the quality of its documentation, and any challenges faced during integration. After summarizing these, we will 

We expect that the dynamic library loading approaches (Rust ABI and C ABI) may have higher development complexities compared to the IPC approach, due to the need to manage dynamic libraries, handle FFI (in the case of C ABI), and ensure compatibility between the plugin and host application. The IPC approach may have lower development complexities in terms of integration, as it allows for more decoupled communication between processes, but it may require more complex software design to handle serialization and inter-process communication effectively.

// Explain +, = and -? >w<

=== Limitations <limitations>

Each approach may come with some limitations for the developers. For example, some Rust Types cannot be easily represented in C, which can lead to limitations in the C ABI approach. We also expect that the IPC approach may have limitations in terms of the types of data that can be easily serialized and deserialized, which could impact the flexibility of this approach. Additionally, the IPC approach may require more complex software design, which could be a limitation for developers who are not familiar with this type of architecture.

Because we are also working with different ABI solutions, there can be complexities in regards of their restrictions and limitations.

In some cases, Limitations may overlap with @development_complexities, as certain limitations may require additional development effort to work around or mitigate. For example, if a particular approach has limitations in terms of the types of data that can be easily represented or serialized, this may require additional development effort to implement custom serialization logic or to design the plugin architecture in a way that avoids these limitations.



// Explain +, = and -? >w<

=== Safety <safety>

The Rust Language is designed with safety in mind, and it provides strong guarantees against common programming errors such as null pointer dereferences, buffer overflows, and data races. // Typically, errors occur through the careless usage of unwinding. @nomicon_unwinding

Yet, this does not result in formal verifications, like DO-178C or IEC 61508, which are often required in safety-critical domains. However, the Rust ecosystem has been making strides in this area, with efforts to achieve certifications for certain subsets of the Rust language and libraries, such as the recent achievement of IEC 61508 (SIL 2) certification for a subset of the Rust core library by Ferrous Systems @rust-blog-safety-critical @ferrous-systems-iec-61508.

From this, we can infer that while Rust provides strong safety guarantees, the level of safety can depend on the specific approach used for plugin integration. For example, approaches that involve unsafe code (such as FFI in the C ABI approach) may require more careful handling to ensure safety, while approaches that operate entirely within safe Rust (such as the Rust ABI approach) may provide stronger safety guarantees by default. The IPC approach may also have its own safety considerations, such as ensuring that data is properly validated and that communication channels are secure.

For this thesis, we do not consider it appropriate to perform a quantitative or qualitative analysis of the safety of each approach, as this would require a detailed examination of the specific implementation and usage patterns, which may be beyond the scope of this research. 


=== Interoperability <interoperability>

How flexible are the presented approaches? Can they be linked with other libraries?

// WRITE LATER QwQ


== Potential approaches and problems

// CONTINUE HERE QWQ

when analyzing the C ABI, we will discover, that different crates handle different parts... differently (sum types and so on)



=== Rust ABI

==== Unstable Rust ABI

==== abi_stable crate


=== C ABI


==== rust-bindgen /  cbindgen (could be moved to III.B.d) )

==== other c abi crates? (overview)

==== stabby crate



=== Interprocess Communication (IPC)

different structure. communication over serialization

positive: interoperability, less complexity during development

negative: performance overhead, more complex software design

==== rust_bridge crate

==== other ipc crates? (overview)


== "Selected approach and detailed solutions"


/*Benches are run with the following set of configurations:
- run app "regularly" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)
*/

