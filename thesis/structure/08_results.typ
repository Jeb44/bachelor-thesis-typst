/*
 This section presents the procedure you used to prove that your solution from the Method section meets the requirements.
 Typically, you will need to describe why the selected test scenarios are at all suitable for a substantiated statement, which characteristics the test has, etc.
 In addition, for each test you must specify with which parameterization and in which
environment etc. the test was carried out, and which results this gave (objective, factual).
 Subsequently, you need to evaluate the significance of these results (subjective, evaluation).
The following structure is common in many theses:
 4.1 Test cases and their relationship to the problems described in Section 3
 4.2 The individual test cases and their results
 4.3 Evaluation of the results
Formulated slightly differently:
 4.1 Validation of the overall concept
 4.2 Description and motivation for the test cases
 4.3 Overview and evaluation of the acquired results
It is often helpful to present the contents of this section in a table displaying the
requirements/problems from section 3 and the tests/results from section 4. The table
format makes it clear to see which parts were covered, tested, could not be tested,
were as expected, deviated etc.
*/

= Results

== Validation of the overall concept

// put fusion sample here?

All our plugins have to implement the following trait:

#figure(
  align(left, ```rust
  trait Fuser {
    fn fuse(&self, data: &[SensorData]) -> Result<SensorData, Box<dyn std::error::Error>>;
  }
  ```),
  caption: [Fuser trait definition],
) <fuser-trait>

The ```rust Fuser``` trait defines a single method, ```rust fuse(...)```, which takes a slice of ```rust SensorData``` and returns a fused ```rust SensorData``` or an error.

#figure(
  align(left, ```rust
  struct SensorData {
    temperature: f64,
    deviation: f64,
  }
  ```),
  caption: [SensorData struct definition],
)

In our benchmark, a ```rust SensorData``` represents a tuple of temperate and deviation. From a practical sense, many temperature sensors have a small margin of error (deviation), which can be used to calculate a more accurate temperature reading by fusing the data from multiple sensors.

The implementation of the ```rust fuse(...)``` method will be the same for all plugins, as we want to focus on the performance of the different approaches, and not on the implementation of the plugin itself. The only difference will be the way we load and execute the plugin, which will be the focus of our evaluation. In some cases, we needed to make some adjustments to the function parameters and return types to fit the requirements of the different approaches. These differences will be explained in the respective sections.

As a control group, we ran the same benchmark using a static and dynamic variations first, without the use of any Plugin logic, which evaluates to ```rust AverageFuser``` and ```rust Box<dyn Fuser>``` respectively.

== Description and motivation for the test cases

=== Control group: Static and Dynamic variation

==== Performance

First, we want to establish a baseline for the performance of our benchmark by running it without any plugin logic. This will allow us to understand the overhead introduced by the plugin system and to compare the results of the different approaches against this baseline.

#figure(
  table(
    columns: 3,
    table.header[*Test Case*][*Standard*][*Blackboxed*],
    [Creation], [243.18 ps], [245.37 ps],
    [Single Fuse], [1.2422 ns], [2.3027 ns],
    [Multi Fuse], [856.15  #sym.mu\s], [865.71 #sym.mu\s],
  ),
  caption: [Criterion benchmark: Static variation],
) <criterion-control-group-static>

#figure(
  table(
    columns: 3,
    table.header[*Test Case*][*Standard*][*Blackboxed*],
    [Creation], [242.86 ps], [249.83 ps],
    [Single Fuse], [1.2440 ns], [2.3058 ns],
    [Multi Fuse], [859.60  #sym.mu\s], [865.63 #sym.mu\s],
  ),
  caption: [Criterion benchmark: Dynamic variation],
) <criterion-control-group-dynamic>

When comparing table @criterion-control-group-static and table @criterion-control-group-dynamic, we can see that the results are very similar, which indicates that the difference between static and dynamic variations does not have a significant impact on the performance of the benchmark. This is expected, as the only difference is how the ```Fuser``` trait is implemented and called.

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*Instructions*][*Inst. (Blackboxed)*][*Estimated Cycles*][*Est. Cyc. (Blackboxed)*],
    [Creation], [1], [1], [36], [36],
    [Single Fuse], [43], [89], [94], [333],
    [Multi Fuse], [92], [4,500,136], [225], [15,000,936],
  ),
  caption: [Gungraun benchmark: Static variation],
) <gungraun-control-group-static>

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*Instructions*][*Inst. (Blackboxed)*][*Estimated Cycles*][*Est. Cyc. (Blackboxed)*],
    [Creation], [1], [21], [2], [140],
    [Single Fuse], [99], [108], [320], [371],
    [Multi Fuse], [4,500,146], [4,500,155], [15,001,017], [15,001,102],
  ),
  caption: [Gungraun benchmark: Dynamic variation],
) <gungraun-control-group-dynamic>

The estimated cycles of the table @gungraun-control-group-static and table @gungraun-control-group-dynamic show that the final results are very similar.


==== Development complexity

We are sticking to the standard Rust development process, which is well-documented and widely used in the Rust community. This means that we are using the standard Rust toolchain, including Cargo for package management and build automation, and we are following the standard Rust coding conventions and best practices. This approach allows us to leverage the existing Rust ecosystem and resources, and it provides a familiar development experience for Rust developers.

As this is the control group, this represent the state of rust and therefore we are assigning a rating of ++.

==== Limitation

Our control group does not have any *limitations* on a technical level, as we are not introducing any dynamic loading or plugin logic here. We are using the base library of Rust and all of the features this language provides. This is standard rust and therefore the limitations are the same as for any other Rust project.

While it is not possible to introduce dynamic plugins in this control group, we can still put this as optimal showcase of minimal limitations that a plugin system might have - therefore we rate this as: ++.

==== Interoperability

In this control group, *interoperability* is not an option, as we cannot introduce dynamic plugins here. Using the metrics stated in @interoperability, we can evaluate the control group as follows: 0.

=== Unstable Rust ABI

==== Performance

Running the benchmark with the Unstable Rust ABI approach, we can see that the performance is significantly worse compared to the control group, which is expected due to the overhead of communication via FFI.

#figure(
  table(
    columns: 3,
    table.header[*Test Case*][*Standard*][*Blackboxed*],
    [Creation], [218.24 #sym.mu\s], [217.24 #sym.mu\s],
    [Single Fuse], [8.1845 ns], [7.4945 ns],
    [Multi Fuse], [0.998 ms], [1.0009 ms],
  ),
  caption: [Criterion benchmark: Unstable Rust ABI variation],
) <criterion-unstable-abi>

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*Instructions*][*Inst. (Blackboxed)*][*Estimated Cycles*][*Est. Cyc. (Blackboxed)*],
    [Creation], [1,090,531], [1,090,534], [1,637,886], [1,637,923],
    [Single Fuse], [182], [191], [553], [604],
    [Multi Fuse], [10,500,230], [10,500,239], [21,001,579], [21,001,630],
  ),
  caption: [Gungraun benchmark: Unstable Rust ABI variation],
) <gungraun-unstable-abi>

==== Development complexity

For the Unstable Rust ABI approach, we are using the standard Rust development process, which is well-documented and widely used in the Rust community. However, due to the unstable nature of the Rust ABI, we need to be careful when updating our rust compiler version. This will essentially lock you in place for the duration of your project. This risk might be okay on a small scale, but as soon as your software or library needs to grow and incorporate other developers or libraries, it is not acceptable to use.

Therefore, we are rating the development complexity of this approach as -. We see this restriction alone to a specific Rust compiler version as a significant disadvantage.

==== Limitation

The limitations of the Unstable Rust ABI approach are similar to the development complexity. You are not able to update your compiler version and therefore working with other libraries (which might require a newer version of the compiler) is restricted.

==== Interoperability

There is no interoperability with the Unstable Rust ABI approach, as the plugin and the host application must be compiled with the same version of the Rust compiler to ensure compatibility. This means that you cannot use plugins compiled with a different version of Rust, which significantly limits the flexibility and usability of this approach. Other languages are also not able to understand the Rust ABI. While there are some similarities between the C and Rust ABI, the Rust compiler is using it's LLM to optimize parts of the code.

Therefore, we are rating the interoperability of this approach as 0.

=== abi_stable (crate)

==== Performance

#figure(
  table(
    columns: 3,
    table.header[*Test Case*][*Standard*][*Blackboxed*],
    [Creation], [29.745 ns], [29.751 ns],
    [Single Fuse], [8.8004 ns], [9.2904 ns],
    [Multi Fuse], [1.0699 ms], [1.0813 ms],
  ),
  caption: [Criterion benchmark: Stable Rust ABI variation],
) <criterion-stable-abi>

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*Instructions*][*Inst. (Blackboxed)*][*Estimated Cycles*][*Est. Cyc. (Blackboxed)*],
    [Creation], [675,743], [675,632], [1,130,034], [1,129,601],
    [Single Fuse], [200], [209], [740], [791],
    [Multi Fuse], [10,500,248], [10,500,257], [21,001,912], [21,001,963],
  ),
  caption: [Gungraun benchmark: Stable Rust ABI variation],
) <gungraun-stable-abi>


==== Development complexity

The abi_stable crate provides a stable ABI for Rust, which allows developers to create plugins that can be loaded at runtime without worrying about compatibility issues. However, using this crate requires some additional setup and configuration compared to the standard Rust development process. Developers need to define their plugin interfaces using the abi_stable API, which may require some learning curve and additional effort to understand and use effectively.

The documentation for this is decent, but there are some gaps and areas that are not well-explained, without diving into the code itself. 

In addition, the example implementation shows a very good scenario, but it doesn't explain very well, why certain decision were made.

Otherwise, the implementation requires a high amount of boilerplate code, which can be a significant barrier for developers who are not familiar with this type of architecture.

Therefore, we rate this is as approach as +, as it is generally manageable to implement, but requires some additional setup and configuration.

==== Limitation

==== Interoperability


=== stabby (crate)

#figure(
  table(
    columns: 3,
    table.header[*Test Case*][*Standard*][*Blackboxed*],
    [Creation], [ 81.095 #sym.mu\s], [ 75.139 #sym.mu\s],
    [Single Fuse], [ 7.3371 ns], [5.8786ns],
    [Multi Fuse], [933.62 #sym.mu\s], [907.15 #sym.mu\s],
  ),
  caption: [Criterion benchmark: stabby variation],
) <criterion-stabby>

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*Instructions*][*Inst. (Blackboxed)*][*Estimated Cycles*][*Est. Cyc. (Blackboxed)*],
    [Creation], [73,983], [73,985], [133,412], [133,423],
    [Single Fuse], [90], [95], [337], [380],
    [Multi Fuse], [337], [380], [15,000,970], [15,001,013],
  ),
  caption: [Gungraun benchmark: stabby variation],
) <gungraun-stabby>

==== Development complexity

==== Limitation

==== Interoperability

=== rust_bridge (crate)

As this crate allows to differentiate between JSON and binary communication, we will evaluate both of these transport layers separately, as they have different performance characteristics and development complexities. 

==== Performance

Due to an NullHandle error during the plugin creation itself with criterion, we were not able to run the whole criterion benchmark for the rust_bridge crate. It appears that there is some issue when creating the plugin itself, which seems to be related to the reading of the plugin file. Until the end of the deadline for this thesis, a solution was not found.

For the creation of the plugin, a total of 104,733,470 instructions were required, which results in an estimated 126,094,247 cycles. Using a `blackbox` version, shows that the creation of the plugin requires 104,733,497 instructions and 126,094,318 cycles, which is very similar to the standard version, and therefore indicates that the creation of the plugin is not affected by the optimizations of the compiler.

The benchmark follow the same structure that is required for communicating with the rust_bridge crate. First, we create a request header (json and binary; single and multiple) and then we send it to the plugin, which will process the request by performing the fusion (single or multiple) and return a response. The response has to be additionally parsed in the binary version only. Additionally, the response has the same structure regardless of input size @fuser-trait.

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*JSON*][*JSON (Blackboxed)*][*Binary*][*Binary (Blackboxed)*],
    [Request Single], [6.9305 ns], [9.6154 ns], [10.266 ns], [10.846ns],
    [Fuse Single], [2.7541 #sym.mu\s], [7.7651 #sym.mu\s], [127.21 ns], [127.45 ns],
    [Response], [-], [-], [2.5295ns], [6.3095ns],
    [Total (Single)], [2.7610 #sym.mu\s], [7.7747 #sym.mu\s], [139.005 ns], [144.605 ns],
  ),
  caption: [Criterion benchmark: rust_bridge (single ```rust SensorData```)],
) <criterion-rustbridge-single>

Looking at the required amount of time for the fusion (which includes the transport of the data), we can clearly see, that this is a heavy process in the JSON version, which is expected due to the overhead of parsing and serializing JSON data. In contrast, the binary version is much faster, which can be attributed to the fact that the binary version does not require parsing and serializing of JSON data. The request header creation is very fast in both versions, which indicates that the communication with the plugin is not affected by the optimizations of the compiler. The response parsing is also very fast in both versions, which indicates that the communication with the plugin is not affected by the optimizations of the compiler.

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*JSON*][*JSON (Blackboxed)*][*Binary*][*Binary (Blackboxed)*],
    [Request Multiple], [40.045 ns], [965.32 #sym.mu\s], [969.30 #sym.mu\s], [974.90 #sym.mu\s],
    [Fuse Multiple], [460.39 ms], [455.40 ms], [1.0599 ms], [1.0917 ms],
    [Response], [-], [-], [2.5295ns], [6.3095ns],
    [Total (Multiple)], [460.43 ms], [455.40 ms], [1.0625 ms], [1.0989 ms],
  ),
  caption: [Criterion benchmark: rust_bridge (multiple ```rust SensorData```)],
) <criterion-rustbridge-multiple>

When taking a look at the blackboxed values, we can see that the optimizations of the compiler doesn't have a big impact on the results, which indicates that the results are not affected by any optimizations of the compiler. The fusion process is the most time-consuming part of the benchmark, which is expected due to the fact that it involves processing a large amount of data and performing complex calculations. The request header creation in the JSON version seems to be able to have some optimizations.

Comparing the results to the benchmarking results of the rust_bridge crate, we can see that the results are similar, which indicates that the performance of the rust_bridge crate is consistent with the performance of the control group. This is a good indication that the rust_bridge crate is performing as expected and that the results are not affected by any optimizations of the compiler. @crate-rustbridge-transport-layers

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*JSON Instructions*][*JSON Inst. (Blackboxed)*][*Binary Instructions*][*Binary Inst. (Blackboxed)*],
    [Request Single], [43], [56], [198], [202],
    [Request Multiple], [92], [105], [75,382,326], [75,382,330],
    [Fuse Single], [60,439], [60,456], [36,793], [36,804],
    [Fuse Multiple], [4,518,965,517], [4,519,030,617], [10,536,920], [10,536,931],
    [Response], [-], [-], [135], [143],
  ),
  caption: [Gungraun benchmark: Instruction Count for rust_bridge],
) <gungraun-rustbridge>

#figure(
  table(
    columns: 5,
    table.header[*Test Case*][*JSON Instructions*][*JSON Inst. (Blackboxed)*][*Binary Instructions*][*Binary Inst. (Blackboxed)*],
    [Request Single], [94], [185], [459], [501],
    [Request Multiple], [225], [350], [155,053,204], [155,053,246],
    [Fuse Single], [108,962], [109,185], [61,448], [61,584],
    [Fuse Multiple], [6,283,037,647], [6,283,110,964], [21,097,406], [21,097,668],
    [Response], [-], [-], [457], [581],
  ),
  caption: [Gungraun benchmark: Estimated Cycles for rust_bridge],
) <gungraun-rustbridge>

The instruction count show that the JSON version does require significantly less instructions compared to the binary version, but in the resulting estimated cycles, we can see that the JSON version requires significantly more cycles compared to the binary version, which indicates that the instructions in the JSON version are more complex and require more processing power compared to the binary version. This is expected due to the overhead of parsing and serializing JSON data, which can be computationally expensive.

Here it also confirms that the optimizations of the compiler doesn't have a big impact on the results, which indicates that the results are not affected by any optimizations of the compiler. 

In summary, the performance of the binary transport layer is on par with the control group, while the performance of the JSON transport layer is significantly worse compared to the control group.

==== Development complexity

Overall, the implementation for the rust_bridge crate is rather mixed. While the serialization and deserialization for the JSON data is straightforward and well-documented, the binary communication with the plugin is more complex and requires a deeper understanding of the data layout of your structs. That being said, the example provided for the binary approach can be followed step by step, which makes it relatively easy to implement. 

The documentation of the crate is very good with extensive showcases of diagrams and examples. The technical documentation features diagrams for it's architecture, describes the lifecycle of a plugin, how the request and response flow works,  and a lot more.

We rate the development complexity of the JSON transport layer as ++ due to it's simplicity, while the binary transport layer is rated as + due to the additional complexity of handling binary data and ensuring that the data layout is correct. 

==== Limitation

As stated by the documentation of the crate, the current limitations are related to the reloading of plugins and the usage of multiple instances. @crate-rustbridge-limitations-reload-multiple-instances
Reloading of plugins is technically already possible, but due to it's inherently fragile nature (global state, background threads, third-party libraries side effects) it is currently not recommended to use this feature. Instead it is recommended to restart a process instead of a dynamic reload.
For the multiple instances, the crate does support this feature, but the logging and tracing infrastructure is not designed to handle multiple instances, which can lead to some issues when using this feature.
Other limitations are related to the JSON transportation layer. There, the usage of pointers and references is not supported, which can limit the types of data that can be easily serialized and deserialized. 

In total, we rate the limitations of the JSON transport layer and the binary transport layer as +. The limitations are there and need to be considered when designing a large and efficient plugin system, but for most other use cases, these limitations can be easily worked around.

==== Interoperability

A plugin is exported in the form of a rbp-file. Using this file (and the corresponding crates bindings), this plugin can be used in any Rust application, but also other languages like Python, Java, Ruby and more. Due to the serialization to a JSON, it is generally very flexible. The binary layer needs a bit more work, but can be used across the language boundaries as well, as long as the data layout is correct and the corresponding bindings are implemented.

We give this crate a rating of ++ for interoperability, as it allows for a wide range of use cases and can be used in various programming languages, which makes it a very flexible solution for plugin development.


== Overview and evaluation of the acquired results

#figure(
  table(
    columns: 5,
    table.header[*Crate*][*Performance (Multi Fuse)*][*Development Complexity*][*Limitation*][*Interoperability*],
    [*native*], [0.856 ms], [++], [++], [0],
    [*unstable_abi*], [0.998 ms], [], [], [],
    [*stable_abi*],  [1.0699 ms], [], [], [],
    [*stabby*], [0.934 ms], [], [], [],
    [*rust_bridge (JSON)*], [460.43 ms], [], [], [],
    [*rust_bridge (Binary)*], [1.063 ms], [], [], [],
  ),
  caption: [Summary of results\nNote: Creation for rust_bridge only includes the creation of the request header],
) <gungraun-rustbridge>


