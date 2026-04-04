#import "../lib/lib.typ": abstract

#set align(center)
#set par(leading: 1.5em, justify: true)

#abstract([
  Plugin architectures enable extensible software systems by allowing runtime loading of external modules. While Rust offers memory safety guarantees and performance characteristics ideal for plugin development, the language's lack of a stable Application Binary Interface (ABI) presents significant challenges for cross-module compatibility. This thesis examines the landscape of plugin system implementations in Rust, evaluating three primary approaches: native Rust plugins, C ABI-compatible interfaces, and Inter-Process Communication (IPC) mechanisms. Through comparative analysis of technical requirements, performance implications, and maintenance considerations, this work demonstrates that Rust's unstable ABI precludes reliable direct plugin loading across compiler versions. The findings indicate that C ABI remains the optimal choice when performance is paramount, while IPC-based architectures provide superior isolation and version compatibility at the cost of increased overhead. These results contribute practical guidance for developers designing extensible Rust applications and highlight ongoing gaps in Rust's ecosystem for safe, performant plugin architectures.
])
