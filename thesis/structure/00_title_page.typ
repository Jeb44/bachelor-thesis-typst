#import "../lib/lib.typ": title-page, signature-line

#set align(center)
#set rect(stroke: none)

#grid(
  rows: (auto),
  gutter: 1em,
  inset: 0.5em,
  title-page(is-english: true),
  text(white)[""],
  text(white)[""],
  rect[#image("../res/thu-logo.png", width: 75%)],
  rect[#image("../res/Hensoldt_Logo_2020.svg", width: 75%)],
)

#signature-line(width: 30em)
