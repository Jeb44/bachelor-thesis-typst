#import "../lib/bib.typ": load-bib

= Overview

Problem: Rust has unstable ABI, which makes the same approach of C not functional.

Therefore, this paper looks at various approaches. 

This can be seperated into static and dynamic approaches. Static requires the recompilation of binaries.

== Goal

Analysis of these things

=== Static

I can only mention here, that we can enable/disable parts of code during compile time, yes?
aka \#[cfg(feature = "enable_insane_feature")] or cfg!(feature = "enable_insane_feature")
-> extra careful during development, that all required features are structered without accidental deactivations?? 

=== Dynamic

Loading .so w/ libloading -> can be used for c and rust (but both un- and stable rust ABI should work here)

- unstable Rust ABI
- "stable" Rust ABI Crate
- C ABI
- rust bridge

I should probably explain \#[no_mangle] ...

Due to dyn compability, we must use &self or &mut self 

Mention speed up compile times? 





