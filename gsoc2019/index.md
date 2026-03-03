---
layout: page
title: GSoC 2019 프로젝트 아이디어
---

이 페이지는 다음 기간 동안 개발하고자 하는 프로젝트 아이디어 목록을 담고 있습니다: [GSoC 2019](https://summerofcode.withgoogle.com/). GSoC 학생으로 지원하고 싶다면 다음 두 단계를 따라 시작하세요:

1. 이 페이지를 읽고 관심 있는 프로젝트 아이디어를 찾아보세요.
2. [Development 포럼](https://forums.swift.org/c/development)에서 잠재적 멘토와 소통하세요.

## 프로젝트 목록

### Integration of libSyntax with the rest of the compiler pipeline.

**설명**

This project is for integrating the libSyntax tree and making use of it across the rest of the compiler pipeline (typechecker, diagnostics, etc.). It would involve:

* Derive the AST nodes from the libSyntax tree
* Having the parser generate only a libSyntax tree


**기대 성과/이점/산출물**

A robust architecture with a clean separation of the parsing functionality from the rest of the compiler pipeline, and enabling future work for integrating incremental re-parsing to the compiler pipeline.

**필요 기술**

* C++ (familiar)
* Compiler-pipeline Basics


**잠재적 멘토**

Rintaro Ishizaki

**예상 난이도**

중간/어려움


### Implement Code Formatting Functionality for SourceKit-LSP

**설명**

[SourceKit-LSP](https://github.com/swiftlang/sourcekit-lsp) is an implementation of the Language Server Protocol for Swift and C-based languages. The protocol defines range-based code-formatting functionality which is missing from SourceKit-LSP. The task is to add code-formatting using one of the available swift-syntax based code-formatters, like [swift-format](https://github.com/google/swift/tree/format), for Swift.

**기대 성과/이점/산출물**

* Enhancements to swift-format to provide an API for allowing range-based formatting, not just whole file.
* Implement code-formatting for SourceKit-LSP by integrating swift-format for Swift.
* Ensure SourceKit-LSP's code-formatting functionality works well when used from within Visual Studio Code.

**필요 기술**

* Swift (familiar)

**잠재적 멘토**

Harlan Haskins, Ben Langmuir

**예상 난이도**

쉬움/중간


### First-class support for authoring the Swift Standard Library via SourceKit-LSP

**설명**

[SourceKit-LSP](https://github.com/swiftlang/sourcekit-lsp) provides full-fledged language support for Swift and C-based languages, for editors that support the LSP protocol, like VSCode and SublimeText. It supports SwiftPM projects and clang's compilation database. The Swift Standard Library has a custom build process that prevents StdLib authors from utilizing SourceKit-LSP for their developement experience. The task is to make the necessary changes and allow SourceKit-LSP to provide first-class support for authoring the Swift Standard Library.

**기대 성과/이점/산출물**

* Enhance Swift StdLib's build process to emit a compilation database and index data
* Ensure indexing mechanism takes into account Swift's `#sourceLocation` to allow jump-to-definition functionality to just to StdLib's original `gyb` files.
* Ensure Swift Standard Library authoring functionality works well when used from within Visual Studio Code.

**필요 기술**

* Familiarity with Swift, C++

**잠재적 멘토**

Nathan Hawes

**예상 난이도**

쉬움/중간


### Swift debugging support on Linux

**설명**

LLDB is the debugger of choice for Swift. Debuggers depend more on the underlying platform than compilers, and as a consequence it's more challenging to maintain parity of implementation among operating systems. The meta-goal of the project is that of delivering the same debugging experience on Linux that we have on macOS.

**기대 성과/이점/산출물**

* Several tests are disabled on Linux (for historical reasons, or because the original author of the commit didn't have time to investigate), those should be audited and reenabled.
* We have Remote mirrors used for macOS, but it requires some work to be fully functional on Linux. That would help simplifying/make more robust a critical codepath and fully supporting resilience on Linux.
* Some data structures which are formatted differ between Linux and macOS. We could write formatters for them.
* Ubuntu is the only fully supported operating system right now. People have reported successes in running swift-lldb on other distributions, it would be nice if we could fix bugs due to difference in libraries, etc..

**필요 기술**

Knowledge of C++.
Knowledge of how debuggers work is a plus.
Knowledge of swift object memory layout is a plus, but can be gained during the bonding period.

**잠재적 멘토**

Davide Italiano

**예상 난이도**

쉬움/중간


### Scalability benchmarks for the Swift Standard Library

**설명**

The Swift Standard Library contains a large number of performance-critical algorithms. We need to be able to track their behavior and recognize significant changes to their overall performance, preferably before these changes land in the codebase.

The existing Swift Benchmarking Suite does a great job of measuring performance for particular working sets. However, we also need to track how algorithm performance scales as a function of the input size.

For example, a change that slightly improves insertion performance for 400-element dictionaries may turn out to significantly slow down 10-element or million-element dictionaries. In order to make an informed decision on whether to apply such a change, we need to be able to plot performance against input size as a curve; we can't just rely on a single numeric value.

The goal of this project is to augment the existing benchmark suite with scalability tests. The task is to design a Swift module for defining and running such benchmarks, and to provide an automated way of collecting, comparing and visualizing results. The system needs to be able to recognize if there are significant changes between two runs of the same benchmark, and it needs to render the results in a form that lets engineers analyze them at a glance -- such as the log-log plot below.

![Set.intersection plot](Set.intersect.png){:width="100%"}

**기대 성과/이점/산출물**

The ability for Swift contributors to define scalability benchmarks, and a PR testing trigger that runs them on CI servers, reporting results directly on the GitHub PR interface.

**필요 기술**

Familiarity with Swift

**잠재적 멘토**

Karoy Lorentey

**예상 난이도**

쉬움/중간

