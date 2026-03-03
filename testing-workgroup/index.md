---
layout: page
title: Testing 워크그룹
---

Testing 워크그룹은 Swift 코드의 테스트 경험, 라이브러리 및 도구를 안내하는
팀입니다.

Testing 워크그룹은 다음 활동을 수행합니다:

- [Swift Testing](https://github.com/swiftlang/swift-testing)과
  [Corelibs XCTest](https://github.com/swiftlang/swift-corelibs-xctest) 프로젝트를
  관리하고 기능 제안을 검토합니다.
- Swift 커뮤니티의 테스트 요구를 해결하는 개선 사항을 파악합니다.
- Swift Testing
  [비전 문서](https://github.com/swiftlang/swift-evolution/blob/main/visions/swift-testing.md)에
  기술된 장기적인 기능 방향을 추진합니다.
- 관련 도구에서 테스트 기능과 라이브러리의 통합을 촉진합니다.
- Swift 커뮤니티의 충족되지 않은 테스트 요구에 대한 피드백을 다른 워크그룹,
  Steering Group 및 Core Team에 전달합니다.

현재 Testing 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data['testing-workgroup'].members | sort: "name" %}

<ul>
{% for person in people %}
<li>{{ person.name }}
{%- if person.affiliation -%}
, {{ person.affiliation }}
{% endif %}
{% if person.handle %}
(<a href="https://forums.swift.org/new-message?username={{person.handle}}">@{{person.handle}}</a>)
{% endif %}
</li>
{% endfor %}
</ul>

## 헌장

Testing 워크그룹의 궁극적인 목표는 Swift에서 테스트를 작성하고 실행하는
경험과 효용성을 높여 생태계 전반의 소프트웨어 품질을 향상시키는 것입니다.
이 목표를 위해 워크그룹은 커뮤니티에 필요한 핵심 기능을 구현하는
Swift Testing과 같은 라이브러리를 개발하고, 널리 사용되는 도구, IDE, CI
시스템의 메인테이너와 협력하여 통합하고 테스트 워크플로를 촉진하며,
필요한 경우 다른 Swift 커뮤니티 그룹과 협력하여 해당 영역의 테스트 관련
개선을 추진합니다. 다른 그룹과 자주 협력하는 영역은 다음과 같습니다:

- [swift-package-manager](https://github.com/swiftlang/swift-package-manager)의
  `swift test` 하위 명령
- [vscode-swift](https://github.com/swiftlang/vscode-swift) 플러그인의
  테스트 하위 시스템
- [sourcekit-lsp](https://github.com/swiftlang/sourcekit-lsp)의
  정적 테스트 검색 로직

워크그룹의 핵심 기능은 Swift Testing 프로젝트의 기능 및 API 제안에 대한
커뮤니티 검토를 수행하는 것입니다. 해당 프로젝트에 대한 거버넌스는 함께 제공되는
[비전 문서](https://github.com/swiftlang/swift-evolution/blob/main/visions/swift-testing.md)에
의해 안내됩니다.
워크그룹은 또한 도구 및 IDE와의 테스트 라이브러리 통합 심화,
추가적인 테스트 스타일(성능 또는 UI 테스트 등) 지원,
테스트 워크플로에 영향을 미치는 문제 해결 기회를 모색합니다.
워크그룹 멤버는 Swift 생태계의 새로운 동향을 정기적으로 평가하고,
테스트가 이를 더 잘 지원할 수 있는 방법을 논의합니다.

## 멤버십

Testing 워크그룹의 멤버십은 기여 기반이며 시간이 지남에 따라 변화할 것으로
예상됩니다. 신규 멤버 추가 및 비활성 멤버 제거는 기존 멤버의 투표가 필요하며
만장일치 합의가 요구됩니다. 그룹의 효율성을 위해 멤버십은 총 10명으로
제한됩니다.

Core Team이 워크그룹의 의장을 선출합니다. 의장은 워크그룹에 대한 특별한 권한은
없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- 워크그룹이 커뮤니티와 효과적으로 소통하도록 합니다.
- 필요한 경우 워크그룹 대표와 다른 Swift 워크그룹 또는 팀 간
  회의를 조율합니다.

워크그룹 가입을 원하시면 포럼에서
[@testing-workgroup](https://forums.swift.org/new-message?groupname=testing-workgroup)으로
메시지를 보내 주시면, 다음 가능한 그룹 회의에 초대하여 자세히 논의합니다.
기여하고 그룹에 대한 관심을 보여주는 방법의 예시는
[커뮤니티 참여](#community-participation)를 참고하세요.

워크그룹 멤버는 가능한 한 합의를 통해 독립적으로 결정을 내리며,
중요한 결정에 대해 합의에 이르기 어려운 경우 Core Team에 안건을
상정합니다.

## 회의

Testing 워크그룹은 격주 월요일 오후 1:05(미국 태평양 표준시)에 회의를 진행합니다.
별도 공지가 없는 한 [홀수 주](http://www.whatweekisit.org/)에 회의가 열립니다.

많은 워크그룹 회의는 공개 토론을 위한 것으로, Swift 커뮤니티 멤버라면 누구나
[@testing-workgroup](https://forums.swift.org/new-message?groupname=testing-workgroup)으로
사전에 메시지를 보내 초대를 요청할 수 있습니다. 일부 회의는 그룹 멤버의 비공개
토론을 위해 지정되며, 예를 들어 검토 중인 제안에 대한 결정을 내리는 경우입니다.

## 소통

Testing 워크그룹은
[swift-testing](https://forums.swift.org/c/development/swift-testing/103)
포럼 카테고리를 통해 더 넓은 Swift 커뮤니티와 소통합니다. 워크그룹에
비공개로 연락하려면
[@testing-workgroup](https://forums.swift.org/new-message?groupname=testing-workgroup)으로
메시지를 보내면 됩니다.

정기 회의에서 중요한 결정이 내려지면, 멤버가 1주 이내에 포럼에 게시합니다.
각 제안 검토 결과는 해당 제안의 전용 스레드에서 검토 관리자가 발표합니다.

## 커뮤니티 참여

Swift의 테스트 경험을 개선하고 Testing 워크그룹의 이니셔티브에 참여하는 것을
환영합니다. 다음과 같은 방법으로 참여할 수 있습니다:

- Swift 포럼에서 아이디어를 논의합니다.
  [swift-testing](https://forums.swift.org/c/development/swift-testing/103)
  카테고리에서 새 주제를 만들거나, 기존 주제에 `testing` 태그를 추가할 수 있습니다.
- Testing 워크그룹이 관리하는 프로젝트(예:
  [swift-testing](https://github.com/swiftlang/swift-testing))에서
  개선 사항을 추적하거나 버그를 신고하는 GitHub 이슈를 엽니다.
- [swift-testing](https://github.com/swiftlang/swift-testing)에 버그 수정이나
  개선 사항을 기여합니다. (
  [CONTRIBUTING](https://github.com/swiftlang/swift-testing/blob/main/CONTRIBUTING.md)을
  참고하세요.)
- [swift-testing](https://github.com/swiftlang/swift-testing)을 추가 플랫폼에서
  지원하도록 확장합니다. (
  [Porting](https://github.com/swiftlang/swift-testing/blob/main/Documentation/Porting.md)을
  참고하세요.)
- 자동화된 테스트를 지원하는 새로운 도구를 개발하거나 기존 도구를 개선합니다.
- Testing 워크그룹 멤버에게 포럼의
  [@testing-workgroup](https://forums.swift.org/new-message?groupname=testing-workgroup)으로
  직접 피드백을 제공합니다. 워크그룹 의장은 주요 안건과 주제를
  정기 회의에서 논의하도록 가져옵니다. 워크그룹이 해당 안건에 대한
  조치를 결정합니다.
- Testing 워크그룹의 정기 화상 회의에 참여합니다.
  [@testing-workgroup](https://forums.swift.org/new-message?groupname=testing-workgroup)으로
  메시지를 보내 접근 권한을 요청하세요. 참여자 수를 비교적 적게 유지해야 하므로
  사전 요청이 필요합니다.
