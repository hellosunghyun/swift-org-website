---
layout: new-layouts/post
published: true
date: 2015-12-03 12:01:01
title: Swift 3 API 디자인 가이드라인
category: "Language"
---

널리 사용되는 라이브러리의 설계는 프로그래밍 언어의 전반적인 느낌에 큰 영향을 미칩니다. 훌륭한 라이브러리는 언어 자체의 확장처럼 느껴지며, 라이브러리 간의 일관성은 전반적인 개발 경험을 향상시킵니다. 훌륭한 Swift 라이브러리 구축을 돕기 위해 [Swift 3의 주요 목표][swift-3-goals] 중 하나는 API 디자인 가이드라인을 정의하고 이를 일관되게 적용하는 것입니다.

Swift API 디자인 가이드라인을 정의하는 작업에는 Swift 개발에 더 통일된 느낌을 제공하기 위한 여러 주요 요소가 포함됩니다:

* **Swift API 디자인 가이드라인**: 실제 API 디자인 가이드라인이 활발히 개발 중입니다. 최신 [Swift API 디자인 가이드라인][swift-api-guidelines] 초안을 확인할 수 있습니다.

* **Swift 표준 라이브러리**: Swift 표준 라이브러리 전체가 Swift API 디자인 가이드라인에 맞게 검토·업데이트되고 있습니다. 실제 작업은 Swift 저장소의 [swift-3-api-guidelines 브랜치][swift-stdlib-update]에서 진행됩니다.

* **임포트된 Objective-C API**: Objective-C API의 Swift 변환이 Swift API 디자인 가이드라인에 더 잘 맞도록 다양한 휴리스틱을 사용해 업데이트되고 있습니다. [Objective-C API의 Swift 변환 개선][clang-importer-proposal] 제안서에 이 변환 방식이 설명되어 있습니다. 이 접근 방식에는 여러 휴리스틱이 포함되므로 Cocoa 및 Cocoa Touch 프레임워크와 이를 사용하는 Swift 코드에 미치는 영향을 추적합니다. [Swift 3 API 디자인 가이드라인 리뷰][swift-3-api-guidelines-repo] 저장소에서 이 자동 변환이 Cocoa와 Cocoa Touch를 사용하는 Swift 코드에 어떤 영향을 미치는지 확인할 수 있습니다. Swift로 변환이 잘 되지 않는 특정 Objective-C API는 결과 Swift 코드를 개선하기 위해 어노테이션(예: `NS_SWIFT_NAME`)이 추가됩니다. 이 변경은 주로 Apple 플랫폼(Swift가 Objective-C 런타임을 사용하는 곳)에 영향을 미치지만, Objective-C 프레임워크와 동일한 API를 제공하는 크로스 플랫폼 [Swift Core Libraries][core-libraries]에도 직접적인 영향을 줍니다.

* **Swift 가이드라인 검사**: 기존 Swift 코드는 [Objective-C Cocoa 코딩 가이드라인][objc-cocoa-guidelines] 등 다양한 코딩 스타일을 따라 작성되었습니다. Objective-C API 임포트에 사용되는 휴리스틱을 활용하여, Swift 컴파일러는 (선택적으로!) Swift API 디자인 가이드라인에 맞지 않는 일반적인 API 디자인 패턴을 검사하고 개선을 제안할 수 있습니다.

* **Swift 2에서 Swift 3 마이그레이터**: Swift 표준 라이브러리와 임포트된 Objective-C API의 업데이트는 소스 호환성을 깨는 변경입니다. 이를 위해 Swift 2 코드를 Swift 3 API에 맞게 업데이트하는 마이그레이터가 제작됩니다.

이 모든 주요 작업이 활발히 진행 중입니다. 관심이 있으시다면 [Swift API 디자인 가이드라인][swift-api-guidelines], [Swift 표준 라이브러리 변경 사항][swift-stdlib-update], [Objective-C API 임포터 변경][clang-importer-proposal] 제안서와 해당 [리뷰 저장소][swift-3-api-guidelines-repo]를 확인한 후, [swift-evolution 메일링 리스트](/community/#swift-evolution)에서 토론에 참여해 주세요.

[swift-3-goals]: https://github.com/swiftlang/swift-evolution/blob/master/README.md  "Swift 3 goals"
[swift-api-guidelines]: /documentation/api-design-guidelines/  "Swift API Design Guidelines"
[swift-stdlib-update]: https://github.com/apple/swift/tree/swift-3-api-guidelines  "Swift 3 Standard Library updates"
[clang-importer-proposal]: https://github.com/swiftlang/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md  "Better Translation of Objective-C APIs into Swift proposal"
[swift-3-api-guidelines-repo]: https://github.com/apple/swift-3-api-guidelines-review  "Swift 3 API Design Guidelines review repository"
[objc-cocoa-guidelines]: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html  "Objective-C Coding Guidelines for Cocoa"
[swift-evolution]: /contributing/#evolution-process  "Swift evolution process"
[core-libraries]: /documentation/core-libraries  "Swift core libraries"
