#import "lib/lib.typ": thu, abstract, title-page
#import "lib/bib.typ": load-bib

#include "files/00_titlepage.typ"

#show: thu.with(
  title: [Plugin System's in Rust],
  authors: (
    (
      name: "Gabriel Zimmermann",
      // department: [Co-Founder],
      // organization: [Typst GmbH],
      // location: [Berlin, Germany],
      // email: "haug@typst.app"
    ),
  ),
  figure-supplement: [Fig.],
)

#abstract([
  Somethign something what approaches are there to setup plugin systems in Rust. What are the pros and cons...
])

#let details = toml("./metadata.toml")

= Metadata University...

#details.degree_program

#title-page(is-english: true)

#include "files/00_introduction.typ"
#include "files/01_overview.typ"
#include "files/02_methods.typ"


