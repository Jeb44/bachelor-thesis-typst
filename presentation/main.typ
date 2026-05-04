#import "@preview/diatypst:0.9.1": *

// Universe: https://typst.app/universe/package/diatypst
// Documentation: https://mdwm.org/diatypst/index.html

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
  fill: blue.darken(50%),
  width: 100%,
  height: 60%,
  align(bottom)[
    #text(2.0em, weight: "bold", fill: white)[Plugin System in Rust]
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
    #text(1.4em, fill: blue.darken(50%), weight: "bold", "Your subtitle"),
    #linebreak(),
    #text(1.1em, "a date maybe?"),
    ],
    [#align(center + horizon)[#image("res/Hensoldt_Logo_2020.svg", height: 50%)]],
    [#align(center + horizon)[#image("res/thu-logo.png", height: 100%)]]
  )
)


#show: slides.with(
  title: "Diatypst", // Required
  subtitle: "easy slides in typst",
  date: "01.07.2024",
  authors: "Author Name",

  // Optional (for more see docs at https://mdwm.org/diatypst/)
  ratio: 16 / 9,
  layout: "medium",
  title-color: blue.darken(60%),
  toc: true,
  first-slide: false,
)

= First Section

== First Slide

#lorem(20)

/ *Term*: Definition
