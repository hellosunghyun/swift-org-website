---
redirect_from:
  - '/swift-compiler/'
  - '/compiler-stdlib/'
layout: page
title: Swift 컴파일러
---

[메인 Swift 저장소][swift-repo]에는 Swift 컴파일러와 표준 라이브러리의 소스 코드뿐 아니라, SourceKit(IDE 통합용), Swift 회귀 테스트 스위트, 구현 수준 문서 등 관련 구성 요소도 포함되어 있습니다.

[Swift driver 저장소][swift-driver-repo]에는 Swift 컴파일러 "드라이버"의 새로운 구현이 포함되어 있으며, 기존 컴파일러 드라이버를 대체하기 위한 더 확장 가능하고, 유지보수가 쉽고, 견고한 드롭인 대체를 목표로 합니다.

{% include_relative _compiler-architecture.md %}

[bugtracker]: https://github.com/swiftlang/swift/issues
[swift-repo]: https://github.com/swiftlang/swift 'Swift 저장소'
[swift-driver-repo]: https://github.com/swiftlang/swift-driver 'Swift driver 저장소'
