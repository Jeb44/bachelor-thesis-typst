#import "lib/lib.typ": abstract, thu, title-page
#import "lib/bib.typ": load-bib

#include "structure/00_title_page.typ"
#pagebreak()

#include "structure/01_own_work.typ"
#pagebreak()

#include "structure/02_abstract.typ"
#pagebreak()

#include "structure/03_acknowledgements.typ"
#pagebreak()

#include "structure/04_toc.typ"
#pagebreak()

#include "structure/05_introduction.typ"
#pagebreak()

#include "structure/06_related_work.typ"
#pagebreak()

#include "structure/07_method.typ"
#pagebreak()

#include "structure/08_conclusion_future.typ"
#pagebreak()

#include "structure/09_references.typ"
#pagebreak()

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

= Code Snippet 

#set align(left)
#figure(
  align(left, ```rust
  fn main() {
  prinln!("Hello world!")
  }
  ```),
  caption: [Rust Code],
)

#include "files/00_introduction.typ"
#include "files/01_overview.typ"
#include "files/02_methods.typ"

#include "files/03_notes_dynamic.typ"

#pagebreak()

#include "files/0y_safety.typ"

#include "files/0y_performance.typ"

