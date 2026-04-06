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

For a "software-heavy" Bachelor thesis, you'll know you're on the right level of abstraction if
you can give your Bachelor thesis to someone and they are able to re-implement your work
in a different programming language.
If this is possible, then you have covered all the relevant details on the level of the
design and the structure, independently of a particular programming language.
Implementation details on the level of specific C/C++/Java constructs are generally only
added (and then frequently only as an appendix), if these concern less relevant
implementations of the interrelationships otherwise already presented. UML diagrams
generally provide sufficient and adequate means of expression.
*/

= Methods

== "Analysis of the requirements"



Goal of the research was to analyse the following points:
- performance
- development complexities
- limitations
- safety
- interoperability



=== Performance Overhead

In this thesis, we are interested in the performance overhead when calling the plugin system's API. To achieve this, we will first measure the setup time (i.e. loading a library into memory, creating an object, ...), then we measure the actual function execution time. This approach will be tested against a simple temperature fusion, with parameters ranging from one sensor to one million sensors.

The expected result is that the setup time will be higher for approaches that require more complex initialization (e.g., C ABI with manual FFI), while the function execution time should be relatively similar across approaches, with some overhead for approaches that involve more indirection (e.g., C ABI with dynamic loading). For the IPC approach, the performance overhead will likely be higher due to the need for serialization and deserialization of data, as well as the communication overhead between processes.

To measure the results, we are using the criterion and gungraun crate for our benchmarking. The written benchmark will give us separate results for the setup time and the function execution time, which allows us to analyze the overhead of each approach in more detail.

As noted by the criterion documentation, the criterion crate is a statics-driven micro-benchmarking library, which aims to provide strong statistical confidence in detecting and estimating the size of performance improvements and regressions. @doc-criterion

As stated by the gungraun documentation, "gungraun is a one-shot benchmarking harness and framework which uses Valgrind’s Callgrind, Cachegrind, and DHAT to provide extremely accurate and consistent measurements of Rust code, making it perfectly suited to run in environments like a CI." @doc-gungraun

We hope by combining both of these tools, we can get a comprehensive understanding of the performance characteristics of each approach, and how they compare to each other in terms of setup time and function execution time.

In Rust benchmarking, wrapping inputs and intermediate values in black_box is essential to prevent the compiler from optimizing away the code you intend to measure. Because Rust's optimizer is aggressive, it may detect that a function's result is unused or that an input is constant, leading it to eliminate the entire computation or hoist it out of the loop, resulting in artificially low (and inaccurate) timing data. The std::hint::black_box function acts as an opaque barrier, signaling to the compiler that the value is unknown and must be treated as having side effects, thereby forcing it to execute the code exactly as written within the benchmark. @doc-black-box Each benchmark will be run with and without black_box to compare the results and understand the impact of compiler optimizations on our measurements.

/*Benches are run with the follolwing set of configurations:
- run app "regarulary" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)
*/


=== Evaluation

Gunguan helps us see the internal required instructions on "my" CPU. This result should correlate with the actual run time using criterion. We can then reason about the expected overhead of a choosen approad.

=== Development complexities

Subjective, but also Qualitative Meaurement

How will this impact a development team? This might just be an extra Evaluation of Limitations


=== Limitations

Might be part of "complexities"??

Qualitative Meaurement

=== Safety

Atemmpting Quantative by using safety levels.

Rust Lanuage generally very safe. Errors often need to be "forced" or careless usage of unwinding. @nomicon_unwinding

=== Interoperability

How flexible are the presented approaches? Can they be linked with other libraries?


== "Potential approaches and problems"

baseline for loading libs is the libloading crate

when analysing the C ABI, we will discover, that different crates handle different parts... differently (sum types and so on)



=== Unstable Rust ABI


=== C ABI


=== IPC

different structure. communication over serialization


== "Selected approach and detailed solutions"

Technically speaking i am covering many approaches...

=== Unstable Rust ABI / Libloading basics



=== Stable Rust ABI (crate)



=== C ABI





=== Crate "stabby"?)



=== Other crates (although no focus here)




=== Crate "rust_bridge" (googling this is horrible qwq)



=== Other crates


== "Software design"


== Implementation


