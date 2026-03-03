---
redirect_from: '/source-code/'
layout: page
title: 소스 코드
---

Swift 프로젝트의 코드는 여러 오픈 소스 저장소로 나뉘어 있으며, 모두 [GitHub](https://github.com/apple/)에서 호스팅됩니다.

## 컴파일러와 표준 라이브러리

[swift](https://github.com/swiftlang/swift)
: Swift 컴파일러, 표준 라이브러리, SourceKit의 소스 코드가 포함된 메인 Swift 저장소입니다.

[swift-evolution](https://github.com/swiftlang/swift-evolution)
: 향후 릴리스 목표와 Swift 변경 및 확장 제안을 포함하여 Swift의 지속적인 발전에 관한 문서입니다.

Swift 컴파일러와 표준 라이브러리를 빌드하는 방법과 그 전제 조건은 [메인 Swift 저장소의 README 파일](https://github.com/swiftlang/swift/blob/main/README.md)에서 제공됩니다.

## 코어 라이브러리

[swift-corelibs-foundation](https://github.com/swiftlang/swift-corelibs-foundation)
: 모든 애플리케이션에 공통 기능을 제공하는 Foundation의 소스 코드입니다.

[swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch)
: 멀티코어 하드웨어에서 작업하기 위한 동시성 기본 요소를 제공하는 libdispatch의 소스 코드입니다.

[swift-corelibs-xctest](https://github.com/swiftlang/swift-corelibs-xctest)
: Swift 앱과 라이브러리를 위한 기본 테스트 인프라를 제공하는 XCTest의 소스 코드입니다.

## 패키지 관리자

[swift-package-manager](https://github.com/swiftlang/swift-package-manager)
: Swift 패키지 관리자의 소스 코드입니다.

[swift-llbuild](https://github.com/swiftlang/swift-llbuild)
: Swift 패키지 관리자가 사용하는 저수준 빌드 시스템인 llbuild의 소스 코드입니다.

[swift-tools-support-core](https://github.com/swiftlang/swift-tools-support-core)
: SwiftPM과 llbuild 모두를 위한 공통 인프라 코드를 포함합니다.

## Xcode Playground 지원

[swift-xcode-playground-support](https://github.com/apple/swift-xcode-playground-support)
: Xcode와의 Playground 통합을 가능하게 하는 소스 코드입니다.

## 소스 도구

[swift-syntax](https://github.com/swiftlang/swift-syntax)
: Swift 도구가 Swift 소스 코드를 파싱, 검사, 생성, 변환할 수 있게 하는 SwiftSyntax의 소스 코드입니다.

[swift-format](https://github.com/swiftlang/swift-format)
: Swift 소스 코드 포맷팅 기술의 소스 코드입니다.

## SourceKit-LSP 서비스

[sourcekit-lsp](https://github.com/swiftlang/sourcekit-lsp)
: SourceKit-LSP 언어 서비스의 소스 코드입니다.

[indexstore-db](https://github.com/swiftlang/indexstore-db)
: 인덱스 데이터베이스 라이브러리의 소스 코드입니다.

## Swift.org 웹사이트

[swift-org-website](https://github.com/swiftlang/swift-org-website)
: Swift.org 웹사이트의 소스 코드입니다.

## 클론된 저장소

Swift는 여러 다른 오픈 소스 프로젝트, 특히 [LLVM 컴파일러 인프라스트럭처](http://llvm.org)를 기반으로 빌드됩니다. 이러한 오픈 소스 프로젝트 저장소의 Swift 클론에는 Swift 전용 변경 사항이 포함되어 있으며, 업스트림 소스에서 정기적으로 머지됩니다.
LLVM 저장소 클론에 대한 자세한 정보는 [project-operations](https://github.com/swiftlang/project-operations/) 저장소의 [LLVM and Swift](https://github.com/swiftlang/project-operations/blob/main/llvm-and-swift.md)를 참고하세요.

[llvm-project](https://github.com/swiftlang/llvm-project)
: Swift 전용 추가 사항이 포함된 [LLVM](http://llvm.org)의 소스 코드입니다. [llvm.org의 LLVM 소스](https://github.com/llvm/llvm-project)에서 정기적으로 머지됩니다.

[swift-cmark](https://github.com/swiftlang/swift-cmark)
: Swift 컴파일러에서 사용되는 [CommonMark](https://github.com/jgm/cmark)의 소스 코드입니다.

Swift용 LLDB 빌드 방법은 [llvm-project/lldb 저장소의 README 파일][lldb-readme]에 있습니다.

---

[lldb-readme]: https://github.com/swiftlang/llvm-project/blob/next/lldb/README.md 'LLDB README'
