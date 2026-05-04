#import "bib.typ": load-bib

#let signature-line(width: 10em, under_line: "Place, Date, Signature") = {
  set align(right)
  set align(bottom)
  box(
    height: 1.2em,
    width: width,
    fill: white,
    stroke: (bottom: 1pt + black),
    [ ],
  )
  linebreak()
  h(12%)
  text(style: "italic")[#under_line]
}

#let abstract(h: "Abstract", body) = {
  [#heading(outlined: false, numbering: none)[#h]]
  [#body]
}

#let title-page(is-english: false) = {
  set align(center)
  let details = toml("../metadata.toml")  

  if is-english {
    [ Bachelor thesis at Ulm University of Applied Sciences \ ]
    [ Department of Computer Science \ ]
    [ #linebreak()]
    [ Degree Program *#details.degree_program* \ ]
    [ #linebreak()]
    [ Presented by \ ]
    [ *#details.student_name* \ ]
    [ #details.submission_month #details.submission_year \ ]
    [ #linebreak()]
    [ 1. Reviewer: *#details.first_reviewer* \ ]
    [ 2. Reviewer: *#details.second_reviewer* \ ]
  } else {
    [ Bachelorarbeit an der Technischen Hochschule Ulm \ ]
    [ Fakultät Informatik \ ]
    [ Studiengang *#details.degree_program* \ ]
    [ vorgelegt von *#details.student_name* \ ]
    [ #details.submission_month #details.submission_year \ ]
    [ 1. Gutachter: *#details.first_reviewer* \ ]
    [ 2. Gutachter: *#details.second_reviewer* \ ]
  }
}

// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let thu(
  // The paper's title.
  title: [Paper Title],
  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),
  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,
  // How figures are referred to from within the text.
  // Use "Figure" instead of "Fig." for computer-related publications.
  figure-supplement: [Fig.],
  // The paper's content.
  body,
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  set text(font: "Liberation Sans", size: 11pt, spacing: .35em)

  // Enums numbering
  set enum(numbering: "1)a)i)")

  // Tables & figures
  show figure: set block(spacing: 15.5pt)
  show figure: set place(clearance: 15.5pt)
  show figure.where(kind: table): set figure.caption(position: top, separator: [\ ])
  show figure.where(kind: table): set text(size: 10pt)
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: image): set figure(supplement: figure-supplement, numbering: "1")
  show figure.caption: set text(size: 8pt)
  show figure.caption: set align(start)
  show figure.caption.where(kind: table): set align(center)

  // Adapt supplement in caption independently from supplement used for
  // references.
  set figure.caption(separator: [. ])
  show figure: fig => {
    let prefix = (
      if fig.kind == table [TABLE] else if fig.kind == image [Fig.] else [#fig.supplement]
    )
    let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
    // Wrap figure captions in block to prevent the creation of paragraphs. In
    // particular, this means `par.first-line-indent` does not apply.
    // See https://github.com/typst/templates/pull/73#discussion_r2112947947.
    show figure.caption: it => block[#prefix~#numbers#it.separator#it.body]
    show figure.caption.where(kind: table): smallcaps
    fig
  }

  // Code blocks
  show raw: set text(
    font: "Source Code Pro",
    ligatures: false,
    size: 1em / 0.8,
    spacing: 100%,
    weight: "regular",
  )

  show raw.where(block: false, /*lang: none*/): it => box(
    fill: color.linear-rgb(84.69%, 87.14%, 89.63%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    text([#it])
  )

  // Configure the page and multi-column properties.
  set columns(gutter: 12pt)
  set page(
    columns: 1,
    paper: "a4",
    margin: (left: 3cm, right: 2.5cm, top: 2.5cm, bottom: 2cm),
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location()),
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.a)")
  show heading: it => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).get()
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(12pt, weight: 400)
    if it.level == 1 {
      // First-level headings are centered smallcaps.
      // We don't want to number the acknowledgment section.
      set align(center)
      set text(12pt)
      show: block.with(above: 15pt, below: 13.75pt, sticky: true)
      show: smallcaps
      if it.numbering != none {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      it.body
    } else if it.level == 2 {
      // Second-level headings are run-ins.
      set text(style: "italic")
      show: block.with(spacing: 10pt, sticky: true)
      if it.numbering != none {
        numbering("A.", deepest)
        h(7pt, weak: true)
      }
      it.body
    } else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("a)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  }

  // Style bibliography.
  show std.bibliography: set text(8pt)
  show std.bibliography: set block(spacing: 0.5em)
  set std.bibliography(title: text(10pt)[References], style: "ieee")

  // Display the paper's title and authors at the top of the page,
  // spanning all columns (hence floating at the scope of the
  // columns' parent, which is the page).
  place(
    top,
    float: true,
    scope: "parent",
    clearance: 30pt,
    {
      {
        set align(center)
        set par(leading: 0.5em)
        set text(size: 24pt)
        block(below: 8.35mm, title)
      }

      // Display the authors list.
      set par(leading: 0.6em)
      for i in range(calc.ceil(authors.len() / 3)) {
        let end = calc.min((i + 1) * 3, authors.len())
        let is-last = authors.len() == end
        let slice = authors.slice(i * 3, end)
        grid(
          columns: slice.len() * (1fr,),
          gutter: 12pt,
          ..slice.map(author => align(center, {
            text(size: 11pt, author.name)
            if "department" in author [
              \ #emph(author.department)
            ]
            if "organization" in author [
              \ #emph(author.organization)
            ]
            if "location" in author [
              \ #author.location
            ]
            if "email" in author {
              if type(author.email) == str [
                \ #link("mailto:" + author.email)
              ] else [
                \ #author.email
              ]
            }
          }))
        )

        if not is-last {
          v(16pt, weak: true)
        }
      }
    },
  )

  set par(justify: true, first-line-indent: (amount: 1em, all: true), spacing: 0.5em, leading: 0.5em)


  // Display the paper's contents.
  body

  // Display bibliography.
  load-bib(main: true)
  //bibliography
}
