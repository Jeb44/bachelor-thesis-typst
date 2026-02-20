
#let bib-path = "/refs.bib"

// bib.typ
#let load-bib(main: false) = {
  counter("bibs").step()

  context if main {
    [#bibliography(bib-path) <main-bib>]
  } else if query(<main-bib>) == () and counter("bibs").get().first() == 1 {
    // This is the first bibliography, and there is no main bibliography
    bibliography(bib-path)
  }
}
