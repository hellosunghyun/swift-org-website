---
layout: new-layouts/post
date: 2019-02-11 10:00:00
title: ABI 안정성 이후 Apple 플랫폼에서의 Swift 진화
author: jckarter
category: "Language"
---

Swift 5.0의 출시와 함께 Swift는 이제 ABI가 안정적이며 macOS, iOS, tvOS, watchOS의 핵심 구성 요소로 제공됩니다. ABI 안정성은 Swift 초창기부터의 목표였으며, 이러한 플랫폼의 개발자와 사용자에게 많은 이점을 제공합니다:

* 가장 명확한 점은, Swift로 작성된 애플리케이션이 더 이상 Swift 런타임 라이브러리와 함께 배포될 필요가 없어 다운로드 크기가 줄어든다는 것입니다.
* Swift 런타임이 호스트 운영 체제와 더 깊이 통합되고 최적화되어 Swift 프로그램이 더 빠르게 실행되고, 더 나은 런타임 성능을 얻고, 메모리를 적게 사용할 수 있습니다.
* Apple이 향후 OS에서 Swift를 사용한 플랫폼 프레임워크를 제공할 수 있게 됩니다.
* 향후 Swift 버전에서 [모듈 안정성](/blog/abi-stability-and-more/#module-stability)도 제공되면, 서드파티도 Swift로 작성된 바이너리 프레임워크를 배포할 수 있게 됩니다.

그러나 이로 인해, Swift 런타임은 이제 개발자의 툴체인이 아닌 *사용자의 대상 운영 체제의 구성 요소*가 됩니다. 결과적으로, 향후 Swift 프로젝트가 새로운 Swift 런타임 및 표준 라이브러리 기능을 채택하려면, 추가된 기능을 지원하는 업데이트된 Swift 런타임이 포함된 새 OS 버전을 요구해야 할 수도 있습니다. 새로운 언어 기능과 프레임워크 채택과 이전 OS 버전과의 호환성 유지 사이의 이러한 트레이드오프는 Objective-C와 Apple 시스템 프레임워크에서 항상 존재해 왔으며, 이제 Swift에도 적용됩니다.

**어떤 종류의 언어 기능과 에볼루션 제안이 향후 OS 버전으로 제한될 수 있나요?**

새로운 Swift 런타임이나 표준 라이브러리 지원이 필요한 모든 기능은 OS 가용성 제한을 받을 수 있습니다. 여기에는 다음이 포함됩니다:

* 새로운 타입, 프로토콜, 프로토콜 적합성, 함수, 메서드, 프로퍼티를 포함한 표준 라이브러리 추가.
* 새로운 종류의 타입, 기존 타입에 대한 새로운 수정자(예: 함수 타입 속성), 새로운 브리징, 서브타이핑, 동적 캐스팅 관계 등 Swift의 타입 시스템 변경.

Core Team은 향후 새로운 제안이 검토될 때 하위 호환성 영향을 고려할 것입니다.

**ABI 안정성이 기존 코드와의 소스 호환성을 유지하기 위해 Swift 4.0이나 4.2 모드를 사용하는 데 영향을 미치나요? 향후 새로운 언어 모드로 변경하는 데 영향을 미치나요?**

아닙니다. 언어 호환성 설정은 소스 호환성을 제어하는 데 사용되는 순수한 컴파일 타임 기능입니다. ABI에 영향을 미치지 않습니다. Swift 5의 안정적인 ABI를 사용하기 위해 Swift 4 코드를 Swift 5 모드로 마이그레이션할 필요가 없으며, 향후 새 런타임 기능이 필요한 언어 기능을 사용하지 않는다면 더 새로운 OS 요구 사항 없이 새 언어 모드를 채택할 수 있습니다.

**기존 Swift 앱을 최신 운영 체제에서 실행하려면 Xcode 10.2로 다시 컴파일해야 하나요?**

번들된 Swift 런타임 라이브러리가 있는 기존 Swift 바이너리는 macOS 10.14.4, iOS 12.2, tvOS 12.2, watchOS 5.2 및 향후 OS 버전에서 계속 실행됩니다. 이전의 Swift 런타임은 안정적인 Swift ABI와 호환되지 않으므로, 이러한 앱은 번들된 Swift 런타임을 사용하여 계속 실행됩니다. OS의 Swift 런타임은 번들된 Swift 런타임을 상호 무시하도록 설계되어, 앱의 번들된 Swift 런타임에 의해 정의된 클래스를 일반 Objective-C 클래스로 인식하고, 번들된 Swift 런타임도 마찬가지로 OS의 Swift 클래스를 일반 Objective-C 클래스로 인식합니다. 하지만 번들된 런타임을 사용하는 앱은 App Store 앱 씬닝의 이점을 받지 못합니다.

**Swift 5로 빌드된 앱이 10.14.4 이전 버전의 macOS에서 실행되나요?**

Swift 5는 앱이 최소 배포 대상을 올릴 것을 요구하지 않습니다.

이전 OS 릴리스에 배포되는 앱에는 Swift 런타임 사본이 내장됩니다. 이러한 런타임 사본은 Swift 런타임이 포함된 OS 릴리스에서 실행될 때 무시되어 사실상 비활성 상태가 됩니다.

**새 OS를 요구하지 않고 새 런타임 기능을 사용하기 위해 향후 앱에 더 새로운 Swift 런타임을 번들할 수 있나요?**

여러 가지 이유로 이는 불가능합니다:

* The coexistence functionality that is used to maintain compatibility with pre-stable Swift runtimes depends on there being no more than two Swift runtimes active in a single process, and that all Swift code using the pre-stable runtime is self-contained as part of the app. If the same mechanism were used to allow a newer Swift runtime to be bundled to run alongside the OS Swift runtime, the new runtime would have no access to Swift libraries in the OS or ABI-stable third-party Swift libraries linked against the OS runtime.
* Outright replacing the OS runtime with a bundled runtime would circumvent the security of the system libraries, which are code-signed based on their using the OS version of the runtime.
* Furthermore, if the OS Swift runtime could be replaced, this would add a dimension to the matrix of configurations that the OS, Swift runtime, and third-party libraries and apps all have to be tested against. "DLL hell" situations like this make testing, qualifying, and delivering code more difficult and expensive.
* By being in the OS, the Swift runtime libraries can be tightly integrated with other components of the OS, particularly the Objective-C runtime and Foundation framework. The OS runtime libraries can also be incorporated into the dyld shared cache so that they have minimal memory and load time overhead compared to dylibs outside the shared cache. Eventually, it may be impossible for a runtime built outside the OS to fully replicate the behavior of the OS runtime, or doing so may come with significant performance costs when constrained to using stable API.

**새로운 Swift 기능의 런타임 지원을 이전 OS에 하위 배포할 수 있는 방법이 있나요?**

앱 내에 "심" 런타임 라이브러리를 내장하는 기술 등을 사용하여 일부 종류의 런타임 기능을 하위 배포할 수 있을 수 있습니다. 하지만 이것이 항상 가능한 것은 아닙니다. 기능을 성공적으로 하위 배포할 수 있는 능력은 기본적으로 이전 운영 체제에 배포된 바이너리 아티팩트의 제한 사항과 기존 버그에 의해 제약됩니다. Core Team은 향후 검토 중인 새 제안의 하위 배포 영향을 사례별로 고려할 것입니다.
