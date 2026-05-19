#import "@preview/diatypst:0.9.1": *

// Universe: https://typst.app/universe/package/diatypst
// Documentation: https://mdwm.org/diatypst/index.html

#let color_thu = color.rgb("#0054a3")
#let color_white = white

#set page(
  footer: none,
  header: none,
  margin: 0cm,
  height: 10.5cm, // height is either 9cm, 10.5cm or 12cm
  width: 16 / 9 * 10.5cm, // width is your height * your ratio
)

// Custom First Slide:
#block(
  inset: 0.8cm,
  fill: color_thu,
  width: 100%,
  height: 60%,
  align(bottom)[
    #text(2.0em, weight: "bold", fill: color_white)[Plugin Architectures with Rust]
  ],
)
#block(
  height: 35%,
  width: 100%,
  inset: (top: 0cm, bottom: 0.8cm, x: 0.8cm),
  grid(
    columns: (1fr, auto, auto),
    gutter: 3pt,
    rows: 1fr,
    //fill: blue.darken(50%),

    [
      #text(1.4em, fill: color_thu, weight: "bold", "an Analysis of Obstacles and Prospects")
      #linebreak()
      #text(1.1em, "20.05.2026")
    ],
    [#align(center + horizon)[#image("res/Hensoldt_Logo_2020.svg", height: 50%)]],
    [#align(center + horizon)[#image("res/thu-logo.png", height: 100%)]],
  ),
)


#show: slides.with(
  title: "Plugin System in Rust", // Required
  subtitle: "an Analysis of Obstacles and Prospects",
  date: "20.05.2026",
  authors: "Gabriel Zimmermann",

  // Optional (for more see docs at https://mdwm.org/diatypst/)
  ratio: 16 / 9,
  layout: "medium",
  title-color: color_thu,
  toc: true,
  first-slide: false, // first-slide disabled so we can use our custom first slide with logos
  theme: "full",
)

= Introduction

== Plugin Systems

#grid(
  columns: (1fr, auto),
  [
    - *Extensibility*: The ability to add new functionality post-deployment.
    - *Modularity*: Plugins are isolated units that interact with the host through a well-defined interface.
    - *Dynamic Loading*: Plugins are typically loaded at runtime rather than linked statically at compile time.
  ],
  figure[
    #image("res/plugins_figure.svg", width: 75%)
  ],
)

== Criteria

- Performance Overhead
- Development Complexity
- Language Limitations
- Interoperability




= ABI

== Application Binary Interface 

#figure[
  #image("res/abi_figure.svg", width: 100%)
]

== Dynamic linking and loading

=== Process of dynamic linking and loading

#grid(
  columns: (1fr, auto),
  align: horizon,

  enum(numbering: "1)")[Discovery][Loading][Resolution][Execution],
  figure[
    #image("res/dynamic_linking_figure.svg", width: 90%)
  ],
)

=== Example with Rust ABI

// Everything after "let symbol" is just for rust :3
// lib is required to store the functions "lifetime"...

Using the `libloading` crate:

```rust
trait Fuser {
  fn fuse(&self, data: &[SensorData]) -> Result<SensorData, Box<dyn Error>>;
}
struct Plugin<T> where T: Fn() -> Box<dyn Fuser> + Copy{
  lib: Library,
  func: T,
}
fn new(path: &PathBuf, symbol_name: &[u8]) -> Result<Self, libloading::Error> {
  let lib = unsafe { Library::new(path) }?; // 1+2) Discovery and Loading
  let symbol: Symbol<T> = unsafe { lib.get(symbol_name) }?; // 3) Resolution
  let func: T = *symbol; // fn deref(&self) -> &T
  Ok(Plugin { lib, func })
}
```

#pagebreak()

// extern "Rust" -> use Rust ABI

```rust
type FuseFunc = extern "Rust" fn() -> Box<dyn Fuser>;
let p: Plugin<FuseFunc> = Plugin::new(&plugin_path.into(), "average_plugin".as_bytes()).unwrap();
a(&p);

fn a(plugin: &Plugin<FuseFunc>) {
  let fuser: Box<dyn Fuser> = plugin.get();
  let sd = [ SensorData::new(42.0, 0.01), ... ];
  let res = fuser.fuse(&sd); // 4) Execution
  println!("a) {:?}", res);
}
```

// Reminder that libloading crate resolves the whole OS-specific dynamic linking and loading logic for us
// All other crates that are shown today use libloading internally

== IPC

#figure[
  #image("res/ipc_figure.svg", width: 100%)
]

#lorem(20)

/ *Term*: Definition



= Conclusion

== Performance

#figure(
  table(
    columns: 5,
    table.header[*Crate*][*Perf. Diff*][*Development Complexity*][*Limitation*][*Interoperability*],
    [*native*], [], [++], [0], [0],
    [*unstable_abi*], [16%], [\-\-], [\-\-], [0],
    [*abi_stable*], [25%], [0], [0], [+],
    [*stabby*], [9%], [0], [0], [+],
    [*rust_bridge (JSON)*], [537%], [+], [0], [++],
    [*rust_bridge (Binary)*], [25%], [-], [0], [++],
  ),
  caption: [Summary of results.],
) <summary-table>



