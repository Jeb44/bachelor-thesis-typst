#import "@preview/diatypst:0.9.1": *

// Universe: https://typst.app/universe/package/diatypst
// Documentation: https://mdwm.org/diatypst/index.html

// Maybe change to Hensoldt colors?
#let color_thu = color.rgb("#0054a3")
#let color_hensoldt = color.rgb("#009b49")
#let color_white = white


// Color syntax change
#show raw.where(lang: "lento").or(raw.where(lang: "lt")): set raw(
    syntaxes: "lento.sublime-syntax",
    theme: "lento.tmTheme",
)

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": codly-languages
#show: codly-init
#let languages = (
  (
    (
      lento: (
      name: "Lento",
      color: color_thu,
      icon: {
        box(
            inset: 0pt,
            outset: 0pt,
        )
        h(0.3em)
      },
      ),
    )
  )
  + codly-languages
)
#codly(languages: languages, zebra-fill: color.rgb("#e6eef6"), lang-stroke: none)

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
  toc: false, // outline replaced with only main headers
  first-slide: false, // first-slide disabled so we can use our custom first slide with logos
  theme: "full",
  count: "number"
)

//#outline(target: heading.where(level: 2))
#outline(depth: 2)

= Introduction

== Plugin Systems

// plugins allow to extend or modify an existing application (assuming the app provides the interconnection points)
// Classic plugin: Webbrowser Extension
// jigsaw puzzle! interconnecting pieces have to perfectly fit the gap
// most common approach is the use of language Application binary interfaces, but binary or "textual" formats work here too

  #figure(
    image("res/plugins_figure.svg", width: 50%),
    caption: "Computer Software that adds new functionality to an existing application without altering the host program itself"
  )
== Criteria

/ *Performance Overhead*: Resulting from the required overhead, how slow is the execution of the plugin compared to the rust (static) native solution.
This is measured by using a average data fusion with 1 and with 1.000.000 data points and expressed as *percentages*. Quantified by using the criterion benchmark.

/ *Development Complexity*: #list[
Learning curve of the implementation
][
Quality of the Documentation and examples 
][
Required amount of work and consequences for setup, configurations and integration
]
#pagebreak()
/ *(Language) Limitations*: How much does this approach limit the usage of the rust languages features and ecosystem.
/ *Interoperability*: How well can this approach work with other libraries, tools and especially languages.
/*
== Criteria

/ *Performance Overhead*: Resulting from the required overhead, how slow is the execution of the plugin compared to the rust native solution.
This is measured by using a average data fusion with 1 and with 1.000.000 data points and expressed as *percentages*. Quantified by using the criterion benchmark.

// quantified by using benchmarks (criterion benchmark)


/ *Development Complexity*: #list[
Learning curve of the implementation
][
Quality of the Documentation and examples 
][
Required amount of work and consequences for setup, configurations and integration
]

This is expressed from *\-\- to ++*. // ++ represent default rust, as you can use everything

#pagebreak()

/ *(Language) Limitations*: How much does this approach limit the usage of the rust languages features and ecosystem.

This is expressed from *\-\- to 0*.
// 0 represents rust (almost) full language features
// in hindsight, i should have been a bit more critical here

/ *Interoperability*: How well can this approach work with other libraries, tools and especially languages.
This is expressed from *0 to ++*. // 0 represents rust default scope

// Problem: Outside of Performance Overhead, these criteria's are difficult to "simply" quantify and are therefore more of a loose personal judgement.

// Example: Simple Temperature Fusion, where the fusion code itself is the plugin
// focus on rust to rust communication for my test cases
*/

= Application Binary Interface (ABI)

#heading(level: 2, outlined: false)[Application Binary Interface]


#figure(
  image("res/abi_figure_top.svg", width: 100%)
)

*Contract specification*: Calling conventions, Data Layout, Name Mangling, Exception Handling, etc.

Dynamically loading plugin into memory follows: #list[
  *Discovery*: host locates plugin binary file][
  *Loading*: host loads plugin into memory][
  *Resolution*: host resolves symbol address][
  *Execution*: host invokes plugin function
  ]

//Related term: *Foreign Function Interface*

/*
=== Dynamic Linking/Loading

#grid(
  columns: (1fr, auto),
  align: horizon,

  enum(numbering: "1)")[Discovery][Loading][Resolution][Execution],
  figure[
    #image("res/dynamic_linking_figure.svg", width: 90%)
  ],
)
*/

== (Unstable) Rust ABI

=== Demonstration of dynamic linking and loading

// Everything after "let symbol" is just for rust :3
// lib is required to store the functions "lifetime"...


```rust
// In base library (used by application and plugin):
trait Fuser { 
  fn fuse(&self, data: &[SensorData]) -> Result<SensorData, Box<dyn Error>>; }
```

#codly(highlights: (
  (line: 5, start: 10, end: 18, fill: color_hensoldt, ),
  (line: 6, start: 28, end: 41, fill: color_thu,), // add AVGERAGEPLUGIN COLOR
  (line: 6, start: 54, end: 73, fill: color_hensoldt, ),
))

```rust
// In plugin:
struct AveragePlugin;
impl Fuser for AveragePlugin { ... }

#[unsafe(no_mangle)] // ensure name can be found in binary
pub fn average_plugin() -> Box<dyn Fuser> { Box::new(AveragePlugin::new()) }
```

#pagebreak()

// extern "Rust" -> use Rust ABI

#codly(highlights: (
  (line: 2, start: 17, end: 29, fill: color_hensoldt),
  (line: 2, start: 31, end: 52, fill: color_thu),
  (line: 3, start: 13, end: 28, fill: color_thu),
  (line: 8, start: 29, end: 40, fill: color_thu),
))

```rust
// In application:
type FuseFunc = extern "Rust" fn() -> Box<dyn Fuser>; // use Rust ABI
let plugin: Plugin<FuseFunc> = Plugin::new( // internally uses `libloading`
  &plugin_path.into(),
  "average_plugin".as_bytes() 
).unwrap(); // Discovery, Loading and Resolution

let fuser: Box<dyn Fuser> = plugin.get();
let sd = [ SensorData::new(24.0, 0.01), ... ];
let res = fuser.fuse(&sd); // Execution
```

/*
#pagebreak()

#codly(highlights: (
  (line: 2, start: 5, end: none, fill: yellow),
))

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
*/

=== .... but it's Unstable

The implementation itself is not complex, but...

- Compiler version changes *may* impact the generated binary
- Changes to structs, traits and enums *may* impact the generated binary
- Base library, application and plugins need to run on the *same compiler version*

But we can use the *C ABI* (next slides)! But representing Rust in C (and vice versa) is very difficult and will introduce trade-offs. Some of them are:

- How are structs, traits and enums represented?
- What happens to VTables?
- What about Lifetimes and Ownership?
- ...

// Mention the different representation of a struct in C compared to Rust from earlier
// this is even worse for enums, as a lot of "hidden" optimizations are done here. C can only represent enums as tagged unions + index, while Rust can optimize a lot here!
// VTables for runtime polymorphism? C requires manual dispatching, but also C++ internal structure is different to Rust (pointers to Data and VTable)

== abi_stable crate

- Usage of ```rust #[sabi_trait]```, ```#[export_root_module]```, ```#[sabi_extern_fn]```, ... attribute macros for creating FFI-safe (Foreign Function Interface) trait objects // FULL NAME FOR FFI
- Allows for a lot of customization when specifying the FFI
- Provides ABI-stable alternatives to many _std-types_, but also some _external types_
- Widely used crate with a lot of community support 

*but*:

- Many hidden structs and types are generated and are required for further use, therefore it is overwhelming at first
- Usage of ```rust async``` is not possible, because a FFI-safe wrapper for ```rust Future``` is not supported. 
- Github repository seems to be dormant.

== stabby crate

// stabby for struct and traits
// export for functions
// dynptr as handy shortcut for returning generated vtables for a specific trait 

- Easy to get started as primarily ```rust #[stabby::stabby]```, ```rust #[stabby::export]``` and ```rust stabby::dynptr!(...)``` are used.
- Good explanation of the concepts behind ABI development (and why Rust doesn't like the C ABI and vice versa) // docu good, rustCONF talk good too
- Provides ABI-stable alternatives to common types
- Built for performance
- "Compiler-change-proof ABI-stability is proven statically through the type system."

*but*:

- relatively new and therefore not a lot of community engagement (yet) // 1.0.0 was released 2.5 years ago
- had some breaking changes between versions due to a rust compiler update
- documentation can be spotty at times

/*
#pagebreak()

// i am sparing you of a lot of macro code @w@
// "optimal layout" can be disabled
// for traits: add "checked" to ensure functions signature are abi-stable

Stab a struct like this: 

```rust
#[stabby::stabby] 
pub struct MyStruct { hi: u8, there: u16, }
```

To get this:

```rust
#[repr(C)] // guarantees that the layout stays fixed
pub struct MyStruct { hi: u8, there: u16, }
impl stabby::IStable for MyStruct { 
	// Dark magiks that compute MyStruct's layout,
	// Taking note that an entire byte is unused at offset 1 from the structure's start.
	...
}
const _: () = {	assert!(MyStruct::has_optimal_layout()) }
```
*/

#pagebreak()

== Comparison ABI crates

// Overhead of stabby is reduced by the enforcement of the type system
// 
// dev complexity and language limitations rated very low for unstable_abi due to it's "language lock" that it implies
// development complexity for unstable_abi could be argued with a "-",
// but i decided to value it the same as stabby. stabby is still newish and whenever breaking changes are mentioned i'd like to take a step back...
// 
// interoperability for abi_stable and stabby is + because of the use of the C ABI (but good luck using this now in other languages...)


#figure(
  table(
    columns: 5,
    table.header[*Crate*][*Perf. Diff*][*Development Complexity*][*Limitation*][*Interoperability*],
    [*native*], [], [++], [0], [0],
    [*unstable_abi*], [16%], [\-\-], [\-\-], [0],
    [*abi_stable*], [25%], [0], [0], [+],
    [*stabby*], [#emph(text(color.green.darken(20%))[9%])], [0], [0], [+],
  ),
  caption: [Summary of ABI results.],
) <summary-abi-table>

#figure(
  table(
    columns: 3,
    table.header[*Crate*][*Macro Calls*][*Type Changes*],
    [*unstable_abi*], [1], [0], // no_mangle
    [*abi_stable*], [ #emph(text(red)[16])], [2], // too many, vec and slice
    [*stabby*], [3], [2], // as said earlier, vec and slices
  ),
  caption: [Code complexity depicted as amount of line or type changes. ],
) <abi_code_complexity>
#pagebreak()


= Interprocess Communication (IPC)

#heading(level: 2, outlined: false)[Interprocess Communication (IPC)]

#figure[
  #image("res/ipc_figure.svg", width: 100%)
]

Biggest takeaway: Shared memory is not accessible by default for this approach. Therefore (de-) *serialization* is required. 


== rustbridge crate // note the correct spelling!!

High-level JSON, native Rust speed — Work with serde types, not raw pointers!


#figure(
  image("res/rustbridge_overview.png", width: 80%),
  caption: "A rustbridge plugin can be bundled into a .rbp file and used across different languages.",
)
//- One plugin, many languages
//- Production-ready bundles — Code signing, SBOM, checksums, multi-platform support

#pagebreak()

- Stable C ABI — Plugins work regardless of your Rust compiler version or optimization flags
- Managed lifecycle: Startup, shutdown, including logging callbacks
- Communication with Request/Response Headers (JSON or Binary)
- Usage of CLI tools to create the `.rbp` bundle
- Excellent technical documentation and examples

*but*:

- No shared memory, therefore performance loss due to serialization
- Binary approach requires manual conversion of bytes to types
- Requires strict separation of plugin and application // reusing structs "from base library" isn't possible

== Comparison rustbridge JSON vs Binary

// Complexity: no shared memory, therefore the use of serialization
// Debatable if this should have also reduced the "Language Limitation" here
// JSON serialization is easily implemented using serde
// Binary requires manual conversion and is therefore error prone, espc. when the internal data are complex data types

#figure(
  table(
    columns: 5,
    table.header[*Crate*][*Perf. Diff*][*Development Complexity*][*Limitation*][*Interoperability*],
    [*native*], [], [++], [0], [0],
    [*rustbridge (JSON)*], [#emph(text(red)[537%])], [+], [0], [++],
    [*rustbridge (Binary)*], [25%], [-], [0], [++],
  ),
  caption: [Summary of IPC results.],
) <summary-ipc-table>

= Conclusion

#heading(level: 2, outlined: false)[Conclusion]

// Ultimatively, this display isn't the best as it doesn't show the nuances and the results or very subjective
// How one would choose an approach also depends on the use-case
// For me personally, the most flexible option rustbridge

#figure(
  table(
    columns: 5,
    table.header[*Crate*][*Perf. Diff*][*Development Complexity*][*Limitation*][*Interoperability*],
    [*native*], [], [++], [0], [0],
    [*unstable_abi*], [16%], [\-\-], [\-\-], [0],
    [*abi_stable*], [#emph(text(blue)[25%])], [0], [0], [+],
    [*stabby*], [9%], [0], [0], [+],
    [*rustbridge (JSON)*], [537%], [+], [0], [++],
    [*rustbridge (Binary)*], [#emph(text(blue)[25%])], [-], [0], [++],
  ),
  caption: [Summary of results.],
) <summary-table>


- Development complexity and Limitation aren't fine grained enough
- Updating the plugin and host hasn't been tested

#pagebreak()

From the 2025 Rust Survey:
- 14% of respondents stated that a stable ABI would unblock their use cases - around 24% state that it would improve their code
- 13% consider implementing a dynamic library plugins a significant problem 

Currently no visible signs that a stable ABI is coming anytime soon.

//#heading(level: 2, outlined: false)[Finished!]

#grid(
  columns: (1fr),
  rows: (1fr),
  align: horizon + center,
  [
    #text(size: 2.4em)[Thank you for your attention! #linebreak() Any questions?],
  ]
)

/*
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
  where TFunc: PluginFactory<Dyn = TDyn> {
    let lib = unsafe { libloading::Library::new(plugin_name)? };
    let my_imported_function = unsafe { lib.get_stabbied::<TFunc>(symbol)? };
    let fund = *my_imported_function;
    let tdyn = fund.get();
    Ok(Self { func: tdyn, _lib: lib, })
  }
  pub fn get(&self) -> &TDyn { &self.func }
  pub fn get_mut(&mut self) -> &mut TDyn { &mut self.func }
}
```

```rust
let mut plugin: Plugin<FuserPluginDyn> = 
  get_plugin::<FuseFunc>(plugin_path.into(), "average_plugin".as_bytes()).unwrap();
let data = [ SensorData::new(24.0, 0.01), ... ];
let data: Slice<'_, SensorData> = Slice::new(&data);
let fuser = plugin.get();
let res = fuser.fuse(data);

pub fn get_plugin<TFunc>(
  plugin_name: PathBuf,
  symbol: &[u8],
) -> Result<Plugin<TFunc::Dyn>, Box<dyn Error + Send + Sync>>
where TFunc: PluginFactory {
  Plugin::<TFunc::Dyn>::new::<TFunc>(&plugin_name, symbol)
}

```
#pagebreak()

== rustbridge implementation

=== Plugin (JSON)

```rust
#[derive(Debug, Clone, Serialize, Deserialize, Message)]
#[message(tag = "fuse")]
struct FuseRequest { sd: Vec<SensorData>, }

#[derive(Debug, Clone, Serialize, Deserialize)]
struct FuseResponse { sd: SensorData, }

#[derive(Default)]
struct FuserPlugin;
impl FuserPlugin {
  fn new() -> Self { Self }
  fn handle_fuse(&self, req: FuseRequest) -> PluginResult<FuseResponse> {
    let fused_data = average_fuse(&req.sd); // average_fuse is the actual "execution" of the fusion 
    Ok(FuseResponse { sd: fused_data })
  }
}

#[async_trait]
impl Plugin for FuserPlugin {
  async fn on_start(&self, _ctx: &PluginContext) -> PluginResult<()> {
    register_binary_handlers();
    Ok(())
  }
  async fn handle_request(
    &self,
    _ctx: &PluginContext,
    type_tag: &str,
    payload: &[u8],
  ) -> PluginResult<Vec<u8>> {
    match type_tag {
      "fuse" => {
        let req: FuseRequest = serde_json::from_slice(payload)?;
        let resp = self.handle_fuse(req)?;
        Ok(serde_json::to_vec(&resp)?)
      }
      _ => Err(PluginError::UnknownMessageType(type_tag.to_string())),
    }
  }
  async fn on_stop(&self, _ctx: &PluginContext) -> PluginResult<()> {
    tracing::info!("fuser-plugin stopped");
    Ok(())
  }
}

fn register_binary_handlers() {
  // from rustbridge:
  register_binary_handler(MSG_FUSER_CREATE, handle_fuser_create);
}

rustbridge_entry!(FuserPlugin::new);
// Re-export FFI functions for the shared library
pub use rustbridge::ffi_exports::*;
```

=== Application (JSON)

```rust
let plugin = NativePluginLoader::load_bundle(BUNDLE_PATH)?;
if !plugin.has_binary_transport() {
  return Err(ConsumerError::MissingSymbol(
    "Binary transport not available in this plugin".into(),
  ));
}
let sd: Vec<SensorData> = vec![SensorData::new(22.5, 0.3), SensorData::new(23.0, 0.2)];
let response: JsonFuseResponse = plugin.call_typed("fuse", &JsonFuseRequest { sd: sd })?;
println!("JSON Response: {:#?}", response.sd,);
```


=== Plugin (Binary)

```rust
pub const MSG_FUSER_CREATE: u32 = 100; // Message ID for fuser creation
#[repr(C)]
#[derive(Debug, Clone, Copy)]
pub struct FuserRequestHeader {
  pub version: u8,
  pub _reserved: [u8; 3],
  pub payload_size: u32, 
}
impl FuserRequestHeader {
  pub const VERSION: u8 = 1;
  pub const SIZE: usize = 8;
}
```

```rust
#[repr(C)]
#[derive(Debug, Clone, Copy)]
pub struct FuserResponseHeader {
  pub version: u8,
  pub _reserved: [u8; 3],
  pub payload_size: u32,
}
impl FuserResponseHeader {
  pub const VERSION: u8 = 1;
  pub const SIZE: usize = 8;
}
```

=== Application (Binary)

```rust
let plugin = NativePluginLoader::load_bundle(BUNDLE_PATH)?;
if !plugin.has_binary_transport() {
  return Err(ConsumerError::MissingSymbol(
      "Binary transport not available in this plugin".into(),
  ));
}
let sensor_data = vec![SensorData::new(22.5, 0.3), ... ];
let request = create_request(&sensor_data);
let response = plugin.call_raw(MSG_FUSER_CREATE, &request)?;
let (header, sensor_data) = parse_response(&response)?;
println!(
  "Fuser Response: v{} {:#?} ({} bytes)",
  header.version,
  sensor_data,
  std::mem::size_of_val(sensor_data)
);
```

#pagebreak()
```rust
pub fn create_request(sensor_data: &[SensorData]) -> Vec<u8> {
  let mut request = Vec::with_capacity(
    BinaryFuserRequestHeader::SIZE + 
    (sensor_data.len() * std::mem::size_of::<SensorData>()),
  );

  let header = BinaryFuserRequestHeader::new(
    (sensor_data.len() * std::mem::size_of::<SensorData>()) as u32
  );
  request.extend_from_slice(&header.to_bytes());

  let payload = unsafe {
    std::slice::from_raw_parts(
        sensor_data.as_ptr() as *const u8,
        sensor_data.len() * std::mem::size_of::<SensorData>(),
    )
  };
  request.extend_from_slice(payload);
  request
}
```

#pagebreak()
```rust
pub fn parse_response(data: &[u8]) -> Result<(BinaryFuserResponseHeader, &SensorData), ConsumerError> {
  let header = BinaryFuserResponseHeader::from_bytes(data).ok_or_else(|| {
    ConsumerError::InvalidResponse(format!("Response too small: {} bytes", data.len()))
  })?;

  if header.version != BinaryFuserResponseHeader::VERSION {
    return Err(ConsumerError::InvalidResponse(...));
  }

  let expected_size = BinaryFuserResponseHeader::SIZE + header.payload_size as usize;
  if data.len() < expected_size {
    return Err(ConsumerError::InvalidResponse(...));
  }

  let fuser_data = &data[BinaryFuserResponseHeader::SIZE..expected_size];
  let sensor_data = unsafe { &*(fuser_data.as_ptr() as *const SensorData) };
  Ok((*header, sensor_data))
}
```
*/


// Feedback:
// - Farblich Unterschiede erkennbar machen z.B. durch bunte Bloecke
