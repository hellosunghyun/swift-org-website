---
layout: page
title: Language Steering Group
---

Swift Language Steering Group은 [Swift Evolution 프로세스](https://github.com/swiftlang/swift-evolution/blob/main/process.md)를 통해 Swift 언어 및 표준 라이브러리의 발전을 이끕니다.

## 헌장

Swift Language Steering Group은 다음 활동을 수행합니다:

- [Swift Core Team](/community/#community-structure)과 협력하여 향후 Swift 릴리스에서 언어 및 라이브러리 개발의 집중 영역에 대한 로드맵을 정의합니다.
- Swift Core Team 및 다른 워크그룹과 협력하여 Swift Evolution 프로세스를 정의하고 문서화하며 발전시킵니다.
- 다음을 통해 Swift 언어 및 라이브러리의 Evolution 프로세스를 구현합니다:
  - 기능 로드맵을 요청하고, 작성하고, 승인합니다.
  - Evolution 논의를 안내합니다.
  - Evolution 논의가 정중하고 포용적으로 유지되도록 합니다.
  - 제안에 대한 검토 실시 여부와 시기를 결정합니다.
  - Evolution 검토를 진행합니다.
  - 제안에 대한 결정을 내립니다.
- 프로젝트 로드맵 변경, 승인된 제안의 상태, 새로운 기능의 가용성에 대해 커뮤니티에 알립니다.

## 멤버십

Language Steering Group은 다양한 배경을 가진 Swift 커뮤니티 멤버로 구성됩니다. Steering Group 멤버는 일반적으로 2년 임기로 활동하는 자원봉사자입니다. Swift Core Team은 Steering Group의 멤버십에 대한 전적인 책임을 지며 적절하다고 판단하는 대로 멤버를 추가하거나 제거할 수 있습니다.

Core Team은 Steering Group의 의장도 선출합니다. 의장은 Steering Group에 대한 특별한 권한은 없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- 제안이 검토될 시기에 충분히 앞서 검토 관리자가 배정되도록 합니다.
- 제안 검토 후 Steering Group이 신속하게 논의하고 결론에 도달하도록 합니다.
- Steering Group이 커뮤니티와 효과적으로 소통하도록 합니다.
- Core Team에 안건을 상정해야 할 때 Steering Group 대표와 Core Team 간 회의를 조율합니다.

현재 Language Steering Group 구성원은 다음과 같습니다:

{% assign people = site.data['language-steering-group'].members | sort: "name" %}

<ul>
{% for person in people %}
<li>{{ person.name }}
{%- if person.affiliation -%}
  , {{ person.affiliation }}
{% endif %}
{% if person.github %}
  (<a href="https://github.com/{{person.github}}">@{{person.github}}</a>)
{% endif %}
</li>
{% endfor %}
</ul>

## 의사 결정

Language Steering Group은 Swift Core Team의 위임을 받아 Core Team을 대신하여 결정을 내리며, 가능한 한 워크그룹 내 합의를 목표로 자율적으로 운영됩니다. 모든 언어 Evolution 주제에 대한 최종 의사 결정 권한은 프로젝트 리드에게 있습니다.

## 소통

Language Steering Group은 Swift 포럼의 [Evolution](https://forums.swift.org/c/evolution) 카테고리를 통해 커뮤니티와 주로 소통합니다. Swift 블로그에 특별 게시물을 준비하기도 합니다.

워크그룹은 더 넓은 Swift 커뮤니티와 다음과 같은 정기적인 소통을 담당합니다:

- 언어 및 라이브러리 제안에 대한 Evolution 제안 검토를 발표(및 진행)합니다.
- 언어 및 라이브러리 제안에 대한 Evolution 제안 검토 결정을 발표합니다.
- Swift의 각 릴리스 후, 해당 릴리스에 새로 구현된 언어 및 라이브러리 Evolution 제안을 설명합니다.
- Swift의 각 릴리스 후, 향후 몇 차례의 릴리스(1~2년 일정)에 대한 현재 언어 및 라이브러리 Evolution 로드맵을 설명합니다.

워크그룹은 언어 및 라이브러리 문서의 내용에 대해서도 일부 책임을 집니다:

- Evolution 제안을 주요 문서로서 편집 권한을 가집니다.
- 네이밍 가이드라인 및 기타 Evolution 프로세스의 관할에 있는 "스타일" 문서에 대한 편집 권한을 가집니다.
- [swift.org](http://swift.org/)에 호스팅되는 언어 및 라이브러리 문서의 기술 내용을 검토하지만, 해당 문서에 대한 편집 권한은 웹사이트 워크그룹이나 다른 적절한 그룹이 가집니다.

## Evolution 프로세스

Language Steering Group은 [Swift Evolution 프로세스](https://github.com/swiftlang/swift-evolution/blob/main/process.md)를 사용하여 제안을 Evolution 검토 과정으로 안내하는 Evolution 워크그룹입니다. Language Steering Group은 Swift 언어와 표준 라이브러리에 대한 Evolution 권한을 가집니다. 언어에 대한 권한에는 컴파일러 플래그(언어 옵션, 진단 옵션 및 언어 또는 프로그래머의 언어 사용 경험에 직접적인 영향을 미치는 유사 설정 등)를 포함한 언어 구성에 대한 권한이 포함됩니다. 이 권한은 최적화나 코드 생성 설정 등의 다른 컴파일러 플래그나 빌드 시스템 및 패키지 관리자와 같은 도구에는 적용되지 않습니다.

Language Steering Group의 Evolution 권한에 대한 이러한 제한은 Evolution 제안의 범위를 제한하기 위한 것이 아닙니다. Swift 워크그룹들은 전체 Swift 프로젝트에 걸쳐 만족스러운 솔루션을 제공하기 위해 협력해야 합니다. 제안이 여러 워크그룹의 관할에 해당하는 프로젝트 부분에 영향을 미치는 경우, 해당 워크그룹들은 함께 협력하여 제안을 Evolution 프로세스를 통해 진행해야 합니다.

Evolution 프로세스의 주요 사용자로서, Language Steering Group은 Core Team과 긴밀히 협력하여 다음과 같이 프로세스를 정의하고 개선합니다:

- 제안이 피치되고 검토되는 방식을 명확히 정의합니다.
- 다양한 역할에서 Evolution 프로세스에 참여하기 위한 가이드라인을 제공합니다.
- 프로세스가 더 잘 작동하도록 프로세스와 가이드라인을 정기적으로 업데이트합니다.

Evolution 프로세스에 대한 모든 변경은 궁극적으로 Core Team의 재량에 달려 있습니다.

## 커뮤니티 참여

Language Steering Group은 Swift 커뮤니티와 별개가 아닙니다. 워크그룹 멤버는 다른 커뮤니티 멤버와 마찬가지로 Evolution 논의에 참여하고 언어 변경을 제안합니다. 워크그룹이 내부 논의 과정에서 제안에 대한 새로운 아이디어를 개발하면, 워크그룹 멤버는 검토가 완료되기 전에 해당 아이디어를 커뮤니티에 공유하여 논의합니다.

Swift 언어, 일반적인 Evolution 프로세스, 특정 Evolution 제안 또는 Language Steering Group 관할의 기타 주제에 대한 제안이나 피드백은 언제든 환영합니다. Language Steering Group과 소통하는 주된 방법은 Swift 포럼의 [Evolution 카테고리](https://forums.swift.org/c/evolution/)에 게시하는 것입니다. 기존 검토, 피치 또는 기타 토론 스레드에 답변을 추가하거나, [Evolution > Discussion](https://forums.swift.org/c/evolution/discuss) 또는 [Evolution > Pitches](https://forums.swift.org/c/evolution/pitches)에 새 스레드를 만들 수 있습니다. 커뮤니티 멤버는 이메일이나 포럼의 개인 메시지를 통해 Language Steering Group 멤버에게 비공개로 연락할 수도 있습니다.

Language Steering Group은 Swift [행동 강령](/code-of-conduct/)을 따릅니다. 학대, 괴롭힘 또는 기타 용납할 수 없는 행동은 해당 행동의 대상인지 여부와 관계없이 워크그룹 의장이나 [Swift Core Team](/community/#community-structure) 구성원에게 연락하거나 해당 행동을 모더레이션에 신고하여 보고할 수 있습니다.
