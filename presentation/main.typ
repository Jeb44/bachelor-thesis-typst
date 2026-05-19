#import "@preview/diatypst:0.9.1": *

// Universe: https://typst.app/universe/package/diatypst
// Documentation: https://mdwm.org/diatypst/index.html

// Maybe change to Hensoldt colors?
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

== Basics

=== Application Binary Interface

#figure[
  #image("res/abi_figure.svg", width: 100%)
]

=== Dynamic Linking/Loading

#grid(
  columns: (1fr, auto),
  align: horizon,

  enum(numbering: "1)")[Discovery][Loading][Resolution][Execution],
  figure[
    #image("res/dynamic_linking_figure.svg", width: 90%)
  ],
)

== (Unstable) Rust ABI

=== Demonstration of dynamic linking and loading

// Everything after "let symbol" is just for rust :3
// lib is required to store the functions "lifetime"...

```rust
// In base library (used by application and plugin):
trait Fuser {
  fn fuse(&self, data: &[SensorData]) -> Result<SensorData, Box<dyn Error>>;
}
```

```rust
// In plugin (library):
struct AveragePlugin;
impl Fuser for AveragePlugin { ... }

#[unsafe(no_mangle)] // ensure name can be found in binary
pub fn average_plugin() -> Box<dyn Fuser> {
    Box::new(AveragePlugin::new())
}
```

#pagebreak()

// extern "Rust" -> use Rust ABI

```rust
// In application:
type FuseFunc = extern "Rust" fn() -> Box<dyn Fuser>; // use Rust ABI
let plugin: Plugin<FuseFunc> = Plugin::new(
  &plugin_path.into(),
  "average_plugin".as_bytes()
).unwrap(); // 1), 2) and 3)

let fuser: Box<dyn Fuser> = plugin.get();
let sd = [ SensorData::new(24.0, 0.01), ... ];
let res = fuser.fuse(&sd); // 4) Execution
println!("{:?}", res);
```

#pagebreak()

```rust
// In application:
struct Plugin<T> where T: Fn() -> Box<dyn Fuser> + Copy{
  lib: Library,
  func: T, // or Vec<T> or HashMap<String, T>
}
```

#grid(
  columns: (1.5fr, 7fr),
  align: horizon,

  enum(numbering: "1)")[Discovery][Loading][Resolution][Execution],
  {
    "Using the \"libloading\" crate:"
    ```rust
    fn new(path: &PathBuf, s: &[u8]) -> Result<Self, libloading::Error> {
      let lib = unsafe { Library::new(path) }?; // 1+2)
      let symbol: Symbol<T> = unsafe { lib.get(s) }?; // 3)
      let func: T = *symbol; // fn deref(&self) -> &T
      Ok(Plugin { lib, func })
    }
    fn get(&self) -> Box<dyn Fuser> { (self.func)() }
    ```
  },
)


// Reminder that libloading crate resolves the whole OS-specific dynamic linking and loading logic for us
// All other crates that are shown today use libloading internally

#pagebreak()

=== .... but it's Unstable

- Compiler version changes *may* impact the generated binary
- Base library, application and plugin need to run on the *same compiler version*


== abi_stable crate

- Widely used crate with a lot of community support 
- 

*but*:

- Many hidden structs and types are generated, and therefore overwhelming at first


== `stabby` crate

- A lot simpler to get started 
- Good explanation of the concepts behind ABI developement (and why Rust doesn't like the C ABI)

*but*:

- relatively new and therefore not a lot of community engagement (yet)
- had some breaking changes due to a rust compiler update

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


= Appendix

== abi_stable implementation


=== Base Library
```rust
#[sabi_trait] // converts this to: Fuser_T0<'lt, Pointer<()>> (and more...)
pub trait Fuser {
  #[sabi(last_prefix_field)]
  fn fuse<'a>(&self, data: RSlice<'a, SensorData>) -> RResult<SensorData, RBoxError>;
}
pub type FuserBox = Fuser_TO<'static, RBox<()>>;
```

```rust
#[repr(C)]
#[derive(StableAbi)]
#[sabi(kind(Prefix(prefix_ref = FuserLibRef)))]
#[sabi(missing_field(panic))]
pub struct FuserLib{
    pub new_fuser: extern "C" fn() -> FuserBox,
}

impl RootModule for FuserLibRef {
    abi_stable::declare_root_module_statics! {FuserLibRef}
    const BASE_NAME: &'static str = "fuser_lib";
    const NAME: &'static str = "fuser_lib";
    const VERSION_STRINGS: VersionStrings = package_version_strings!();
}
```

```rust
pub fn load_root_module_in_directory(directory: &Path) -> Result<FuserLibRef, LibraryError> {
    FuserLibRef::load_from_directory(directory)
}
```

#pagebreak()
=== Plugin
```rust
// in plugin:
#[export_root_module]
fn average_plugin() -> FuserLibRef {
  FuserLib {new_fuser: average_plugin_impl}.leak_into_prefix()
}
#[sabi_extern_fn]
fn average_plugin_impl() -> FuserBox {
  Fuser_TO::from_value(AveragePlugin::new(),
                       TD_Opaque, // disallow DOWNCASTING of trait objects
  )
}
```

#pagebreak()
=== Application
```rust
let path : PathBuf = plugin_path.into();
let data = [ SensorData::new(24.0, 0.01), ... ];
let data = RSlice::from_slice(&data);

let plugin: FuserLibRef = load_root_module_in_directory(&path)?;
let fuser: Fuser_TO<'_, RBox<()>> = plugin.new_fuser()();
let res= plugin.fuse(data);
println!("a) {:?}", res);
```

== stabby implementation

=== Base Library
```rust
#[stabby::stabby(checked)] // neccessary for stabby!
pub trait Fuser {
    extern "C" fn fuse(
        &self,
        data: stabby::slice::Slice<'_, SensorData>,
    ) -> stabby::result::Result<SensorData, error::Error>;
    extern "C" fn print(&self);
}
```
#pagebreak()
=== Plugin
```rust
#[stabby::stabby]
pub struct AveragePlugin { }
impl Fuser for AveragePlugin { ... }

#[stabby::export]
pub extern "C" fn average_plugin()
  -> stabby::dynptr!(Box<dyn Fuser>) {
  Box::new(AveragePlugin::new()).into()
}
```

#pagebreak()
=== Application
```rust
pub type FuseFunc = extern "C" fn() -> FuserPluginDyn;
pub type FuserPluginDyn = stabby::dynptr!(stabby::boxed::Box<dyn app_core::fuse::Fuser>);

pub struct Plugin<TDyn> {
  // Keep the plugin value before the library handle so it is dropped first.
  func: TDyn,
  _lib: Library,
}

impl<TDyn> Plugin<TDyn> {
    pub fn new<TFunc>(
        plugin_name: &PathBuf,
        symbol: &[u8],
    ) -> Result<Self, Box<dyn Error + Send + Sync>>
    where
        TFunc: PluginFactory<Dyn = TDyn>, // allows to use of  "get(&self)"
    {
        let lib = unsafe { libloading::Library::new(plugin_name)? };
        let my_imported_function = unsafe { lib.get_stabbied::<TFunc>(symbol)? };
        let fund = *my_imported_function;
        let tdyn = fund.get();

        Ok(Self {
            func: tdyn,
            _lib: lib,
        })
    }

    pub fn get(&self) -> &TDyn {
        &self.func
    }

    pub fn get_mut(&mut self) -> &mut TDyn {
        &mut self.func
    }
}

pub fn get_plugin<TFunc>(
    plugin_name: PathBuf,
    symbol: &[u8],
) -> Result<Plugin<TFunc::Dyn>, Box<dyn Error + Send + Sync>>
where
    TFunc: PluginFactory,
{
    Plugin::<TFunc::Dyn>::new::<TFunc>(&plugin_name, symbol)
}

let mut plugin: Plugin<FuserPluginDyn> = get_plugin::<FuseFunc>(plugin_path.into(), "average_plugin".as_bytes()).unwrap();
let data = [ SensorData::new(24.0, 0.01), ... ];
let data: Slice<'_, SensorData> = Slice::new(&data);
let fuser = plugin.get();
let res = fuser.fuse(data);
println!("a) {:?}", res);
```
#pagebreak()