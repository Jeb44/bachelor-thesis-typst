#show table.cell.where(y: 0): set text(weight: "bold")

= Performance (Notes)

Quantative measurements: Use Benchmarks to evaluate Overhead for function calls using crates "Gungraun" (internally callgrind/valgrind) and "Criterion" (Execution Time).

This approach is not perfect, but it should give us enough hints about what happens behind the scenes. Benchmarks will be run with and without "black_box", which ensures that the internal code isn't hyper-optimized by the compiler. "black_box": Compiler treats the output as "unknownable" (hint: arguments are unpredictable, results are volatile).

Finally, the results of the benchmarks do need to be reasoned about, as the actual performance can be influenced by various factors, such as the specific hardware architecture, the complexity of the code being executed, and the specific implementation of the dynamic loading mechanism.

Using 'RUSTFLAGS="-C target-cpu=native" cargo bench' to ensure the best results for my system. When using dynamic loading, we ensure that the code is built in "release" mode. Benchmarks are separated into "Overhead" and "Actual Function Call". For example, the libloading overhead for (unstable) RUST ABI is ~230µs, but the actual function call performs at similar speeds compared to static implementations.

NOTE: "native" is not supported for all CPUs. Maybe choose a specific architecture? Current: AMD Ryzen™ 9 3900X x 24

TODO: Refill data with more fine-grained results... Also added Dynamic!! ('Box::new(AverageFuser{})')

#figure(
  table(
    columns: 4,
    [], [*Static*], [*Box\<dyn Fuser\>*], [*Unstable Rust ABI*],
    [*Creation*], [239.33 ps], [241.20 ps], [210.68 µs],
    [*Creation (blackbox)*], [244.64 ps], [248.88 ps], [214.22 µs],
    [*Function (single)*], [1.2431 ns], [1.2153 ns], [14.949 ns],
    [*Function (single, blackbox)*], [2.5452 ns], [2.4973 ns], [15.205 ns],
    [*Function (multiple)*], [870.21 µs], [848.04 µs], [],
    [*Function (multiple, blackbox)*], [908.36 µs], [885.02 µs], [],
  ),
  caption: [Execution times],
)

#figure(
  table(
    columns: 3,
    [], [*Static*], [*Unstable Rust ABI*],
    [*Creation*], [-], [6849],
    [*Creation (blackbox)*], [-], [6826],
    [*Function (single)*], [128], [7080],
    [*Function (single, blackbox)*], [293], [7097],
    [*Function (multiple)*], [259], [15012499],
    [*Function (multiple, blackbox)*], [16500892], [15012550],
  ),
  caption: [Estimated Cycles],
)

#figure(
  table(
    columns: 3,
    [], [*Static*], [*Unstable Rust ABI*],
    [*Creation*], [], [],
    [*Creation (blackbox)*], [], [],
    [*Function (single)*], [], [],
    [*Function (single, blackbox)*], [], [],
    [*Function (multiple)*], [], [],
    [*Function (multiple, blackbox)*], [], [],
  ),
  caption: [Instruction Count],
)



=== Sources

- "Scientific Methodology and Performance Evaluation for Computer Scientists" https://github.com/alegrand/SMPE
- "Code Performance" https://www.sciencedirect.com/topics/computer-science/code-performance
- "Profiling Tools" https://www.sciencedirect.com/topics/computer-science/profiling-tool
- "black_box" (Rust Docu): https://doc.rust-lang.org/beta/std/hint/fn.black_box.html




