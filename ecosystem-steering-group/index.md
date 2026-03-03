---
layout: page
title: Ecosystem Steering Group
---

Ecosystem Steering Group은 활발한 Swift 패키지 및 도구 생태계를 육성합니다.
Ecosystem Steering Group의 주된 목표는 **`swift-foundation`과 같이 Swift 생태계의
근간이 되고 플랫폼 전반에서 널리 사용되는 패키지의 개발을 장려하고 기존 패키지의
발전을 촉진하는 것**입니다. 이 그룹은 Swift 패키지 작성자와 사용자에게 개발 도구와
실행 가능한 지침을 제공하여 이 목표를 달성합니다.
구체적으로 Ecosystem Steering Group은 다음 활동을 수행합니다:

- Swift Core Team과 협력하여 개발자 경험 개선 및 패키지 생태계 성장을 위한 로드맵을 정의합니다.
- [Platform Steering Group](/platform-steering-group/)과 협력하여 모든 지원 플랫폼에서 Swift 개발 환경 구축 경험을 개선합니다.
- [Language Steering Group](/language-steering-group/)과 협력하여 패키지에서 Swift를 효과적으로 사용하기 위한 모범 사례 리소스를 만듭니다. 여기에는 엄격한 동시성 검사 또는 기타 새로운 언어 기능의 채택, 소스 안정적인 패키지 발전을 위한 API 검사기 같은 도구 활용, 패키지 생산 및 소비를 위한 새로운 도구(또는 기존 도구의 기능)에 대한 Evolution 프로세스 정의 및 진행, 린터와 포매터 등을 통한 모범 사례 채택 등이 포함됩니다.
- 패키지 작성자에게 패키지를 유지 관리하고 효과를 평가하는 방법에 대한 실용적인 지침을 제공합니다.

## 멤버십

Ecosystem Steering Group은 핵심 Swift 라이브러리 참여, IDE나 CI 시스템 등 개발자 도구에 대한 엔지니어링 경험, 소프트웨어 공급망 경험 등 다양한 배경(이에 국한되지 않음)을 가진 Swift 커뮤니티 멤버로 구성됩니다. Swift Core Team은 Steering Group의 멤버십에 대한 전적인 책임을 지며 적절하다고 판단하는 대로 멤버를 추가하거나 제거할 수 있습니다.

Core Team은 Steering Group의 의장을 선출합니다. 의장은 Steering Group에 대한 특별한 권한은 없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- Steering Group이 커뮤니티와 효과적으로 소통하도록 합니다.
- 필요한 경우 Steering Group 대표와 다른 Swift Steering Group 및 워크그룹 또는 팀 간 회의를 조율합니다.

현재 Ecosystem Steering Group 구성원은 다음과 같습니다:

- David Cummings [@daveyc123](https://github.com/daveyc123)
- Franz Busch, 의장 [@FranzBusch](https://github.com/FranzBusch)
- Mikaela Caron [@mikaelacaron](https://github.com/mikaelacaron)
- Mishal Shah, Core Team 대표 [@shahmishal](https://github.com/shahmishal)
- Tim Condon [@0xTim](https://github.com/0xTim)
- Tina Liu [@itingliu](https://github.com/itingliu)

# 의사 결정

Ecosystem Steering Group은 Swift Core Team의 위임을 받아 Core Team을 대신하여 결정을 내리며, 가능한 한 Steering Group 내 합의를 목표로 자율적으로 운영됩니다. 모든 생태계 Evolution 주제에 대한 최종 의사 결정 권한은 Core Team에게 있습니다.

이 역할에서의 구체적인 책임은 다음과 같습니다:

- 공식 Swift 프로젝트에 새로운 라이브러리를 포함시키는 것을 평가하고 결정하며, 확립된 Swift 프로젝트 원칙과 전반적인 생태계 전략에 부합하는지 확인합니다.
- Swift 프로젝트 내 패키지의 지속성과 건전성을 보장합니다. 프로젝트 패키지가 유지 관리되지 않거나 비어 있는 경우 후임 메인테이너를 찾거나 대안적 솔루션을 제시하는 것을 포함합니다.
- 공식 생태계 라이브러리에 대한 감독과 지침을 제공하며, 개발 방향이 더 넓은 Swift 생태계의 목표나 건전성에 역행하는 경우 견제와 균형을 통해 개입합니다.

# Evolution

Ecosystem Steering Group은 여러 영역에 대한 관할권을 가집니다.
해당하지 않는 영역은 [아래](#areas-not-covered)에서 논의합니다. 관할 영역은
다음과 같습니다:

- SwiftPM 의존성 관리 기능 및 패키지 서비스 사양
- 현재 네이티브 SwiftPM 빌드 시스템, swift-build, llbuild 및 그 변형을 포함한 빌드 시스템
- `swift-format` 등 패키지 유지 관리 관련 도구
- 문서화 관련 도구
- IDE/에디터 통합을 포함한 코드 편집 관련 도구
- 지속적 통합 및 배포를 위한 도구 및 문서
- 테스트 관련 도구 및 패키지
- `swift-foundation`

플랫폼별 동작과 교차하는 제안이나 비전 문서는 Platform Steering Group과 공동으로 검토됩니다.

## 해당하지 않는 영역

Ecosystem Steering Group의 Evolution 권한은 다음에는 적용되지 않습니다:

- 언어 또는 표준 라이브러리
- 빌드 시스템이 플랫폼별로 사용하는 저수준 도구의 선택
- 빌드 시스템의 저수준 도구 기본 호출
- 디버거
- 링커
- 새니타이저 등의 라이브러리

이 모든 것은 [Language Steering Group](/language-steering-group/) 또는
[Platform Steering Group](/platform-steering-group/)의 관할입니다.

# 워크그룹

Ecosystem Steering Group이 활발하고 건전한 생태계에 기여하는 다양한 영역에 대한
관할권을 가지고 있지만, 그중 일부 영역은 이미 Ecosystem Steering Group 산하의
거버넌스에 속하는 기존 워크그룹이 담당하고 있습니다. 여기에는 다음이 포함됩니다:

- [서버 워크그룹](/sswg/)
- [문서 워크그룹](/documentation-workgroup/)
- [Foundation 워크그룹](/foundation-workgroup/)
- [Testing 워크그룹](/testing-workgroup/)

## 워크그룹 권한

이들 워크그룹은 각자의 영역에서 도메인 전문가이므로, 권한은 각 워크그룹에
있습니다. 현재 Foundation 워크그룹은 swift-foundation과 swift-corelibs-foundation에
대한 권한을 가지고 있습니다. Testing 워크그룹은 swift-testing과
swift-corelibs-xctest에 대한 권한을 가지고 있습니다.

이 라이브러리에 대한 모든 변경이 Swift Evolution 프로세스를 거치는 것은 아니며,
일부 워크그룹은 명확한 Evolution 프로세스를 갖추고 있지 않습니다. Ecosystem
Steering Group은 모든 기존 및 향후 워크그룹과 Contributor Experience 워크그룹과
함께 정확히 무엇이 Evolution 대상인지 정의하고, 모든 워크그룹이 일관된
Evolution 프로세스를 따르도록 협력할 것입니다.

## 신규 워크그룹

'Evolution' 섹션에 명시된 모든 영역을 포괄하기 위해, Ecosystem Steering Group은
기존 워크그룹이 감독하지 않는 영역에 대해 새로운 워크그룹을 설립할 계획입니다.
기존 워크그룹의 모델에 따라, 이 새로운 워크그룹들은 각자의 프로젝트와 집중 영역의
Evolution을 추진하고, 해당 도메인 내에서 전문적 역량을 키우며 커뮤니티 참여를
촉진할 책임을 맡게 됩니다.

## 워크그룹 간 협력

Ecosystem Steering Group은 산하 워크그룹 간의 협력을 촉진하여 효과적으로
소통하고, 일관된 생태계 서사를 구축하며, 전략적 목표에 정렬하도록 합니다.
결정적으로, 이 워크그룹들의 집합적 요구, 진행 상황 및 과제를 Core Team과 다른
Swift Steering Group에 전달하는 중요한 통로 역할을 하며, 동시에 워크그룹들이
더 넓은 프로젝트 방향과 결정에 대해 알 수 있도록 합니다.

# 소통

Ecosystem Steering Group은 Swift 포럼의
[Ecosystem](https://forums.swift.org/c/ecosystem/120) 카테고리를 통해
커뮤니티와 주로 소통합니다. Swift 블로그에 특별 게시물을 준비할 수도 있습니다.

또한 Ecosystem Steering Group은 자체와 산하 워크그룹 간에 긴밀한 협력과
시너지 효과를 촉진하는 명확한 소통 프로세스를 수립할 계획입니다. 이 소통
프로세스는 다른 Steering Group과 Core Team에 생태계의 요구와 과제를 알리는 데도
활용됩니다.

# 생태계 Evolution 프로세스

Ecosystem Steering Group 산하의 기존 워크그룹은 이미 Evolution 프로세스를
운영하고 있을 수 있습니다. Ecosystem Steering Group은 기존 워크그룹,
Contributor Experience 워크그룹, Platform 및 Language Steering Group과 함께
관할 하의 모든 영역에 대해 일관된 Evolution 프로세스를 수립할 계획입니다.
목표는 각 영역에 대해 다음을 명확히 정의하는 것입니다:

- 어떤 패키지 또는 라이브러리가 Evolution 대상인가?
- 어떤 API 또는 CLI 인수가 Evolution 대상인가?
- Evolution이 특정 워크그룹에 위임되는가?
- Evolution 프로세스가 어디에서 진행되는가?

# 커뮤니티 참여

Ecosystem Steering Group은 Swift 커뮤니티와 별개가 아닙니다. Steering Group
멤버는 다른 커뮤니티 멤버와 마찬가지로 생태계 Evolution 논의에 참여하고 변경을
제안합니다. Steering Group이 내부 논의 과정에서 제안에 대한 새로운 아이디어를
개발하면, Steering Group 멤버는 검토가 완료되기 전에 해당 아이디어를 커뮤니티에
공유하여 논의합니다.

Swift 생태계, 생태계 Evolution 프로세스, 특정 생태계 Evolution 제안 또는
Ecosystem Steering Group 관할의 기타 주제에 대한 제안이나 피드백은 언제든
환영합니다. Ecosystem Steering Group과 소통하는 주된 방법은 Swift 포럼의
Evolution 카테고리에 게시하는 것입니다. 기존 검토, 피치 또는 기타 토론 스레드에
답변을 추가하거나, [Evolution > Discussion](https://forums.swift.org/c/evolution/discuss) 또는
[Evolution > Pitches](https://forums.swift.org/c/evolution/pitches)에 새 스레드를
만들 수 있습니다. 커뮤니티 멤버는 포럼에서
`@ecosystem-steering-group`으로 개인 메시지를 통해 Ecosystem Steering Group
멤버에게 비공개로 연락할 수도 있습니다.

Ecosystem Steering Group은 [Swift 행동 강령](/code-of-conduct/)을
따릅니다. 학대, 괴롭힘 또는 기타 용납할 수 없는 행동은 해당 행동의 대상인지
여부와 관계없이 Steering Group 의장이나 Swift Core Team 구성원에게 연락하거나
해당 행동을 모더레이션에 신고하여 보고할 수 있습니다.
