= Safety (Notes)

== Levels

- SIL 1-4 (Safety Integrity Level)
- ASIL A-D (Automotive Safety Integrity Level)
- DAL A-E (Design Assurance Level)
- ...


=== DO-178C

Software Considerations in Airborne Systems and Equipment Certification

- Compiler by Ferrocene is currently the only qualified one
- Whole toolchain needs to be qualified, not just the compiler (static analyzers, coverage tools, linkers), otherwise extensive "tool validation" is required
- ...

*Problem for this thesis*: I am using crates that are not qualified. For now, we can summarize all rust crates as "not qualified"...

*My approach would be*: Just mention this, and then say that we will not focus on this aspect in this thesis, but it is an important topic for future work.

Some sources for this topic:
- https://ferrocene.dev/ (ISO 26262 (ASIL D), IEC 61508 (SIL 4) and IEC 62304 available targeting Linux, QNX Neutrino or your choice of RTOS)
- https://ferrous-systems.com/blog/ferrocene-libcore-news-release/
- https://rustfoundation.org/security-initiative/
- https://rustfoundation.org/media/announcing-the-safety-critical-rust-consortium/



