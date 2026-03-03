---
layout: page
title: Platform Steering Group
---

Platform Steering Group은 Swift 언어와 도구를 새로운 환경에서 사용할 수 있도록 합니다. Platform Steering Group의 주된 목표는 **Swift 툴체인과 언어 런타임을 다양한 플랫폼에 제공하는 개발 작업을 추진하는 것**입니다. 구체적으로 Platform Steering Group은 다음 활동을 수행합니다:

- Swift Core Team과 협력하여 툴체인 개선 및 확장된 플랫폼 지원을 위한 로드맵을 정의합니다.
- [Ecosystem Steering Group](/ecosystem-steering-group/)과 협력하여 모든 지원 플랫폼에서 Swift 개발 환경 구축 경험을 개선합니다.
- [Language Steering Group](/language-steering-group/)과 협력하여 특정 환경에서의 Swift 언어 지원을 정의합니다.
- Swift 툴체인 및 새로운 플랫폼 지원을 위한 Evolution 프로세스를 구현합니다.
- 프로젝트 로드맵 변경, 승인된 제안의 상태, 플랫폼 지원 가용성, 지원 등급 및 요구 사항에 대해 커뮤니티에 알립니다.

## 멤버십

Platform Steering Group은 빌드 시스템, 컴파일러, 디버거, 링커 또는 시스템 프로그래밍에 기술적 전문성과 실무 엔지니어링 경험을 갖춘 Swift 커뮤니티 멤버로 구성됩니다. Steering Group 멤버는 일반적으로 2년 임기로 활동하는 자원봉사자입니다. Swift Core Team은 Steering Group의 멤버십에 대한 전적인 책임을 지며 적절하다고 판단하는 대로 멤버를 추가하거나 제거할 수 있습니다.

현재 Platform Steering Group 구성원은 다음과 같습니다:

{% assign people = site.data['platform-steering-group'].members | sort: "name" %}

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

## Evolution

Platform Steering Group은 다음을 포함한 Swift 툴체인의 저수준 도구에 대한 Evolution 권한을 가집니다:

- SwiftPM 빌드 시스템
- 디버거
- 링커
- 새니타이저 등의 라이브러리
- Swift 런타임 메커니즘
- ABI 안정성
- 플랫폼 제약에 따른 런타임 API 가용성

특정 플랫폼을 위한 Swift 언어 하위 집합을 정의하는 제안이나 비전 문서는 프로그램 의미론 및 전반적인 프로그래밍 모델에 직접적인 영향을 미치므로 Language Steering Group과 공동으로 검토됩니다.

Platform Steering Group의 Evolution 권한은 다음에는 적용되지 않습니다:

- 다양한 플랫폼에서 프로그래머가 코드를 읽고 쓰는 것을 돕는 도구
- IDE 확장 기능
- SourceKit LSP
- DocC
- SwiftPM 의존성 관리 및 배포 기능

이 모든 것은 [Ecosystem Steering Group](/ecosystem-steering-group/)의 관할입니다.

Platform Steering Group이 추진하는 모든 변경 사항이 Evolution 검토를 거치는 것은 아닙니다. Evolution 검토는 새로운 플랫폼 지원 및 ABI 안정성과 툴체인 호환성에 큰 영향을 미치는 기존 플랫폼의 새로운 기능을 정의할 때 중요합니다. Platform Steering Group은 LLDB를 지원하기 위한 DWARF Debugging Standard 제안 제출 등 관련 커뮤니티의 표준 프로세스에도 참여합니다. Evolution 프로세스는 기반 플랫폼과 상호작용하는 구현 세부 사항에만 관여합니다. 특정 플랫폼의 상위 지원 등급 달성을 위한 일상적인 엔지니어링 작업, 일반적인 버그 수정, 성능 개선 및 기타 품질 개선 작업에는 필요하지 않습니다.

## 소통

Platform Steering Group은 Swift 포럼의 [Platform 카테고리](https://forums.swift.org/c/platform)를 통해 커뮤니티와 주로 소통합니다. [Swift 블로그](/blog/)에 특별 게시물을 준비할 수도 있습니다.

Steering Group은 현재 플랫폼 Evolution 프로세스를 마련하고 있으며, 세부 사항이 확정되면 이 헌장을 업데이트할 예정이지만, Steering Group이 다음을 담당할 것으로 예상됩니다:

- 플랫폼 Evolution 제안 검토를 발표(및 진행)합니다.
- 플랫폼 Evolution 제안 검토에 대한 결정을 발표합니다.
- Swift의 각 릴리스 후, 해당 릴리스에 새로 구현된 플랫폼 Evolution 제안을 설명합니다.
- Swift의 각 릴리스 후, 향후 몇 차례의 릴리스(1~2년 일정)에 대한 현재 플랫폼 Evolution 로드맵을 설명합니다.

Steering Group은 플랫폼 및 런타임 라이브러리 문서의 내용에 대해서도 일부 책임을 집니다:

- 플랫폼 Evolution 제안을 주요 문서로서 편집 권한을 가집니다.
- [swift.org](https://swift.org)에 호스팅되는 언어, 라이브러리, 런타임 또는 플랫폼 문서의 플랫폼 지원 관련 기술 내용을 다른 Steering Group과 함께 검토하지만, 해당 문서에 대한 편집 권한은 웹사이트 워크그룹이나 다른 적절한 그룹이 가집니다.

## 플랫폼 Evolution 프로세스

Steering Group은 현재 플랫폼 Evolution 프로세스를 정의하는 작업을 진행 중이며, 준비되면 이곳에 자세한 내용을 공유할 예정입니다.

## 커뮤니티 참여

Platform Steering Group은 Swift 커뮤니티와 별개가 아닙니다. Steering Group 멤버는 다른 커뮤니티 멤버와 마찬가지로 플랫폼 Evolution 논의에 참여하고 변경을 제안합니다. Steering Group이 내부 논의 과정에서 제안에 대한 새로운 아이디어를 개발하면, Steering Group 멤버는 검토가 완료되기 전에 해당 아이디어를 커뮤니티에 공유하여 논의합니다.

Swift 플랫폼 지원, Platform Evolution 프로세스, 특정 Platform Evolution 제안 또는 Platform Steering Group 관할의 기타 주제에 대한 제안이나 피드백은 언제든 환영합니다. Platform Steering Group과 소통하는 주된 방법은 Swift 포럼의 Evolution 카테고리에 게시하는 것입니다. 기존 검토, 피치 또는 기타 토론 스레드에 답변을 추가하거나, [Evolution > Discussion](https://forums.swift.org/c/evolution/discuss) 또는 [Evolution > Pitches](https://forums.swift.org/c/evolution/pitches)에 새 스레드를 만들 수 있습니다. 커뮤니티 멤버는 이메일이나 포럼의 개인 메시지를 통해 Platform Steering Group 멤버에게 비공개로 연락할 수도 있습니다.

Platform Steering Group은 [Swift 행동 강령](/code-of-conduct/)을 따릅니다. 학대, 괴롭힘 또는 기타 용납할 수 없는 행동은 해당 행동의 대상인지 여부와 관계없이 Steering Group 의장이나 [Swift Core Team](/community/#community-structure) 구성원에게 연락하거나 해당 행동을 모더레이션에 신고하여 보고할 수 있습니다.
