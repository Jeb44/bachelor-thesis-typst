#import "../lib/bib.typ": load-bib

//#load-bib()

/*
= Methods <sec:methods>
#lorem(45)

$ a + b = gamma $ <eq:gamma>

#lorem(80)

#figure(
  placement: none,
  circle(radius: 15pt),
  caption: [A circle representing the Sun.]
) <fig:sun>

In @fig:sun you can see a common representation of the Sun, which is a star that is located at the center of the solar system.

#lorem(120)

#figure(
  caption: [The Planets of the Solar System and Their Average Distance from the Sun],
  placement: top,
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (6em, auto),
    align: (left, right),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Planet][Distance (million km)],
    [Mercury], [57.9],
    [Venus], [108.2],
    [Earth], [149.6],
    [Mars], [227.9],
    [Jupiter], [778.6],
    [Saturn], [1,433.5],
    [Uranus], [2,872.5],
    [Neptune], [4,495.1],
  )
) <tab:planets>

In @tab:planets, you see the planets of the solar system and their average distance from the Sun.
The distances were calculated with @eq:gamma that we presented in @sec:methods.

#lorem(240)

#lorem(240)
*/

= Methods

Goal of the research was to analyse the following points:
- performance
- development complexities
- dependencies
- safety
- interoperability


== Performance

Only "pure" quantitative measurement will be the performance and maybe safety (using safety levels).

=== Tools

Using criterion and gungraun benchmarks. Not a perfect measurement, but it should give us enough hints about what happens behind the scenes.

Using black_box, we can ensure that the iternal code isn't hyper-optimized by the compiler, which can lead to more accurate benchmarks.

=== Benchmarks

To test all of this, we use a simple temperature simulation, where an random amount of sensors will pick up the data. 

Benches are run with the follolwing set of configurations:

- run app "regarulary" with black_box // probably not interesting for the result itself
- run average temperature fusion code with black_box once (sensors: 1 vs. 1000000)
- run average temperature fusion code without black_box (sensors: 1 vs. 1000000)

=== Evaluation

Gunguan helps us see the internal required instructions on "my" CPU. This result should correlate with the actual run time using criterion. We can then reason about the expected overhead of a choosen approad.

== Development complexities

Schulnote

Qualitative Meaurement

== Limitations

Might be part of "complexities"??

Qualitative Meaurement

== 
