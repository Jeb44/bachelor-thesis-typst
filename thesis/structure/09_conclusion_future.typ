/*
 This is where the results from section 4 are revisited in a broader context and assessed
in terms of the thesis objectives.
 Sometimes it makes sense to put a table together showing
• which objectives were implemented completely,
• which were implemented but not tested,
• which were not implemented but were incorporated in the design,
• which should have been taken into account, but which you only became aware of
with the benefit of hindsight etc.
 The outlook on future work permits statements to be made regarding ideas for further
work or unanswered questions, although these ideas have in no way been expanded
upon. Generally, upon completing a thesis, you end up with more new questions than
you answered. Readers of this section will be able to immediately recognize whether
you have thought the problem through well.

It is expected that you reflect upon your approach and the results you achieved
retrospectively – i.e. to critically assess and categorize your work.
*/


= Conclusion and Future Work

== Conclusion

This thesis set out to analyze the available approaches for implementing plugin systems in Rust across four criteria: performance overhead, development complexity, language limitations and interoperability. Four approaches were selected for evaluation — the Unstable Rust ABI, the `abi_stable` crate, the `stabby` crate, and the `rustbridge` crate — and benchmarked against a baseline implementation with no plugin logic.

The results show a clear trade-off spectrum. The *Unstable Rust ABI* approach is the most direct, but its instability effectively locks the entire project to a single compiler version and strips away most of Rust's expressive type system at the plugin boundary, making it unsuitable for any production scenario that expects to evolve over time. The *abi_stable* crate addresses the stability problem at the cost of roughly 25% performance overhead and significant boilerplate, but it is production-proven and reasonably interoperable through its C-compatible interface. The *stabby* crate achieves a similar goal with a more modern, lightweight design and roughly half the performance overhead (~9%), but it is a newer project with fewer community resources. The *rustbridge* crate takes a fundamentally different direction by isolating the plugin in a separate process and communicating over IPC; its binary transport layer comes close to the ABI-based approaches in overhead (~25%), while its JSON transport layer trades performance (~537% overhead) for near-universal language interoperability and the strong isolation guarantee that a crashing plugin cannot take down the host.

No single approach is universally best. Developers who need maximum raw performance within a single-language Rust ecosystem and can tolerate stability risks may prefer the unstable ABI or `stabby`. Developers who need cross-language plugins, or who prioritize crash isolation over throughput, should consider `rustbridge`. Developers who need a battle-tested, broadly compatible solution with acceptable overhead will find `abi_stable` to be the safest bet today.

The broader picture confirms what the community has long argued: the absence of a stable Rust ABI forces developers to choose between fragile native approaches and heavyweight workarounds. According to the 2025 Rust Survey, around 14% of respondents stated that a stable ABI would unblock their use case, and around 24% said it would improve their code. Approximately 13% considered implementing dynamic library plugins to be a significant problem for their productivity @survey-2025-wishes-challenges. These numbers underline that, while the problem affects a meaningful share of the Rust community, it is not yet treated as a blocker by the language team — leaving plugin developers in a fragmented landscape for the foreseeable future.

== Future Work

Several directions would extend the findings of this thesis:

- *Extended analysis of development complexity*: A more systematic developer study involving surveys or interviews with practitioners who have implemented Rust plugin systems could provide richer insights into the real-world development challenges and trade-offs beyond what can be inferred from documentation and code analysis alone.

- *Increased benchmark scope*: Expanding the benchmarks to include more complex plugin workloads (e.g., plugins that perform significant computation, manage state, or interact with external resources) would help to understand how the overheads scale in more realistic scenarios.

- *Stabilization of the Rust ABI*: The most impactful change would be an official stable ABI for Rust. RFC \#1675 @rfc-1675 and related proposals have been deferred, but renewed community pressure and growing industrial adoption may eventually make this a priority. A follow-up analysis once any stabilization lands would be valuable.

- *WebAssembly as a plugin runtime*: Wasm was explicitly excluded from this thesis due to scope constraints, but it represents a compelling alternative: it provides a language-agnostic, sandboxed execution environment with a stable binary interface. A comparative study of Wasm-based plugin systems (e.g., via `wasmtime` or `extism`) against the approaches analyzed here would be a natural next step.


