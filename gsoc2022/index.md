---
layout: page
title: GSoC 2022 프로젝트 아이디어
---

이 페이지는 다음 기간 동안 개발하고자 하는 프로젝트 아이디어의 예시 목록을 담고 있습니다: [GSoC 2022](https://summerofcode.withgoogle.com/). GSoC 학생으로 지원하고 싶다면 다음 단계를 따라 시작하세요:

1. 이 페이지와 Google Summer of Code 가이드를 읽어보세요.
2. 관심 있는 프로젝트 아이디어를 찾거나 직접 구상하세요.
2. [Development 포럼](https://forums.swift.org/c/development)에서 잠재적 멘토와 소통하세요.
- 특정 프로젝트 참여에 관심이 있는 스레드를 시작할 때 포럼에서 프로젝트 멘토를 자유롭게 언급하세요.

올해 포럼에 GSoC에 대해 게시할 때는 [`gsoc-2022` tag](https://forums.swift.org/tag/gsoc-2022), so it is easy to identify.

## 멘토 연락 방법

Swift 포럼은 다양한 스팸 방지 메커니즘이 내장된 토론 포럼 플랫폼 Discourse로 운영됩니다. 포럼에 처음 가입하는 경우, "개인 메시지 보내기" 기능이 자동으로 활성화되기 전에 최소한의 사전 참여가 필요하므로 멘토에게 직접 메시지를 보내지 못할 _수_ 있습니다.

If you would like to reach out to a mentor privately, rather than making a public forums post, and the forums are not allowing you to send private messages (yet), please reach out to Konrad Malawski at `ktoso AT apple.com` directly via email with the `[gsoc2022]` tag in the email subject and describe the project you would like to work on – and we'll route you to the appropriate mentor.

## 프로젝트 목록

### SwiftSyntax

#### Use SwiftSyntax itself to generate SwiftSyntax’s source code

**프로젝트 규모**: Large (350 hours)

**권장 기술**:

- Basic proficiency with Swift
- Python knowledge is beneficial but not necessary

**예상 난이도**: Medium

**설명**:

[SwiftSyntax](http://github.com/swiftlang/swift-syntax) heavily relies on code-generation for its syntax node definitions. These files are currently being generated using gyb, a Python-based code generation tool developed as part of the Swift compiler. SwiftSyntax itself also has code generation capabilities, which have recently been significantly improved by the introduction of [SwiftSyntaxBuilder](https://github.com/swiftlang/swift-syntax/tree/main/Sources/SwiftSyntaxBuilder).

During the Google Summer of Code project, the student will migrate the current gyb-based code generation to use SwiftSyntaxBuilder, dogfooding SwiftSyntaxBuilder inside SwiftSyntax itself. To perform the migration, the student will also make further improvements to SwiftSyntaxBuilder, with the goal of transitioning SwiftSyntaxBuilder from its current development state to be production-ready.


**기대 성과/이점/산출물**:

Valuable real-world experience of using SwiftSyntaxBuilder and a production-ready Swift library to generate Swift code.

**잠재적 멘토**:

Alex Hoppen

### Swift on Linux and Server

#### Native Linux Swift installer packages (RPMs, Debs) for Swift

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift and scripting languages
- Proficient with RPMs, Debian packages and software packaging on Linux.

**예상 난이도**: Medium

**설명**:

Installing Swift toolchain on Linux today is done by downloading tarballs, and installing the required dependencies manually. Supporting native packages like RPMs and Debian packages would make using Swift on Linux dramatically easier.  Prototype versions of such packages exist, but there is further work that needs to be done to turn them into a high quality product that the Swift community could use in production use cases.

**기대 성과/이점/산출물**:

High quality RPMs and Debian packages that follow RPM and Debian best practices.

**잠재적 멘토**:

Tom Doron, Mishal Shah


#### Backtraces support for Swift on Linux

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with backtrace mechanisms in C++ or other languages
- Optionally, some familiarity with libraries like backtrace_symbols, libbacktrace, backward-cpp etc.
- Basic proficiency with C++ and Swift

**예상 난이도**: Medium / Hard

**설명**:

Today, Swift does not produce backtraces when a process crashes on Linux, which could hinder users ability to troubleshoot production issues. To address the need, the Swift server workgroup has created a library which relies on private APIs and is a stop gap solution. The goal of this project is to design and prototype a high quality solution that can be integrated into the Swift runtime.

**기대 성과/이점/산출물**:
Swift produces quality backtraces when a process crashes on Linux.

**잠재적 멘토**:

Tom Doron, or Dario Rexin

#### Kafka client package

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift
- Nice to have: Kafka experience
- Nice to have: experience with wrapping C APIs from Swift

**예상 난이도**: Medium

**설명**:

Kafka is a widely used distributed event streaming platform for high-performance data pipelines. Since the Swift on Server ecosystem is becoming more mature and with the recent introduction of Concurrency features in the language, we want to provide a Kafka client in Swift that allows to produce and consume messages. This client should vend native Swift APIs that leverage the new Concurrency features. Furthermore, the client should use librdkafka (https://github.com/edenhill/librdkafka) and wrap its C APIs.

**기대 성과/이점/산출물**:

Implementation of a native Swift package wrapping librdkafka that vends Swift APIs using Concurrency features.

**잠재적 멘토**:

Franz-Joseph Busch

### Swift Package Manager

#### Improve CLI User Experience

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift
- Experience with CLI based systems

**예상 난이도**: 쉬움

**설명**:

SwiftPM is used in two main ways: As a library integrated into Xcode and as a command line tool. The CLI user experience can be improved by adopting modern presentation techniques about concurrent processes such as build, tests and download progress. SwiftPM already has most of the required information available for presentation, and this work is focused on the design and implementation of a better UX/UI for this information.

**기대 성과/이점/산출물**:

Better user experience of using SwiftPM as a CLI tool.

**잠재적 멘토**:

Boris Beugling, Anders Bertelrund, Tom Doron


### Software Bill of Materials

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift
- Experience with dependency management systems

**예상 난이도**: Medium

**설명**:

Software Bill of Material (aka SBOM) is a technique for sharing dependency versions between different projects. This technique is useful for larger systems that span across multiple repositories, share same core dependencies, and need to align the versions of these core dependencies system wide.

See more:

* [https://en.wikipedia.org/wiki/Software_bill_of_materials](https://en.wikipedia.org/wiki/Software_bill_of_materials)
* [https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#bill-of-materials-bom-poms](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#bill-of-materials-bom-poms)

**기대 성과/이점/산출물**:

* Support BOM as new dependency type in SwiftPM, helping companies that build large systems with Swift.
* Produce BOM artifact from a resolved dependencies graph.


**잠재적 멘토**:

Boris Beugling, Anders Bertelrund, Tom Doron


#### Package creation command and templates support for SwiftPM

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift

**예상 난이도**: 쉬움

**설명**: SwiftPM includes a simple system for creating new packages, which is good for trivial use cases, but not flexible enough for more sophisticated development scenarios. To extend this feature, we can adopt a template driven system, potentially based on SwiftPM's plugin system.

See more:

* [https://forums.swift.org/t/pitch-new-command-for-package-creation-and-package-templates](https://forums.swift.org/t/pitch-new-command-for-package-creation-and-package-templates/47874)

**기대 성과/이점/산출물**:

Users can define their own templates or plugins for deciding how the package creation sub-system works.

**잠재적 멘토**:

Boris Beugling, Anders Bertelrund, Tom Doron

### Swift-DocC

Swift-DocC is the documentation compiler for Swift, read more about it here: [Swift-DocC is Now Open Source](/blog/swift-docc/).

#### Swift-DocC support for diffing documentation archives

**프로젝트 규모**: Large (350 hours)

**권장 기술**:

- Basic proficiency with Swift
- Familiarity with Swift-DocC and developer tooling.

**예상 난이도**: Medium

**설명**:

Currently, DocC supports publishing documentation for a single version of a framework. However, as frameworks evolve, their APIs and documentation content do as well. To help framework authors and users better keep track of changes in a framework, this project explores new functionality to produce diff data that can be used by DocC’s web renderer to present API changes and documentation changes UI. The participant will take part in collaborative technical design and Swift-DocC compiler development.

**기대 성과/이점/산출물**:

Technical design and implementation for emitting diff data when compiling documentation.


**잠재적 멘토**:

Franklin Schrans


#### Quick navigation in DocC Render

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Proficient with web technologies such as JavaScript and CSS
- Basic familiarity with Swift-DocC and developer tooling

**예상 난이도**: Medium


**설명**:

The new Swift-DocC sidebar provides an easy to get a bird’s-eye of a framework’s documentation content, this project explores adding a quick navigation UI to jump to a symbol using keyboard shortcuts, similar to how IDEs support jumping to symbols. The participant will take part in collaborative UI/UX design and Swift-DocC Render web development.

**기대 성과/이점/산출물**:

UX design, technical design, and implementation for a quick navigation UI in documentation websites.

**잠재적 멘토**:

Marina Aisa, Beatriz Magalhaes


### Swift Standard Library / Packages

#### Swift ArgumentParser: Interactive mode

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift
- An interest in command line tools

**예상 난이도**: Medium

**설명**:

ArgumentParser provides a straightforward way to declare command-line interfaces in Swift, with the dual goals of making it (1) fast and easy to create (2) high-quality, user-friendly CLI tools. For this project, we would design and implement an interactive mode for tools built using ArgumentParser that prompts for any required arguments not given in the initial command. This work would need to allow partial initialization of types, and could include features like validation and auto-completion for user input.

**기대 성과/이점/산출물**:
Design, implementation, and tests of an interactive CLI.


**잠재적 멘토**:

Nate Cook

### Swift

#### Improving Debug Output Of The Type Inference Algorithm

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with C++

**예상 난이도**: Medium


**설명**:

Swift’s type inference algorithm, implemented by the constraint solver, supports printing of debug information while type-checking an expression. This data in intended to help compiler developers to understand how/when/what types have been inferred, what restrictions have been applied, and what overload choices have been used in each attempt to reach a solution. Unfortunately, for a complex expression, the constraint solver would produce a lot of output which makes it very hard or sometimes impossible to work with, even for experienced compiler developers, because there were too many choices that the solver had to make and a lot of irrelevant information provided for each one of them.

The goal of this project is to make the output of the constraint solver human friendly by including only the important information for understanding the source of each inferred type and errors that were encountered, and changing the format and presentation of the output in general and for each of its components.

**기대 성과/이점/산출물**:

The new and improved debug output of the constraint solver which is much easier to work with for both experienced compiler developers and newcomers to the project.

**잠재적 멘토**:

Pavel Yaskevich


### Swift and C++ Interoperability

Swift and C++ interoperability is an ongoing open-source project that aims to make Swift APIs convenient to use from C++ (and vice versa). It's spearheaded
by the [Swift and C++ interoperability workgroup](https://forums.swift.org/c/development/c-interoperability/82).

#### Bridging Swift Error Handling Model to C++

**프로젝트 규모**: Large (350 hours)

**권장 기술**:

- Basic proficiency with Swift
- Basic proficiency with C++ (advanced knowledge of C++ is not required)

**예상 난이도**: Medium

**설명**:

This project builds upon the ongoing open-source effort for exposing Swift APIs to C++, by adding support for exposing functions that `throw` Swift errors to C++, and by providing C++ classes that let users handle Swift `Error` values from C++.

This project has two primary aspects. At first, the participant will need to extend the C++ interface generator for a Swift module to emit C++ interfaces for Swift
functions that `throw`, and a C++ class that represents Swift's `Error` type. Then, the participant will need to implement a C++ exception class that wraps around
the `Error` type, and a C++ class that resembles the proposed [std::expected class](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/p0323r4.html), to provide error handling for clients that don't use C++ exceptions. The participant will need to write test cases to verify the implementation. The participant will also need to interact with the Swift open-source community when working on the implementation.


**기대 성과/이점/산출물**:

- The participant will learn more about Swift's error handling model, C++ error handling model, and working with an open-source compiler codebase.
- Enable C++ users to call Swift functions that can throw. Enable C++ users to examine error values produced by Swift.


**잠재적 멘토**:

Alex Lorenz


#### Bridging Swift Enums With Associated Values to C++

**프로젝트 규모**: Medium (175 hours)

**권장 기술**:

- Basic proficiency with Swift
- Basic proficiency with C++ (advanced knowledge of C++ is not required)

**예상 난이도**: Medium

**설명**:

This project builds upon the ongoing open-source effort for exposing Swift APIs to C++, by adding support for exposing enumerations with associated values to C++. These enumerations are [documented in the Swift language guide](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html#ID148).

The participant will need to extend the C++ interface generator for a Swift module to emit a C++ class that represents Swift enumerations with associated types. The generator will also need to be extended to emit the C++ member functions that allow the following operations in C++:

- switch over the enumeration cases
- check if the enum is of a specific case
- extract the payload of the associated value of the case

The participant will need to write test cases to verify the implementation. The participant will also need to interact with the Swift open-source community when working on the implementation.


**기대 성과/이점/산출물**:

- The participant will learn more about Swift's enums with associated types, and working with an open-source compiler codebase.
- Enable C++ users to create and examine Swift enumerations with associated values.
- Enable C++ users to pass Swift enumerations with associated values to C++, and vice versa.

**잠재적 멘토**:

Alex Lorenz

#### Providing Swift overlays for C++ standard library types

**프로젝트 규모**: Medium (175 hours)

**필요 기술**:

- Basic proficiency with Swift
- Basic proficiency with C++ (advanced knowledge of C++ is not required)

**예상 난이도**: Medium

**설명**:

Swift and C++ interoperability is an ongoing open-source initiative
that aims to make C++ APIs convenient to use from Swift (and vice versa). It's spearheaded
by the Swift and C++ interoperability workgroup (https://forums.swift.org/g/cxx-interop-workgroup, https://forums.swift.org/c/development/c-interoperability/82).
This project builds upon the ongoing effort for exposing C++ APIs to Swift,
by providing some Swift overlays for the C++ standard library types, like std::string
and std::vector.

The participant will need to write Swift code to provide conformances to standard Swift protocols such as Collection for several C++ standard library types, like the following ones:

- `std::string`
- `std::vector`
- `std::map`
- `std::set`

These conformances should be built as a separate overlay module, similar to the Darwin overlay and made available in Swift toolchains. The participant will need to modify the CMake build scripts to enable building and packaging the overlay module.
The participant will need to write test cases to verify the implementation and also need to interact with the Swift open-source community to obtain and respond to code reviews while working on the implementation.

**기대 성과/이점/산출물**:

The participant will learn more about Swift's type system, the Swift standard library protocols, and the C++ standard library types like `std::string` and `std::vector`. The participant will also learn more about  working with an open-source compiler codebase.

Successful implementation of this project would enable Swift users to use certain C++ standard library types such as std::vector with APIs vended by the Swift standard library. E.g., this would enable iterating over a `std::vector` with a Swift for-in loop or invoking a compactMap method on it.

**잠재적 멘토**:
Egor Zhdan and Alex Lorenz

