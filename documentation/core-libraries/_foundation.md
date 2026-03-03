## Foundation

Foundation 프레임워크는 거의 모든 애플리케이션에 필요한 기본 기능 계층을 정의합니다. 기본 클래스를 제공하고, 언어나 런타임이 제공하지 않는 기능을 정의하는 여러 패러다임을 도입합니다. 다음과 같은 목표를 가지고 설계되었습니다:

- 기본 유틸리티 클래스의 작은 집합을 제공합니다.
- 일관된 규약을 도입하여 소프트웨어 개발을 쉽게 합니다.
- 국제화 및 현지화를 지원하여 전 세계 사용자가 소프트웨어에 접근할 수 있도록 합니다.
- OS 독립성 수준을 제공하여 이식성을 높입니다.

Swift 6는 모든 플랫폼에서 핵심 [Foundation](https://developer.apple.com/documentation/foundation/) API의 구현을 통합합니다. Foundation의 현대적이고 이식 가능한 Swift 구현은 플랫폼 간 일관성을 제공하며, 더 견고하고 오픈 소스입니다.

앱이 바이너리 크기에 특히 민감하다면, Foundation 기능의 보다 타겟팅된 하위 집합을 제공하면서 국제화 및 현지화 데이터를 생략하는 `FoundationEssentials` 라이브러리를 import할 수 있습니다.

이 작업에 대한 자세한 정보는 [GitHub 프로젝트 페이지](https://github.com/swiftlang/swift-foundation)에서 확인할 수 있습니다.
