---
layout: page
title: GSoC 2026 프로젝트 아이디어
---

이 페이지는 다음 기간 동안 개발하고자 하는 프로젝트 아이디어의 예시 목록을 담고 있습니다: [Google Summer of Code 2026](https://summerofcode.withgoogle.com/). GSoC에 기여자로 지원하고 싶다면 다음 단계를 따라 시작하세요:

1. 이 페이지와 Google Summer of Code 가이드를 읽어보세요.
2. 관심 있는 프로젝트 아이디어를 찾거나 직접 구상하세요.
3. [Development 포럼](https://forums.swift.org/c/development/gsoc/98)에서 잠재적 멘토와 소통하세요.
- 특정 프로젝트 참여에 관심이 있는 스레드를 시작할 때 포럼에서 프로젝트 멘토를 자유롭게 언급하세요.

올해 포럼에 GSoC에 대해 게시할 때는 [`gsoc-2026` tag](https://forums.swift.org/tag/gsoc-2026), so it is easy to identify.

## 멘토 연락 방법

Swift 포럼은 스팸 방지 메커니즘이 내장된 토론 포럼 플랫폼 Discourse로 운영됩니다. 포럼에 처음 가입하는 경우, "개인 메시지 보내기" 기능이 자동으로 활성화되기 전에 최소한의 사전 참여가 필요하므로 멘토에게 직접 메시지를 보내지 못할 _수_ 있습니다.

To start things off, we recommend starting a new thread or joining an existing discussion about the project you are interested in on the dedicated [GSoC forums category](https://forums.swift.org/c/development/gsoc/98). You should also _tag_ your thread with the `gsoc-2026` tag. It is best if you start a thread after having explored the topic a little bit already, and come up with specific questions about parts of the project you are not sure about. For example, you may have tried to build the project, but not sure where a functionality would be implemented; or you may not be sure about the scope of the project.

Please use the forums to tag and communicate with the project's mentor to figure out the details of the project, such that when it comes to writing the official proposal plan, and submitting it on the Summer of Code website, you have a firm understanding of the project and can write a good, detailed proposal (see next section about hints on that).

If you would like to reach out to a mentor privately rather than making a public forum post, and the forums are not allowing you to send private messages yet, please reach out to Konrad Malawski at `ktoso AT apple.com` directly via email with the `[gsoc2026]` tag in the email subject and describe the project you would like to work on. We will route you to the appropriate mentor. In general, public communications on the forums are preferred though, as this is closer to the normal open-source way of getting things done in the Swift project.

## 제안서 작성하기

GSoC 동안 작업하고 싶은 코드베이스에 익숙해지면 모든 것이 어떻게 작동하는지, 관심 있는 프로젝트에 어떻게 접근하는 것이 좋은지 더 잘 이해할 수 있어 좋은 제안서를 작성하는 데 도움이 됩니다. How you want to do that is really up to you and your style of learning. You could just clone the repository, read through the source code and follow the execution path of a test case by setting a breakpoint and stepping through the different instructions, read the available documentation or try to fix a simple bug in the codebase. The latter is how many open-source contributors got started, but it's really up to you. If you do want to go and fix a simple bug, our repositories contain a label "good first issue" that marks issues that should be easy to fix and doable by newcomers to the project.

When it comes to writing the proposal, the [Google Summer of Code Guide](https://google.github.io/gsocguides/student/writing-a-proposal) contains general, good advice.

The best proposals include a detailed timeline, specific milestones and goals as well as an outline the technical challenges you foresee. It is best if you engage with your potential project mentor on the forums before contriburing, and have them clarify the goals and steps that they think are necessary for the project to be successful. Your proposal should have a clear goal, which can be successfully achieved as part of the weeks you'll be working it. Provide details about your approach, significant milestones you wish to achieve, and clarify with your potential mentor if they agree those seem reasonable. The time before proposal submissions is there for you to reach out and polish your proposal, so make sure you use it well! Good luck!

## 프로젝트 목록

We are currently collecting project ideas on the forums in the dedicated [GSoC category](https://forums.swift.org/c/development/gsoc/98).

Potential mentors, please feel free to propose project ideas to this page directly, by [opening a pull request](https://github.com/swiftlang/swift-org-website/edit/main/gsoc2026/index.md) to the Swift website.

You can browse previous year's project ideas here: [2025](/gsoc2025/), [2024](/gsoc2024/), [2023](/gsoc2023/), [2022](/gsoc2022/), [2021](/gsoc2021/), [2020](/gsoc2020/), [2019](/gsoc2019/).


### Re-implement property wrappers with macros

**프로젝트 규모**: 350 hours
**예상 난이도**: 중급
**권장 기술**
- Proficiency in Swift and C++

**설명**

[Property wrappers](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0258-property-wrappers.md) feature is currently implemented purely within the compiler but with the addition of [Swift Macros](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0389-attached-macros.md) and [init accessors](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0400-init-accessors.md) it's now possible to remove all ad-hoc code from the compiler and implement property wrappers by using existing features.

This work would remove a lot of property wrapper-specific code throughout the compiler - parsing, semantic analysis, SIL generation etc. which brings great benefits by facilitating code reuse, cleaning up the codebase and potentially fixing implementation corner cases. Macros and init accessors in their current state might not be sufficient to cover all of the property wrapper use scenarios, so the project is most likely going to require improving and expanding the aforementioned features as well.


**기대 성과/이점/산출물**

The outcome of this project is the complete removal of all property wrappers-specific code from the compiler. This benefits the Swift project in multiple areas - stability, testability and code health.

**잠재적 멘토**

- [Pavel Yaskevich](https://github.com/xedin)

### Qualified name lookup for swift-syntax

**프로젝트 규모**: 350 hours

**예상 난이도**: 중급

**권장 기술**

- Basic proficiency in Swift.

**설명**

Qualified name lookup is the process by which a compiler resolves a reference  `A.f` into a lookup for entities named `f` within `A`. In Swift, this can mean looking into the type `A` and all of its extensions, superclass, protocols, and so on to find visible members. The project involves building a new library to be integrated into the [swift-syntax package](https://github.com/swiftlang/swift-syntax) that implements Swift's qualified name lookup semantics, making it easy to build source tools that resolve names. The library will likely include a symbol table implementation that provides efficient lookup of a given name within a given type. It should also integrate with last year's [unqualified name lookup library project](https://forums.swift.org/t/gsoc-2024-swiftlexicallookup-a-new-lexical-name-lookup-library/75889), to provide complete support for name lookup on Swift code processed with swift-syntax.

**기대 성과/이점/산출물**

- Swift library providing APIs for qualified name lookup in swift-syntax
- Documentation and tutorial for the library
- Integration of the Swift library with the `SwiftLexicalLookup` library that implements unqualified name lookup

**잠재적 멘토**

- [Pavel Yaskevich](https://github.com/xedin)


### Task and TaskGroup tracking for Swift Concurrency

**프로젝트 규모**: 160 hours

**예상 난이도**: 고급

**권장 기술**

- Proficiency in C/C++ and Swift
- Understanding of atomics and memory ordering

**설명**

The Concurrency runtime presently does not provide a way to keep track of which `Task`s and `TaskGroup`s are executing.  This information is especially useful for debugging programs that use Swift Concurrency; without it, it's possible to end up in situations where no progress is being made but you cannot see which tasks are outstanding since none of them are actually executing on a thread (so they don't show up in backtraces).

An easy solution might be to have a global linked list of `Task`s and `TaskGroup`s, but that would cause unnecessary synchronization (or, for atomics, contention) between threads, which is highly undesirable.

The goal of this project is to investigate data structures we might use to track `Task`s and `TaskGroup`s and to measure their overhead to make sure that it is acceptable.  A stretch goal might be to implement the necessary support to provide a list of extant `Task`s and `TaskGroup`s in Swift's on-crash backtraces, and to provide some Python macros for LLDB that can list `Task`s and `TaskGroup`s.

**기대 성과/이점/산출물**

- An implementation of `Task`/`TaskGroup` tracking for the Concurrency runtime
- A document detailing the design of the data structures used in the implementation and characterising their overheads, possibly by comparison to the naïve global list approach
- (Stretch) Support for dumping the list of `Task`s and `TaskGroup`s in the on-crash backtracer
- (Stretch) A Python module for LLDB to allow inspection of Concurrency runtime state

**잠재적 멘토**

- [Alastair Houghton](https://github.com/al45tair)
- [Mike Ash](https://github.com/mikeash)

### WebAssembly Reference Types (`externref`) Support in Swift Compiler

**프로젝트 규모**: 200-300 hours

**예상 난이도**: 고급

**권장 기술**

- Proficiency in C/C++, Swift, and WebAssembly;
- Basic understanding of SIL and LLVM IR.

**설명**

Core WebAssembly supports primitive scalar and vector types, such as `i32`/`i64`/`f32`/`f64`, and `v128`. For bridging high-level types that have reference semantics, WebAssembly host environment usually maintains an ad-hoc table that maps indices in this table to references stored in it.

For example, to bridge a garbage-collected JavaScript value to WebAssembly, a naive implementation can allocate a JavaScript array that holds a reference to this value, while an index in this array is passed to Swift compiled to Wasm that it can operate on. While these ad-hoc tables are the primary means to interoperate with JavaScript from Swift, they're not optimal from binary size and performance perspective.

[Recent WebAssembly standard text defines a new built-in `externref` type](https://www.w3.org/TR/2025/CRD-wasm-core-2-20250616/#reference-types①) that can be stored in built-in WebAssembly tables and passed around on WebAssembly stack. It can't be stored in Wasm linear memory, which only supports basic numeric types, integer indices in the built-in table are used for that instead. To support this, LLVM represents `externref` as a pointer in a reserved address space, while Clang at a higher level represents this as a built-in `__externref_t` type lowered to LLVM pointer type in the reserved address space.

We're looking for a prototype of an experimental feature in the Swift compiler that allows easier interoperability with C and C++ code that uses `__externref_t` values. As a stretch goal, Swift standard library should facilitate easier interop with host environments for [WebAssembly embedding](https://www.w3.org/TR/2025/CRD-wasm-core-2-20250616/#a1-embedding).

**기대 성과/이점/산출물**

- `WasmExternref` experimental feature that enables `WasmExternref` type in the Swift standard library;
- Lowering of operations on this type to [correct LLVM IR address space](https://discourse.llvm.org/t/rfc-webassembly-reference-types-in-clang/66939);
- Type checker semantics that corresponds to [existing `__externref_t` type in Clang](https://github.com/swiftlang/swift-for-wasm-examples/blob/main/DOMRefTypes/Sources/externref/bridge.c);
- (Stretch) Availability of Wasm `externref` table builtins in the Swift standard library for future use corresponding to `__builtin_wasm_table_*` available in Clang
- (Stretch) `WasmExternrefIndex` for wrapping `externref` table indices in types available in common Swift values address space.

**잠재적 멘토**

- [Max Desiatov](https://github.com/MaxDesiatov)

### WebAssembly Swift SDK with Support for Multi-threading

**프로젝트 규모**: 100-160 hours

**예상 난이도**: 중급

**권장 기술**

- Proficiency in Swift and WebAssembly;
- Basic understanding of Python and Swift compiler build system.

**설명**

Multi-threading support in WebAssembly requires building code against `wasm32-unknown-wasip1-threads` triple, which is already supported in WASI-libc dependency of the Swift standard library.

Swift toolchain `build-script` infrastructure written in Python needs minor updates that will build and package artifacts built for this triple in existing Swift SDK bundle that's distributed on swift.org.

As a stretch goal, we'd like this project to include a review of the existing test suite to ensure that the newly supported triple is well tested and supported by the core Swift libraries.

**기대 성과/이점/산출물**

- New Swift SDK with `wasm32-unknown-wasip1-threads` triple added to the existing Wasm Swift SDK bundle;
- Running Swift stdlib tests compiled for the new triple;
- (Stretch) CI setup for core Swift libraries building with the new Swift SDK.

**잠재적 멘토**

- [Max Desiatov](https://github.com/MaxDesiatov)

### DocC Language Features in SourceKit-LSP

**프로젝트 규모**: 200 hours

**예상 난이도**: 중급

**권장 기술**

- Basic proficiency in Swift.
- Basic proficiency in TypeScript.

**설명**

SourceKit-LSP has recently added DocC Live Preview support that can be used in editors such as VS Code. It allows users to view a real time side-by-side preview of their documentation directly in their editor.

Live preview could be further improved by providing language features such as go to definition as well as diagnostics for invalid/missing symbol names within DocC markdown and tutorial files. It would also be useful to have the links within the preview window take the user to the relevant symbol or documentation file within the code base.

**기대 성과/이점/산출물**

- Syntax highlighting for DocC markdown and tutorial files
- Go to definition for symbols that appear in DocC documentation
- Diagnostics that report missing/invalid symbol names in DocC documentation
- Clicking on links within live preview should take the user to the symbol

**잠재적 멘토**

- [Matthew Bastien](https://github.com/matthewbastien)
- [Prajwal Nadig](https://github.com/snprajwal)

### Support SPM Templates in VS Code

**프로젝트 규모:** 200 Hours

**예상 난이도:** 중급

**권장 기술**
* Basic proficiency using TypeScript
* Familiarity with VS Code Extensions
* Experience with frontend web development

**설명**

Add first-class support for the new Swift Package Manager (SwiftPM) template system in the official Swift VS Code extension. To increase adoption of the feature and provide an intuitive experience for users, the VS Code extension should be updated to interface with the template system without requiring the user to leave the VS Code experience by falling back to the command line.

For more details on how templates work in SPM, please review [the accepted proposal](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0500-package-manager-templates.md) on the Swift forums.

**기대 성과/이점/산출물**

* Add a GUI webview-based wizard that guides the user through creating a template provided by a package
* Drive template options by using the JSON output of the `--experimental-dump-help` SPM flag
* Showcase your work with a demo of the wizard and examples of how package authors and developers could use the system to improve workflows

**잠재적 멘토**

* [Will Paceley](https://github.com/willpaceley)
* [Matthew Bastien](https://github.com/matthewbastien)

### SwiftPM System Executables for Enhanced Plugin User Experience

**프로젝트 규모**: 200 hours

**예상 난이도**: 중급

**권장 기술**

- Basic proficiency in Swift
- Basic proficiency in SwiftPM packages

**설명**

SwiftPM is somewhat unique as a package manager because it supports marking dependencies on packages from foreign package managers, such as apt, yum, and homebrew. Today this is mainly used for libraries to be linked into SwiftPM products.

SwiftPM plugins can depend on executable tools, built from source, to help generate code and resources. If a tool cannot be built from source using SwiftPM then the plugin can invoke it using an absolute path. But, how will it know if the tool is present at that path? Also, how will the user be guided to install the package if it is missing?

The idea is to implement a system executable target, similar to system library targets where package names can be specified based on different package managers. Plugins can then depend on system executable targets so that warnings are emitted if the tool cannot be found on the path, along with the recommended remedy (e.g. "apt-get install foo") for any build errors. Since package manager may place tools in different locations based on the platform, there would be a SwiftPM plugin API for a plugin to specify the tool name and then it can discover the full path location. Add in some popular language-specific package manager support to gain access to many more tools (e.g. npm, and pip).

**기대 성과/이점/산출물**

- Complete SwiftPM proposal and working pull request


**잠재적 멘토**

- [Chris McGee](https://github.com/cmcgee1024)

### Sysroot Support in Swift's build-script

**프로젝트 규모**: 160 hours

**예상 난이도**: 중급

**권장 기술**

- Basic understanding of CMake, Python 
- Experience with the Swift compiler build system is a plus


**설명**

Extend Swift‘s `build-script` with an experimental flag which
provides the path to the sysroot of the target triple. This enables
[cross-compiling](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0387-cross-compilation-destinations.md)
to other sysroots, meaning the host triple is different to the target triple.
[Wasm](https://github.com/swiftlang/swift/blob/main/utils/swift_build_support/swift_build_support/products/wasmswiftsdk.py)
already uses a [sysroot](https://github.com/swiftlang/swift/blob/main/utils/swift_build_support/swift_build_support/products/wasmswiftsdk.py).
The approach is to generalize the mechanism by splitting out the Swift core library builds into separate build products to be used for cross-compiling.


**기대 성과/이점/산출물**
- New build products for cross-compiling Swift core libraries (reuse from Wasm).
- The new experimental flag from `build-script` is propagated to the new build products.
- Cross-compilation succeeds and tests run successfully on target system.
- Benefit is to be able to cross-compile to various Linux distros from one host system.
    It enables generation of Swift SDKs for cross-compilation.

**잠재적 멘토**

- [Max Desiatov](https://github.com/MaxDesiatov)


### Improved documentation for command line tools

**프로젝트 규모**: 175 hours (medium)

**예상 난이도**: 중급

**권장 기술**

- Basic proficiency in Swift.

**설명**

Swift Argument Parser has a [command plugin](https://github.com/apple/swift-argument-parser/pull/694) that generates documentation markup for a command line tool.
This plugin could be improved by providing support for generating separate pages for each command and by leveraging additional markdown syntax to organize command line flags into sections and display possible values and default values.

Beyond the markdown output, this plugin could be further improved by generating a ["symbol graph"](https://github.com/swiftlang/swift-docc-symbolkit/tree/main) that describe each command and its flags, options, and subcommands. By describing the commands' structure, tools like [Swift DocC](https://github.com/swiftlang/swift-docc/tree/main) can further customize the display of command line tool documentation, support links to individual flags, and allow developers to extend or override the documentation for individual flags in ways that isn't overwritten when regenerating the documentation markup from the plugin. If time allows, prototype some enhancement to command line documentation in Swift DocC that leverage the information from the command symbol graph file.

**기대 성과/이점/산출물**

- A richer markdown output from the plugin.
- Support for generating separate pages for each command.
- Output a supplementary symbol graph file that describe the commands' structure.

**잠재적 멘토**

- [David Rönnqvist](https://github.com/d-ronnqvist)


### Documentation coverage

**프로젝트 규모**: 90 hours (small)

**예상 난이도**: 중급

**권장 기술**

- Basic proficiency in Swift.

**설명**

Enhance Swift DocC's experimental documentation coverage feature to write coverage metrics in a new extensible file format that other tools can read and display. 
Define a few types of metrics—for example Boolean (has documentation: true/false), Fraction (2/3 parameters are documented), Integer (page has 2 code examples), Percentage, etc.—for this format. 

Explore ideas for what documentation coverage information would be useful to have and ideas for how another tool could present that information by prototyping a tool using your technology of choise.
Iterativelt refine the documentation coverage file format based on what you learn from consuming and displaying this data in your protype tool. 

**기대 성과/이점/산출물**

- Land the documentation coverage output format changes for the experimental feature in DocC.
- Submit a pitch to the community and the Documentation Workgroup to suggest formally enabling the updated documentation coverage feature in DocC.
- Summarize your effort with a demo of the new metrics and examples of how another tool could display that information.

**잠재적 멘토**

- [David Rönnqvist](https://github.com/d-ronnqvist)


### Globally Scoped Traits for Swift Testing via runtime configuration schema

**프로젝트 규모**: 80 hours
**예상 난이도**: 중급

**권장 기술**

* Basic proficiency in Swift.

**설명**

[Traits are a powerful tool](https://developer.apple.com/documentation/testing/traits) for customising test functions and suites. For example, you can specify timeout and retry on a test case or suite basis. It would be especially useful to apply a trait globally. For example, users may want to run all tests with a specific timeout in CI.

As an initial foray into globally scoped traits, implement a configuration to set global traits at runtime for Swift Testing.

**기대 성과/이점/산출물**

* Design and implement a schema for configuring globally-scoped traits.
* Consume the configuration at runtime via `swift test`
* Land the changes behind experimental flags, then submit a proposal to the community and the Testing Workgroup to formally enable the feature.
* Summarise your effort with a demo of the new functionality including screenshots or recordings.
* Time permitting, extend this project further by implementing globally configurable traits elsewhere:
    * With CLI parameters like `--retry-count` and `--test-timeout`
    * As part of the `.testTarget()` in `Package.swift~
    * As part of a new test plan file format
    * And of course, figuring how all these different places where traits are specified will interact with each other!

**잠재적 멘토**

- [Jerry Chen](https://github.com/jerryjrchen)

---


### Example project name

**프로젝트 규모**: N hours

**예상 난이도**: ???

**권장 기술**

- Basic proficiency in Swift.
- ...

**설명**

Description of the project goes here.

**기대 성과/이점/산출물**

- Expected deliverables of the project go here

**잠재적 멘토**

- Mentor name and link to their github

