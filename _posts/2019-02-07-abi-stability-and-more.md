---
layout: new-layouts/post
date: 2019-02-07 10:00:00
title: ABI 안정성과 그 이상
author: jrose
category: "Language"
---

It has been a longstanding goal to stabilize Swift’s ABI on macOS, iOS, watchOS, and tvOS.  While a stable ABI is an important milestone for the maturity of any language, the ultimate benefit to the Swift ecosystem was to enable binary compatibility for apps and libraries.  This post describes what binary compatibility means in Swift 5 and how it will evolve in future releases of Swift.

다른 플랫폼은 어떨까요? ABI 안정성은 컴파일하고 실행하는 각 운영 체제에 대해 구현됩니다. Swift의 ABI는 현재 Apple 플랫폼에서 Swift 5에 대해 안정적으로 선언되어 있습니다. Linux, Windows 및 기타 플랫폼에서의 Swift 개발이 성숙해지면, Swift Core Team은 해당 플랫폼에서의 ABI 안정화를 평가할 것입니다.

Swift 5는 앱에 대한 바이너리 호환성을 제공합니다: 앞으로 한 버전의 Swift 컴파일러로 빌드된 앱이 다른 버전으로 빌드된 라이브러리와 통신할 수 있다는 보장입니다. 이는 이전 언어 버전과의 호환 모드(`-swift-version 4.2`)를 사용할 때에도 적용됩니다.

![Take an app built with Swift 5, using a compiler that supports ABI stability.]({{ site.baseurl }}/assets/images/abi-stability-blog/abi-stability.png)

이 예제에서, Swift 5.0으로 빌드된 앱은 Swift 5 표준 라이브러리가 설치된 시스템뿐만 아니라 가상의 Swift 5.1이나 Swift 6이 있는 시스템에서도 실행됩니다.

_(이 글에서 Swift 5.0 이후의 모든 버전 번호는 물론 가상입니다)_

ABI stability for Apple OSes means that apps deploying to upcoming releases of those OSes will no longer need to embed the Swift standard library and “overlay” libraries within the app bundle, shrinking their download size; the Swift runtime and standard library will be shipped with the OS, like the Objective-C runtime.

App Store에 제출되는 앱에 미치는 영향에 대한 자세한 내용은 [Xcode 10.2 릴리스 노트][relnote]에서 확인할 수 있습니다.


[relnote]: https://developer.apple.com/documentation/xcode_release_notes/xcode_10_2_beta_release_notes/swift_5_release_notes_for_xcode_10_2_beta


## 모듈 안정성

ABI 안정성은 *런타임*에서 Swift 버전을 혼합하는 것에 관한 것입니다. 컴파일 타임은 어떨까요? 현재 Swift는 수동으로 작성한 헤더 파일 대신 "swiftmodule"이라는 불투명 아카이브 형식을 사용하여 "MagicKit" 같은 프레임워크의 인터페이스를 기술합니다. 하지만 "swiftmodule" 형식도 현재 컴파일러 버전에 묶여 있어서, MagicKit이 다른 버전의 Swift로 빌드된 경우 앱 개발자가 `import MagicKit`을 할 수 없습니다. 즉, 앱 개발자와 라이브러리 작성자가 같은 버전의 컴파일러를 사용해야 합니다.

이 제한을 없애기 위해, 라이브러리 작성자에게는 현재 구현 중인 *모듈 안정성*이라는 기능이 필요합니다. 이는 Xcode의 "Generated Interface" 뷰에서 볼 수 있는 것과 유사한 모듈의 텍스트 요약으로 불투명 형식을 보강하여, 클라이언트가 모듈이 어떤 컴파일러로 빌드되었는지 신경 쓰지 않고 사용할 수 있게 합니다. 자세한 내용은 [Swift 포럼][module stability]에서 읽을 수 있습니다.

![Let's say support for module stability ships with Swift 6.]({{ site.baseurl }}/assets/images/abi-stability-blog/module-stability.png)

예를 들어, Swift 6을 사용하여 프레임워크를 빌드할 수 있고, 그 프레임워크의 인터페이스는 Swift 6과 미래의 Swift 7 컴파일러 모두에서 읽을 수 있습니다.

_다시 말하지만, 여기의 모든 Swift 버전 번호는 가상입니다._

[module stability]: https://forums.swift.org/t/plan-for-module-stability/14551

## 라이브러리 에볼루션

지금까지는 컴파일러를 변경하되 Swift 코드는 동일하게 유지하는 것에 대해 이야기했습니다. 앱이 사용하는 라이브러리의 변경은 어떨까요? 현재 Swift 라이브러리가 변경되면, 해당 라이브러리를 사용하는 모든 앱을 다시 컴파일해야 합니다. 이는 장점이 있습니다: 컴파일러가 앱이 사용하는 라이브러리의 정확한 버전을 알기 때문에 코드 크기를 줄이고 앱을 더 빠르게 실행하는 추가 가정을 할 수 있습니다. 하지만 그러한 가정은 라이브러리의 다음 버전에서는 유효하지 않을 수 있습니다.

이 기능이 *라이브러리 에볼루션 지원*입니다: 클라이언트를 다시 컴파일하지 *않고도* 라이브러리의 새 버전을 배포하는 것입니다. 이는 Apple이 OS의 라이브러리를 업데이트할 때 발생하지만, 한 회사의 바이너리 프레임워크가 다른 회사의 바이너리 프레임워크에 의존할 때도 중요합니다. 이 경우 두 번째 프레임워크를 업데이트할 때 이상적으로 첫 번째 프레임워크를 다시 컴파일할 필요가 없어야 합니다.

![When an app is built, it has an expectation of what APIs are available based on the compile-time interfaces of the framework it's using. Resilience allows the framework to change without disrupting that interface, allowing the app to run using different versions of the framework.]({{ site.baseurl }}/assets/images/abi-stability-blog/library-evolution.png)

이 예제에서 앱은 노란색으로 표시된 프레임워크의 원래 버전에 대해 빌드됩니다. 라이브러리 에볼루션 지원을 통해, 노란색 버전이 있는 시스템뿐만 아니라 더 새롭고 개선된 빨간색 버전이 있는 시스템에서도 실행됩니다.

Swift에는 이미 비공식적으로 "레질리언스"라고 불리는 라이브러리 에볼루션 지원 구현이 있습니다. 이것이 필요한 라이브러리를 위한 옵트인 기능이며, 성능과 미래 유연성 사이의 균형을 맞추기 위해 아직 확정되지 않은 어노테이션을 사용합니다. 이는 표준 라이브러리의 소스 코드에서 볼 수 있습니다. Swift Evolution 프로세스를 거친 첫 번째 항목은 Swift 4.2에서 추가된 `@inlinable`이었습니다([SE-0193](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0193-cross-module-inlining-and-specialization.md)). 향후 라이브러리 에볼루션 지원에 대한 더 많은 제안이 있을 것입니다.

[fragile base class problem]: https://en.wikipedia.org/wiki/Fragile_base_class


## 요약

{% comment %}
This table has non-breaking spaces in it to prevent the first and last columns from being overly compressed by the site CSS.
{% endcomment %}

| When Swift has... | ...then you can change... | Status |
|--:|:-:|:--|
| ABI&nbsp;Stability | the Swift<br/>standard library | Swift 5 on macOS, iOS, watchOS, and tvOS |
| Module&nbsp;Stability<br/>_(and&nbsp;ABI&nbsp;stability)_ | compilers | Under&nbsp;active&nbsp;development |
| Library Evolution Support | your library's APIs | Largely implemented but needs to go through the Swift Evolution Process |

# 질문이 있으신가요?

이 글에 대한 질문은 [Swift 포럼][]의 [관련 스레드](https://forums.swift.org/t/swift-org-blog-abi-stability-and-more/20250)에 남겨 주세요.

[Swift forums]: https://forums.swift.org
