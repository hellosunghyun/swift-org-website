---
layout: new-layouts/post
published: true
date: 2015-12-03 11:01:01
title: Swift Linux 포팅
category: 'Developer Tools'
---

오픈 소스 Swift 프로젝트 출시와 함께 Linux 운영 체제에서 동작하는 포팅 버전도 함께 공개합니다! Swift 소스에서 직접 빌드하거나 [Ubuntu용 사전 빌드 바이너리를 다운로드]할 수 있습니다. 포팅 작업은 아직 진행 중이지만, 현재도 실험적 용도로 충분히 사용할 수 있습니다. 현재 Linux에서는 x86_64 아키텍처만 지원합니다.

현재 포팅에서 동작하는 주요 기능은 다음과 같습니다:

* **Objective-C 런타임 없는 Swift**: Linux의 Swift는 Objective-C 런타임에 의존하지 않으며 이를 포함하지도 않습니다. Swift는 Objective-C가 존재할 때 긴밀하게 상호 운용되도록 설계되었지만, Objective-C 런타임이 없는 환경에서도 동작하도록 설계되었습니다.

* **핵심 Swift 언어와 [표준 라이브러리]**: Linux의 구현과 API는 Apple 플랫폼과 대부분 동일합니다. Linux에서 Objective-C 런타임이 없기 때문에 약간의 동작 차이가 있습니다(아래 참고).

* **Glibc 모듈**: Apple 플랫폼의 Darwin 모듈과 유사하게, 이 모듈을 통해 대부분의 Linux C 표준 라이브러리를 사용할 수 있습니다. tgmath.h 등 아직 모듈로 임포트되지 않은 헤더도 있습니다.

  사용하려면 `import Glibc`만 하면 됩니다.

* **Swift Core Libraries**: [Core Libraries]는 Objective-C 없이 Linux에서 사용할 수 있는 Foundation과 XCTest의 핵심 API 구현을 제공합니다. Apple 플랫폼이든 Linux이든 상관없이 크로스 플랫폼 방식으로 이 API를 사용할 수 있도록 하는 것이 목표입니다.

* **LLDB Swift 디버깅과 REPL**: macOS에서와 마찬가지로 [Swift 바이너리를 디버그]하고 [REPL에서 실험]할 수 있습니다.

* **Swift Package Manager**는 Apple 플랫폼에서와 마찬가지로 핵심 구성 요소입니다.

아직 완전히 동작하지 않거나 향후 계획된 사항은 다음과 같습니다:

* **libdispatch**: Core Libraries의 일부로, 업데이트된 Linux 지원이 진행 중입니다. [GitHub의 libdispatch 프로젝트]에서 개발 진행 상황을 확인할 수 있습니다.

* **일부 C API**: 지원하는 모든 플랫폼에 해당하는 사항이지만, 아직 Swift로 임포트되지 않은 C 구문이 있습니다. 이로 인해 varargs / `va_list`를 포함하는 API 등이 사용 불가능합니다. 하지만 최근 몇 개월간 Swift의 C 상호 운용성이 크게 발전하여 이름 있는/익명 union, 익명 struct, 비트 필드를 지원하게 되었습니다.

* **일부 `String` API**: 표준 라이브러리의 `String`에 Apple 플랫폼의 `NSString` 구현에 의존하는 여러 중요 API가 아직 구현되지 않았습니다.

* **런타임 인트로스펙션**: Apple 플랫폼에서 Swift 클래스가 `@objc`로 표시되거나 `NSObject`를 상속하면 Objective-C 런타임을 사용해 객체의 메서드를 열거하거나 셀렉터로 메서드를 호출할 수 있습니다. 이런 기능은 Objective-C 런타임에 의존하므로 사용할 수 없습니다.

* `Array<T> as? Array<S>`: 서로 다른 연관 타입을 가진 컨테이너 캐스팅 같은 일부 메커니즘은 Objective-C와의 브리징 메커니즘에 의존하므로 현재 동작하지 않습니다.

지금 바로 사용해 볼 수 있는 Linux 지원과 함께 오픈 소스 프로젝트를 공개하게 되어 정말 기쁩니다! 아직 할 일이 많으니, [Swift에 기여]하여 Linux 포팅을 더욱 완성도 있게 만들어 주시기 바랍니다.

[표준 라이브러리]: /documentation/standard-library/
[Core Libraries]: /documentation/core-libraries/
[GitHub의 libdispatch 프로젝트]: https://github.com/apple/swift-corelibs-libdispatch
[Ubuntu용 사전 빌드 바이너리를 다운로드]: /download/
[Swift에 기여]: /contributing/
[Swift 바이너리를 디버그]: /getting-started/#using-the-lldb-debugger
[REPL에서 실험]: /getting-started/#using-the-repl
