#set page(
  paper: "a4",
  margin: (x: 3cm, y: 1.5cm),
)
#set text(
  font: "Noto Sans Math",
  size: 10pt,
)
#set par(
  justify: true,
  leading: 0.52em,
)

#grid(
  columns: (auto, auto),
  rows: auto,
  gutter: 3pt,

  figure(
    image("res/Hensoldt_Logo_2020.png"),
  ),

  figure(
    image("res/Logo_Technische_Hochschule_Ulm.png", width: 50%),
  ),
)


= Bachelor Thesis Proposal --- Gabriel Zimmermann

#set heading(numbering: (..nums) => {
 set text(fill: white)
 numbering("1.", ..nums)
})

#linebreak()

#let header(content) = block(
  fill: rgb(117, 115, 115),
  width: 100%,
  radius: 10%, 
  height: auto,
  outset: 0.5em, 
  heading(text(content, fill: white), level: 1) 
)

#header("Title")

Plugin Architectures with Rust - an Analysis of Obstacles and Prospects

#linebreak()

#header("Problem")

//- Was ist die Ausgangssituation und welches Problem besteht?
The Rust programming language is increasingly being selected for new projects where performance, reliability, and memory safety are critical. For many of these projects, such as data processing pipelines, application cores, or development tools, a plugin system is a fundamental requirement to ensure long-term extensibility. Rust's explicit lack of a stable Application Binary Interface (ABI) renders the conventional approach of dynamically linking libraries (\*.so / \*.dll), common in C/C++, unreliable and unsafe.

//- Worin besteht die Relevanz des Problems?
// For "Hensoldt - Secure and Protect" these features are critical for their radar systems.
// This upcoming bachelor thesis is about the analysis of implementing a flexible plugin systems in Rust and understanding the various advantages and disadvantages.

#linebreak()

#header("Research objective and questions")

Goal of the paper is to analyze different approaches for developing a plugin system. The following points will be addressed:

- Illustrate the differences between compile time and dynamic time plugins with their respective advantages and disadvantages.
- How do the proposed options impact development time and complexity?
- Evaluate suitable tools and their inherent limitations, using specific examples such as WebAssembly (via interpreters), non-ABI-stable Rust formats, and others.


/*
- When interfacing with other programming languages, what considerations have to be made? (FFI with C, non-ABI-stable rust formats, WebAssembly)
*/


//- Analysis of performance impacts
//While not the primary focus, the thesis will also briefly address the performance implications of the discussed approaches.

#linebreak()

#header("Expected results and contributions")
//- Wo stehen wir voraussichtlich nach Abschluss Ihrer Bachelorarbeit?

Upon completion of this bachelor thesis, the goal is to provide a clear and structured analysis of the current landscape for building plugin architectures in Rust. It will not present a single "best" solution, but rather a comprehensive comparison of available approaches. The thesis will serve as a guide for developers, enabling them to make an informed decision based on their specific requirements regarding safety, complexity, performance, and interoperability. The final document will delineate the obstacles posed by Rust's design and the prospects offered by modern solutions.


//Using the result of the research, a small protoype for data fusion track algorithmns will be provided.
The work makes results tangible through prototypical implementations, ensuring practival relevance and real-world applicability.



//- Durch welchen Ansatz wollen Sie die derzeit vorhandene Lücke voraussichtlich schließen?
//- Gibt es schon vergleichbare Lösungsansätze und wo sind diese dokumentiert?


