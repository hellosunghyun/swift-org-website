---
layout: page
title: GSoC 2021 프로젝트 아이디어
---

이 페이지는 다음 기간 동안 개발하고자 하는 프로젝트 아이디어의 예시 목록을 담고 있습니다: [GSoC 2021](https://summerofcode.withgoogle.com/). GSoC 학생으로 지원하고 싶다면 다음 단계를 따라 시작하세요:

1. 이 페이지와 Google Summer of Code 가이드를 읽어보세요.
2. 관심 있는 프로젝트 아이디어를 찾거나 직접 구상하세요.
2. [Development 포럼](https://forums.swift.org/c/development)에서 잠재적 멘토와 소통하세요.
    - 특정 프로젝트 참여에 관심이 있는 스레드를 시작할 때 포럼에서 프로젝트 멘토를 자유롭게 언급하세요.

올해 포럼에 GSoC에 대해 게시할 때는 [`gsoc-2021` tag](https://forums.swift.org/tag/gsoc-2021), so it is easy to identify.

## 멘토 연락 방법

Swift 포럼은 다양한 스팸 방지 메커니즘이 내장된 토론 포럼 플랫폼 Discourse로 운영됩니다. 포럼에 처음 가입하는 경우, "개인 메시지 보내기" 기능이 자동으로 활성화되기 전에 최소한의 사전 참여가 필요하므로 멘토에게 직접 메시지를 보내지 못할 _수_ 있습니다.

If you would like to reach out to a mentor privately, rather than making a public forums post, and the forums are not allowing you to send private messages (yet), please reach out to Konrad Malawski at `ktoso @ apple.com` directly via email with the `[gsoc2021]` tag in the email subject and describe the project you would like to work on – and we'll route you to the appropriate mentor.

## 프로젝트 목록

### Tracking for typechecker’s type inference

**설명**

Swift uses compile-time type inference to achieve clear and concise syntax. Sometimes, it’s not obvious to the programmer why Swift inferred a particular type in their source code. A tool to explore the source of type inference would clear up confusion when the type checker inferred a type that the programmer did not expect, and it would greatly enhance their understanding of the language.

See also:

- [GSoC 2020 page](/gsoc2020/#tracking-for-typecheckers-type-inference), minus the interactive command line tool part due to shorter coding period)

**기대 성과/이점/산출물**

- Gain insight into how Swift’s constraint system for type inference works.
- Implement tracking of constraints that caused the solver to infer a type, along with a compiler flag for writing the solution with detailed type inference sources to a file.

**필요 기술**

Familiarity with the concept of static type checking.

**잠재적 멘토**

Holly Borla, Pavel Yaskevich

### Referencing enclosing self in a property wrapper type
**설명**

Property wrappers are a powerful feature in Swift for abstracting common property patterns into libraries. One of these common patterns involves manually-written property accessors that refer to the self instance of the enclosing type of that property. Swift has an experimental design and implementation of a feature that allows this pattern to be abstracted into a property wrapper. However, the design and implementation need to be evolved before Swift officially supports this feature. This project will help you develop skills in collaborative language design, technical writing, and compiler development!

See also:

- Future directions section of the Property Wrappers Swift Evolution proposal: [Referencing the enclosing 'self' in a wrapper type](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0258-property-wrappers.md#referencing-the-enclosing-self-in-a-wrapper-type)

**필요 기술**
Proficient with Swift. Familiarity with property wrappers is a plus!

**예상 난이도**

Though this isn’t a simple feature, I think this might be a good GSoC project because it’s a highly requested feature that’s unlikely to be rejected in Swift Evolution, there’s an experimental implementation in place to help point the student toward the parts of the code that will need to change, and there are some better design ideas floating around so the student won’t need to start from scratch. A language feature is also a good way to attract folks enthusiastic about the Swift language who aren’t as confident in/don’t have much experience with compiler development.

**잠재적 멘토**

Holly Borla

### Transparent logs system for protecting the Swift package ecosystem

**설명**

[Transparent logs](https://research.swtch.com/tlog) are a novel approach to supply-chain security, adopted by Certificate Transparency and the [trillian](https://github.com/google/trillian) projects. In this project we will explore applying such principals to protect the Swift package ecosystem from supply-chain attacks. Participants will participate in collaborative design, technical writing, and server-side development.

**필요 기술**

Proficient with Swift or similar C based languages. Familiarity with Merkel trees, certificate transparency and supply-chain security is a plus.

**잠재적 멘토**

Yim Lee, Tom Doron

### Scripting in Swift

**설명**

Swift is a fun and powerful language, and folks often want to use it also for their scripting needs. While writing simple scripts in Swift is possible today, it is not possible to use Swift packages in such scripts, which takes away from the full robustness of the language. In this project we will define a user friendly syntax for expressing package dependencies in a script, a methodology to resolve such dependencies, and integrate the resolution into the Swift command line tools and REPL. Participants will participate in collaborative design, technical writing, and software development.

See also:

- The [SwiftPM support for Swift scripts](https://forums.swift.org/t/swiftpm-support-for-swift-scripts/33126) thread has an initial design that could be used as the basis of this work. It may need some polish, figuring out the details the project cound aim for implementing a basic version of it.

**필요 기술**

Proficient with Swift and SwiftPM. Familiarity with scripting languages is a plus.

**잠재적 멘토**

Boris Beugling, Anders Bertelrud, Tom Doron

### Increase differentiable programming’s language coverage

**설명**

Differentiable programming is an experimental language feature that allows developers to create differentiable closures, define differentiable protocol requirements, and take the derivative of functions. Today, there is a number of common language features unsupported by differentiable programming. To increase differentiable programming’s coverage of these language features, the student will design and implement differentiation features such as default implementations of differentiable protocol requirements, key path expressions as differentiable functions, differentiable throwing functions, enum differentiation, etc.

**필요 기술**

Familiarity with basic differential calculus and compiler frontends.

**잠재적 멘토**

Richard Wei

### Swift Numerics: Decimal64

Add Decimal64 to the Swift Numerics package (with a stretch goal of also adding Decimal128). These types will bind the IEEE 754 decimal floating-point types (https://en.wikipedia.org/wiki/Decimal_floating_point). Depending on the mentee’s interests, we could pursue targeted micro-optimizations for arithmetic on specific architectures, develop test vectors for this and other decimal libraries, or begin work on transcendental functions for these types.

**필요 기술**
Interest in numerical computing, familiarity with Swift or C.

**잠재적 멘토**
Steve (Numerics) Canon

### Swift ArgumentParser: Interactive mode

ArgumentParser provides a straightforward way to declare command-line interfaces in Swift, with the dual goals of making it (1) fast and easy to create (2) high-quality, user-friendly CLI tools. For this project, we would design and implement an interactive mode for tools built using ArgumentParser that prompts for any required arguments not given in the initial command. This work would need to allow partial initialization of types, and could include features like validation and auto-completion for user input.

**필요 기술**

Proficient with Swift and interest in command line tools.

**잠재적 멘토**

Nate Cook

### Swift data structure implementation (priority queue, weak set/dictionary, or other useful data structure)

The Swift Standard Library currently implements just three general-purpose data structures: Array, Set and Dictionary. While these cover a huge amount of use cases, and they are particularly well-suited for use as currency types, they aren't universally the most appropriate choice -- in order to efficiently solve problems, Swift programmers need access to a larger library of data structures.

In this project, the student will create a production-quality Swift implementation for a general-purpose data structure, for use in even the most demanding applications. This is not an easy task — implementing a general-purpose collection type requires the student to gain in-depth experience in the following areas and more:

* API design (learning about subtle aspects of the Collection protocol hierarchy, getting deeply familiar with Swift naming conventions, achieving as much as possible with as little API surface as possible, discouraging common mistakes through API design, designing for future changes)
* Low-level Swift implementation concepts & techniques (unsafe memory management, ManagedBuffer, _modify accessors, @inlinable and similar attributes)
* Testing (writing maintainable tests that cover every edge case of every method, and verify semantic requirements of protocol conformances)
* Performance (writing and analyzing benchmarks, solving performance issues, understanding and verifying(!) performance guarantees such as O(1) or O(log(n)) complexity)
* Documentation (including documenting preconditions, performance guarantees and common gotchas, if any)

A successful project will deliver an open source data structure implementation as a Swift package, with an eye towards eventual inclusion in the Swift Standard Library. The data structure is chosen through negotiations between the student and the mentor — we’d like to set up the student for success by making sure the problem can be meaningfully tackled in the time available.

**필요 기술**

Proficiency with Swift, interest in data structures.

**잠재적 멘토**

Karoy Lorentey

### Tooling for swiftmodule Files
Today, the .swiftmodule format is fairly opaque, and the best insight our tooling can provide is a complete dump of the entire module with llvm-bc-analyzer. Providing a native tool that allows for exploring the contents of a Swift module would be an incredible debugging aid and teaching tool. It would also expose the student to a very central component of the Swift compiler.

**필요 기술**

Cursory knowledge of C++, familiarity with Swift

**잠재적 멘토**

Robert Widmann


### Show Swift inferred types in VSCode using SourceKit-LSP
Some IDEs have capability to show inferred types inline within the source code. Recently, similar support has been added for Rust inside VSCode by [rust-analyser](https://github.com/rust-analyzer/rust-analyzer). We would like to offer similar functionality also for Swift. In the project, the student will extend SourceKit-LSP to offer functionality as described in [this LSP proposal](https://github.com/microsoft/language-server-protocol/issues/956). Furthermore, they will extend the [SourceKit-LSP VSCode plugin](https://github.com/swiftlang/sourcekit-lsp/tree/main/Editors/vscode) to show the type hints in the editor. The changes to the editor can follow the same approach as the [rust-analyzer implementation](https://github.com/rust-analyzer/rust-analyzer/blob/master/editors/code/src/inlay_hints.ts).

**필요 기술**

Knowledge of the Swift language; interest in developer tools

**잠재적 멘토**

Alex Hoppen

### Alive2 for SIL

[Alive2](https://github.com/AliveToolkit/alive2) is a tool that enables the verification of the correctness of LLVM optimization passes. The tool uses the Z3 constraint solver to produce counterexamples for unsound optimizer passes. While the implementation is bound to LLVM IR, the principles behind Alive2 apply equally to SIL. The candidate would produce a tool that parses SIL and integrates SIL’s semantics into a set of constraints to submit to Z3 to verify the soundness of SIL optimization passes. This can be accomplished in a number of ways, including a pure Swift tool or a C++ tool that integrates directly with the Swift compiler libraries. The tool does not need to be complete - merely being able to verify even a subset of SIL would be a huge benefit.

**필요 기술**

Knowledge of Swift, Cursory knowledge of [SIL](https://github.com/swiftlang/swift/blob/main/docs/SIL.rst)

**잠재적 멘토**

Robert Widmann




### More ideas

We are still collecting ideas from various teams inside and outside Apple.

If you have an idea of your own, you can propose it on the [Development forum](https://forums.swift.org/c/development) and connect with potential mentors.

Projects must have a tangible result, and be possible to successfully complete by a student within the allocated ~175 hours for the project.
New project ideas will need to find a mentor to endorse the project in order to be accepted.

올해 포럼에 GSoC에 대해 게시할 때는 [`gsoc-2021` tag](https://forums.swift.org/tag/gsoc-2021), so it is easy to identify.
