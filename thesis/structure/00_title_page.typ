#import "../lib/lib.typ": title-page

#let signature-line(width: 10em) = {
  box(
    height: 1.2em,
    width: width,
    fill: white,
    stroke: (bottom: 1pt + black),
    [ ],
  )
}

#set rect(stroke: none)

#grid(
  rows: (auto, auto),
  gutter: 10em,
  grid(
    columns: (auto, auto),
    gutter: 3pt,
    rect[#image("../res/thu-logo.png")], rect[#image("../res/Hensoldt_Logo_2020.svg")],
  ),

  title-page(is-english: true),
)


#set align(right)
#set align(bottom)
#signature-line(width: 30em)

#h(12%)
#text(style: "italic")[Place, Date, Signature]

