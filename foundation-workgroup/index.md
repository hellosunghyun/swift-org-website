---
layout: page
title: Foundation 워크그룹
---

Foundation 워크그룹은 Swift Foundation 프로젝트를 관리합니다. Foundation은 다양한 애플리케이션에서 유용한 기본 기능 계층을 제공합니다. 숫자, 데이터, URL, 날짜를 위한 기본 타입과 작업 관리, 파일 시스템 접근, 지역화 등의 기능을 포함합니다.

Foundation 워크그룹은 다음 활동을 수행합니다:

- Foundation의 방향에 대한 상위 수준 목표를 설정합니다.
- 프로젝트 목표에 부합하는 커뮤니티 API 제안의 검토를 진행하고 우선순위를 정합니다.
- Foundation 및 관련 프로젝트에 대한 기여를 관리하는 프로세스를 정의합니다.
- Swift 커뮤니티의 요구에 대한 피드백을 Swift Core Team에 전달합니다.

현재 Foundation 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data['foundation-workgroup'].members | sort: "name" %}

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

Foundation 프로젝트의 목표는 최고의 기본 데이터 타입과 국제화 기능을 제공하고 모든 곳의 Swift 개발자가 사용할 수 있도록 하는 것입니다. 언어에 새로운 기능이 추가되면 이를 활용하며, 라이브러리 및 앱 작성자가 안심하고 상위 수준 API를 구축할 수 있게 합니다.

이러한 신뢰의 중요한 부분은 [커뮤니티 중심 API 검토 프로세스](https://github.com/swiftlang/swift-foundation/blob/main/Evolution.md)를 통해 쌓입니다. Foundation 워크그룹은 이 프로세스를 감독하며, Swift 프로젝트, Apple 플랫폼 및 기타 플랫폼의 개발과 긴밀히 협력합니다. 워크그룹 멤버는 기여자와 함께 API 제안을 검토하고 반복하며, [GitHub Issues](https://github.com/swiftlang/swift-foundation/issues)에서 버그 및 기능 요청을 분류하고, 풀 리퀘스트와 포럼 게시물을 통해 변경 사항을 반영하는 피드백을 제공합니다. 워크그룹 멤버는 Swift 생태계의 새로운 동향을 살펴보고, 라이브러리가 언어에 맞춰 어떻게 발전해야 하는지 논의합니다.

워크그룹은 분기별로 회의하며, 제안의 검토 기간이 끝난 후 제안을 승인하거나 수정을 위해 반려할 때도 회의합니다.

### Evolution 프로세스

Foundation 워크그룹은 [Foundation GitHub 저장소](https://github.com/swiftlang/swift-foundation/blob/main/Evolution.md)에 문서화된 Evolution 프로세스를 따릅니다.

### 멤버십

Foundation 워크그룹 멤버는 위 헌장에 명시된 대로 Foundation 프로젝트의 관리 책임을 맡습니다. 다양한 배경을 가진 Swift 커뮤니티 멤버로 구성됩니다.

Core Team은 워크그룹의 의장도 선출합니다. 의장은 워크그룹에 대한 특별한 권한은 없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- 워크그룹이 커뮤니티와 효과적으로 소통하도록 합니다.
- Core Team에 안건을 상정해야 할 때 워크그룹 대표와 Core Team 간 회의를 조율합니다.

워크그룹 멤버는 가능한 한 합의를 통해 독립적으로 결정을 내리며, 중요한 결정에 대해 합의에 이르기 어려운 경우 Core Team에 안건을 상정합니다.

## 소통

Foundation 워크그룹은 일반적인 논의에 [포럼](https://forums.swift.org/c/related-projects/foundation/99)을 통해 더 넓은 Swift 커뮤니티와 소통합니다.

워크그룹에 비공개로 연락하려면 Swift 포럼에서 [@foundation-workgroup](https://forums.swift.org/new-message?groupname=foundation-workgroup)으로 메시지를 보내면 됩니다.

## 커뮤니티 참여

Foundation은 버그 수정, 테스트, 문서 작성, 새로운 플랫폼 포팅 등 커뮤니티의 기여를 환영합니다. Foundation의 새로운 API에 대한 커뮤니티 기여 승인 프로세스를 포함한 자세한 내용은 [`CONTRIBUTING`](https://github.com/apple/swift-foundation/blob/main/CONTRIBUTING.md) 문서를 참고하세요. 위에 링크된 커뮤니티 API 승인 프로세스와 Evolution 프로세스에서의 의견과 검토도 환영합니다.

코드에 국한되지 않는 일반적인 주제에 대한 논의는 [포럼](https://forums.swift.org/c/related-projects/foundation/99)에서 이루어집니다. [@foundation-workgroup](https://forums.swift.org/new-message?groupname=foundation-workgroup)으로 메시지를 보내 워크그룹에 연락할 수도 있습니다. 의장은 정기 워크그룹 회의에서 미해결 안건과 주제 목록을 가져옵니다. 워크그룹이 해당 안건에 대한 조치를 결정합니다.
