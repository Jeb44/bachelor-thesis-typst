# Sources

The following section shows some articles and scientific sources with some meta data for my work.

## Serach here:

- [THU](https://www.thu.de/de/org/IMZ/Seiten/Bibliothek.aspx)
    - [Bibliothekskatalog](https://bsz.ibs-bw.de/aDISWeb/app?service=direct/0/Home/$DirectLink&sp=SOPAC32)
    - [DIBS](https://dbis.ur.de/)
- []


## Systematic literature reserach

1) Define search terms

plugin system
rust
evaluation
measurements
safety
complexity
performance
limitations
interoperability
static
dynamic

2) Conduct literature serach


3) Skim search results (abstracts)

check:
- Abstract
- Gliederung
- Einleitung
- Fazit

4) Select relevant literature
5) Prepare documentation

## Temperate Measurement


### Practical Temperate Measurement
First Accessed: 2026.02.04
[Link](https://books.google.de/books?id=73Km1TpL2mkC&lpg=PP1&ots=FKUr-NJVYS&dq=temperature%20measurement&lr&pg=PA12#v=onepage&q&f=false)

Abstract: Rust has risen in prominence as a systems programming language
in large part due to its focus on reliability. The language’s advanced
type system and borrow checker eliminate certain classes of mem-
ory safety violations. But for critical pieces of code, teams need
assurance beyond what the type checker alone can provide. Verifica-
tion tools for Rust can check other properties, from memory faults
in unsafe Rust code to user-defined correctness assertions. This pa-
per particularly focuses on the challenges in reasoning about Rust’s
dynamic trait objects, a feature that provides dynamic dispatch for
function abstractions. While the explicit dyn keyword that denotes
dynamic dispatch is used in 37% of the 500 most-downloaded Rust
libraries (crates), dynamic dispatch is implicitly linked into 70%. To
our knowledge, our open-source Kani Rust Verifier is the first sym-
bolic modeling checking tool for Rust that can verify correctness
while supporting the breadth of dynamic trait objects, including
dynamically dispatched closures. We show how our system uses
semantic trait information from Rust’s Mid-level Intermediate Rep-
resentation (an advantage over targeting a language-agnostic level
such as LLVM) to improve verification performance by 5%–15×
for examples from open-source virtualization software. Finally, we
share an open-source suite of verification test cases for dynamic
trait objects.

## Complexity...

### Evaluation of Rust code verbosity, understandability and complexity
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://pdfs.semanticscholar.org/68d7/d5567d68446955f1b46afe1cdea775855053.pdf)

Abstract: 
Rust is an innovative programming language initially implemented by Mozilla, developed to ensure high
performance, reliability, and productivity.
The final purpose of this study consists of applying a set of common static software metrics to pro-
grams written in Rust to assess the verbosity, understandability, organization, complexity, and maintain-
ability of the language.
To that extent, nine different implementations of algorithms available in different languages were se-
lected. We computed a set of metrics for Rust, comparing them with the ones obtained from C and a
set of object-oriented languages: C++, Python, JavaScript, TypeScript. To parse the software artifacts
and compute the metrics, it was leveraged a tool called rust-code-analysis that was extended with a
software module, written in Python, with the aim of uniforming and comparing the results.
The Rust code had an average verbosity in terms of the raw size of the code. It exposed the most
structured source organization in terms of the number of methods. Rust code had a better Cyclomatic
Complexity, Halstead Metrics, and Maintainability Indexes than C and C++ but performed worse than
the other considered object-oriented languages. Lastly, the Rust code exhibited the lowest COGNI-
TIVE complexity of all languages.
The collected measures prove that the Rust language has average complexity and maintainability com-
pared to a set of popular languages. It is more easily maintainable and less complex than the C and
C++ languages, which can be considered syntactically similar. These results, paired with the memory
safety and safe concurrency characteristics of the language, can encourage wider adoption of the lan-
guage of Rust in substitution of the C language in both the open-source and industrial environments.

Compares rust to other languages on "how compact/readable" the code is, but also how good the result it...

## Rust Sources

### Verifying Dynamic Trait Objects in Rust
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://dl.acm.org/doi/epdf/10.1145/3510457.3513031)

Abstract: 

Some description...

What chapters/pages are of interest...



## Performance/Time Measurement

### Template qwq
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://www.google.com/)

Abstract: Some description...


What chapters/pages are of interest...



## Plugin System

### Predictable Dynamic Plugin Systems
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://link.springer.com/chapter/10.1007/978-3-540-24721-0_9https://www.google.com/)

Abstract: 

Sample Java Code

What chaperts/pages are of interest


### Painless Plugins
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://www.doc.ic.ac.uk/~rbc/papers/pp.pdf)

Abstract: Using plugins as a mechanism for evolving applications
is appealing, but current implementations are limited in
scope. Plugins are optional components which can be used
to enable the dynamic construction of flexible and complex
systems, passing as much of the configuration management
effort as possible to the system rather than the user, allow-
ing graceful upgrading of systems over time without stop-
ping and restarting. In this paper we explore the design
space of plugin architectures, present a framework that ad-
dresses the aforementioned issues, and demonstrate some
examples of applications implemented using our plugin ar-
chitecture.

Good introduction with interesting analogies into plugin development.
Haven't found anything of interest for evaluation (like performance and so on...)

### Modeling a Framework for Plugins
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://www.cs.ucf.edu/~leavens/tech-reports/ISU/TR03-11/SAVCBS03.pdf#page=59)

Abstract: Using plugins as a mechanism for extending applications to pro-
vide extra functionality is appealing, but current implementations
are limited in scope. We have designed a framework to allow the
construction of flexible and complex systems from plugin compo-
nents. In this paper we describe how the use of modelling tech-
niques helped in the exploration of design issues and refine our
ideas before implementing them. We present both an informal
model and a formal specification produced using Alloy. Alloy’s as-
sociated tools allowed us to analyse the plugin system’s behaviour
statically.

Almost the same as the paper above?? But has some more mathematical defitions for that...

### Benefits of Plugin-Based Heuristic Optimization Software Systems
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://link.springer.com/chapter/10.1007/978-3-540-75867-9_94)
Downloadeded filename: "978-3-540-75867-9.pdf"

Abstract: Plugin-based software systems are the next step of evolution in application development. 
By supporting fine grained modularity not only on the source code but also on the post-compilation level, 
plugin frameworks help to handle complexity, simplify application configuration and deployment, and 
enable users or third parties to easily enhance existing applications with self-developed modules without 
having access to the whole source code.
In spite of these benefits, plugin-based software systems are seldom found in the area of heuristic 
optimization. Some reasons for this drawback are discussed, several benefits of a plugin-based heuristic
optimization software system are highlighted and some ideas are shown, how a heuristic optimization meta-model 
as the basis of a thorough plugin infrastructure for heuristic optimization could be defined

Some hints about complexity? Not sure how useful this will be..

### Predictable Dynamic Plugin Systems
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://link.springer.com/chapter/10.1007/978-3-540-24721-0_9)
[Link](https://link.springer.com/content/pdf/10.1007/978-3-540-24721-0_9.pdf)

To be able to build systems by composing a variety of com-
ponents dynamically, adding and removing as required, is desirable. Un-
fortunately systems with evolving architectures are prone to behaving in
a surprising manner. In this paper we show how it is possible to generate
a snapshot of the structure of a running application, and how this can be
combined with behavioural specifications for components to check com-
patability and adherence to system properties. By modelling both the
structure and the behaviour, before altering an existing system, we show
how dynamic compositional systems may be put together in a predictable
manner.

Java Example


### Introduction of a Plugin System for ReSet
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://eprints.ost.ch/id/eprint/1209/1/FS%202024-BA-EP-Lenherr-Tran-Settingsapplikation%20mit%20integriertem%20Plugin%20System.pdf)

Abstract: In this thesis, a plugin system for the existing ReSet application is developed. ReSet is a settings ap-
plication for Linux that aims to provide support for multiple desktop environments and window man-
agers/compositors. Therefore, ReSet offers only a small set of core features due to its focus on universal
environment support. As such a plugin system is needed in order to offer additional functionality.
The architecture of the plugin system was developed by analyzing existing solutions for other software
and by creating various prototypes to prove the viability of each system on ReSet and its potential
plugins.
The plugin system was ultimately developed with shared libraries which allows for resource sharing
in both the daemon and the user interface of ReSet without the additional overhead of an interpreter.
To prove the plugin system, two exemplary plugins were developed in this thesis. The first is a moni-
tor plugin, which allows users to change the individual settings of each monitor and rearrange their
monitors. The second is a keyboard plugin that allows users to add, remove and rearrange keyboard
layouts. Combined with the plugin system is a testing framework that also allows plugin developers
to include their tests within ReSet in order to allow integration tests.
In summary, the plugin system was successfully implemented, with both plugins expanding the func-
tionality as expected. Additionally, the plugin system offers ReSet the opportunity to offer limitless
potential in both environment and hardware support, while also giving users the option to choose
their options within ReSet.

Shows an example of how to set up a Plugin System in Rust.

Has some references to C-ABI (pg. 7-8)


---

### Template qwq
First Accessed: 2026.02.04
Last Accessed: -
[Link](https://www.google.com/)

Abstract:

Some description...

What chapters/pages are of interest...





