#import "lib/lib.typ": abstract, thu, title-page
#import "lib/bib.typ": load-bib

#include "structure/00_title_page.typ"
#pagebreak()

#include "structure/01_own_work.typ"
#pagebreak()

#show: thu.with(
  title: [Plugin Architectures with Rust - an Analysis of Obstacles and Prospects],
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

#include "structure/08_results.typ"
#pagebreak()

#include "structure/09_conclusion_future.typ"
#pagebreak()
