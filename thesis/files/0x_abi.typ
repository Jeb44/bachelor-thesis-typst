= ABI

Explain ABI and why it's important.

Calling Conventions, Where is Data saved and all that...

Some Source for this: https://doc.rust-lang.org/reference/items/static-items.html#static-items 
??

Rust ABI is not stable, which means that we cannot guarantee that the same binary will work with different versions of the compiler. This is a problem for dynamic plugins, as they need to be compiled separately from the main application.

https://doc.rust-lang.org/reference/abi.html

Add some more details about "other" ABIs (cough C??) and state that that has been the common way of building systems and apps in the past!