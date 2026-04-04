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



=== Performance

Only "pure" quantitative measurement will be the performance and maybe safety (using safety levels).

Using criterion and gungraun benchmarks. Not a perfect measurement, but it should give us enough hints about what happens behind the scenes.

Using black_box, we can ensure that the iternal code isn't hyper-optimized by the compiler, which can lead to more accurate benchmarks.

Gungruan uses valgrind internally.

Benchmark: To test all of this, we use a simple temperature simulation, where an random amount of sensors will pick up the data. 

Benches are run with the follolwing set of configurations:

- run app "regarulary" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)

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


