#import "lib/lib.typ": thu, abstract, title-page
#import "lib/bib.typ": load-bib

#include "files/00_titlepage.typ"

#show: thu.with(
  title: [A Typesetting System to Untangle the Scientific Writing Process],
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
    The process of scientific writing is often tangled up with the intricacies of typesetting, leading to frustration and wasted time for researchers. In this paper, we introduce Typst, a new typesetting system designed specifically for scientific writing. Typst untangles the typesetting process, allowing researchers to compose papers faster. In a series of experiments we demonstrate that Typst offers several advantages, including faster document creation, simplified syntax, and increased ease-of-use.
])


#let details = toml("./metadata.toml")

= wawa

#details.degree_program

#title-page(is-english: true)



#include "files/00_introduction.typ"
#include "files/01_overview.typ"
#include "files/02_methods.typ"
//

