#import "../lib/lib.typ": title-page, signature-line

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


#signature-line(width: 30em)


