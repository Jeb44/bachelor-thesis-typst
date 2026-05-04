#import "@preview/diatypst:0.9.1": *

// Universe: https://typst.app/universe/package/diatypst
// Documentation: https://mdwm.org/diatypst/index.html

#let color_thu = color.rgb("#0054a3")
#let color_white = white

#set page(
  footer: none,
  header: none,
  margin: 0cm,
  height: 10.5cm, // height is either 9cm, 10.5cm or 12cm
  width: 16 / 9 * 10.5cm, // width is your height * your ratio
)

// Custom First Slide:
#block(
  inset: 0.8cm,
  fill: color_thu,
  width: 100%,
  height: 60%,
  align(bottom)[
    #text(2.0em, weight: "bold", fill: color_white)[Plugin Architectures with Rust]
  ],
)
#block(
  height: 35%,
  width: 100%,
  inset: (top: 0cm, bottom: 0.8cm, x: 0.8cm),
  grid(
    columns: (1fr, auto, auto),
    gutter: 3pt,
    rows: (1fr),
    //fill: blue.darken(50%),
    
    [
    #text(1.4em, fill: color_thu, weight: "bold", "an Analysis of Obstacles and Prospects")
    #linebreak()
    #text(1.1em, "20.05.2026")
    ],
    [#align(center + horizon)[#image("res/Hensoldt_Logo_2020.svg", height: 50%)]],
    [#align(center + horizon)[#image("res/thu-logo.png", height: 100%)]]
  )
)


#show: slides.with(
  title: "Plugin System in Rust", // Required
  subtitle: "Plugin Architectures with Rust - an
Analysis of Obstacles and Prospects",
  date: "20.05.2026",
  authors: "Gabriel Zimmermann",

  // Optional (for more see docs at https://mdwm.org/diatypst/)
  ratio: 16 / 9,
  layout: "medium",
  title-color: color_thu,
  toc: true,
  first-slide: false, // first-slide disabled so we can use our custom first slide with logos
  theme: "full"
)

= First Section

== First Slide

#lorem(20)

/ *Term*: Definition


