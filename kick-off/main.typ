#set page(
  paper: "a4",
  margin: (x: 3cm, y: 1.5cm),
)
#set text(
  font: "Caladea",
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

= Bachelor Thesis Kick-Off

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

#header("Agenda")

- Introduction
- Research objective/questions
- Expected results and contributions
- Tools
- Timeline and Milestones

/* NOTES:
-> English für die BA, Deutscher für Kommunikation
Präsi darf English oder Deutsch sein
Vortrag mit WebCam üben

pro Woche eine Mail mit Stichpunkte

*/

#header("Introduction")

Definieren von Zielen bzw. Meilensteine mit Kategorierierung von:
- mindestens notwendig
- sollte erreicht werden
- optional zu erreichen

*Frage*: BA in Englisch formulieren? Meetings auf Deutsch?

*Context for Hensoldt*: For Rust there is currently on-going development of tools and solutions. Ideally, we'd like to use some form of plug-in to allow special rules in the real-time data fusion.

*TLDR*: Developing a plugin system in Rust. As of right now, there is no ABI specification for Rust or similar
- Linux Kernelmodule über `insmod <file>`
- Java can load dynamic classes.

/* NOTES:


*/

#header("Research objective and questions")

Goal of the paper is to analyze different approaches for developing a plugin system. The following points will be addressed:

- Illustrate the differences between compile time and dynamic time plugins with their respective advantages and disadvantages.
- How do the proposed options impact development time and complexity?
- Evaluate suitable tools and their inherent limitations, using specific examples such as WebAssembly (via interpreters), non-ABI-stable Rust formats, and others.


/* NOTES:
- Erweiterbar mit dem Coding Standard
*/


#header("Expected results and contributions")

- clear structured analysis of the current landscape for building plugin architectures in Rust
- there is no best solution, creating a "guide" instead for each approach
- provide prototypes


#header("Some examples")

Some things we can take a look at:

1. compile-time (using flags):
  - Cargo features
  - Conditional compilation
  - environment variables, external files, ...
2. runtime:
  - trait objects + boxed dyn types
  - enum + match
  - dynamic loading (`.so`, `.dll`) via `libloading` (C FFI)
  - ABI (non-)stable Rust formats (`rlib`, `abi_stable` crate)
  - embedded interpreters (WebAssembly, Lua)
  - hot-reloading from a config file (just changed parameters)
  - runtime flags by exposing environment variables

For each of these write about *safety*, *complexity*, *performance*, *limitations* and *interoperability*.

/* NOTES:
interoperability? nach fakten analysieren können
skala nicht für alle möglich umusetzen für Evaluation
im nachhinein noch neue kriterien einfügen
ADACORE EVALUATIONSTABELLE -> Übersicht angucken
  -> imitieren: "Im Kontext konfigurierbar"


minimum für jede "familie" (limitierbar)


nächstes meeting ende janar / anfang februar





*/

#header("Tools")

Work computer, virtual machine and work repository provided by the company.

*NOTE*: How can the Professor access the repository? Is a work Microsoft account neccessary?

I'd like to use *TypsT* (instead of LaTeX). What are the formal requirements for the document?

Google Scholar has many papers about Rust as a language.

/* NOTES:
Abgabe: USB-Stick (mit Repo) + Zitierungen (primär Webquellen) -> Quellen Downloaden und auf Medium packen!
DIN 15-irgendwas

*/

#header("Schedule")

*Month 0*: Development of "base library" as a template for each approach. Write test suite for performance and correctness. Christmas/New-year will steal some time...

*Month 1*: Literature research, collection of various plugin architectures #linebreak()
*Month 2*: Analysis of the advantages and disadvantages, evaluation of the necessary libraries and tools and their impact on development time and complexity #linebreak()
*Month 3*: Implementation and evaluation of the architectures #linebreak()
*Month 4*: Interpretation of the results, derivation of recommendations for action, and writing of the bachelor thesis. #linebreak()

/* NOTES:
Guidelines (s. moodle) in TypsT bzw. die Struktur einbauen
Generell gut während der Ausarbeitung die BA zu schreiben

Meilensteine updaten (für mich selber)
Graf schickt Anmeldung


Für sehr gute Note wichtig:
- Einen Schritt zurück gehen und in größeren Kontext setzen
-> Diskussion

Was sind die Ziele?
- Zeugs passiert + logischer Roter Pfaden (mit Argumenten!)
Was habe ich erreicht? Was ist das Ergebnis?

Zeitlich Mitte der Arbeit: Passt Struktur?
Aktueller Stand abgeben und gucken
Präsi in der HS, gerne mit Besuch
Zeit zwischen Abgabe und Präsi: 4 Woche, Terminfindung funni
Ggf. noch ein paar Sachen ausarbeiten für die Präsi



Vor Pfingsferien die Präsi machen
-> 2. Gutachter: Ausarbeiter hat "kein Plan". Er muss verstehen das es Systematisch ist und Methodik angewandt wurde


*/

#header("2. Termin")

Betreuender Professor, Firmenbetreuer und Studierender setzen sich noch einmal zusammen und
prüfen, ob die ersten Festlegungen Sinn machten oder ob wir auf nicht überwindbare
Schwierigkeiten / Probleme nach der ersten Einarbeitung gestoßen sind, welche eine Anpassung
erfordern (unrealistische Annahmen korrigieren, Wünsche des Studierenden bezüglich möglicher
    Vertiefungen aufgreifen, etc.).


Ab nun sollten sich (auch als Sicherheit für den Studierenden und die Kontinuität der Arbeit) keine
großen Änderungen mehr ergeben, insbesondere nicht beliebige Wechsel in der Ausrichtung etc.
Hier wird der rote Faden für den weiteren Ablauf der Arbeit festgezurrt.


Der betreuende Professor übernimmt nun die Verantwortung, dass mit den getroffenen Absprachen
die Bearbeitung möglich ist, die Anforderungen an eine Bachelorarbeit abgedeckt sind und das
Potential für eine hervorragende Arbeit durch die Themenstellung gegeben ist.



- fortschritt ist okay. Krankheit zum Anfang des Monats und Pruefung letzte Woche hat das Tempo zu Beginn direkt gedaempft
- aktuell muss noch meine "simulation" angepasst werden, damit die Anforderungen generell genug implementiert sind zur Wiederverwendung
- benchmarking tools angefangen aufzubauen
- simulationsdaten muessen noch an die hohe abtastrate angepasst werden (anderes diagramm oder mittelwerte?)

- zeitmessung muss noch ueberarbeitet werden fuer akuratere ergebnisse

- bisher kaum Literaturrecherche, aber Ideen welche Inhalte noch einbaut werden sollen:
  - Beschreibung der Messtechnik (Zeit)
  - "Thermometermessung" simulieren (eine Quelle bereits gefunden)
  - 


stand der technik: 

conference papers -> aber eher doku im internet (muss natuerlich nicht an rust spezifisch gebunden sein)

*safety*, *complexity*, *performance*, *limitations* and *interoperability*
-> massstaebe definieren, punkte vergeben (qualitativ, lieber schlicht halten)
safety: Mit Safety-level vergleichen
limitation  & interoperability eher beschreibend

literatur -> quellen werden nicht einfach sein zu finden!!!

10.03. (Dienstag) nachmittags
14 Uhr 
online


