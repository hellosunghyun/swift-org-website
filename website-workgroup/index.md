---
layout: page
title: Swift.org 웹사이트 워크그룹 (SWWG)
---

Swift.org 웹사이트의 목표, 콘텐츠 거버넌스 및 기여 지침에 대한 자세한 내용은 [웹사이트 개요](/website)를 참고하세요.

Swift 웹사이트 워크그룹은 Swift.org 웹사이트의 발전을 이끄는 운영 팀입니다. Swift 웹사이트 워크그룹은 다음 활동을 수행합니다:

- Swift.org 웹사이트 기여를 관리하는 프로세스를 정의합니다.
- Swift.org 웹사이트 개발과 기여를 적극적으로 안내합니다.
- Swift 커뮤니티의 요구를 해결하는 Swift.org 웹사이트 관련 작업을 정의하고 우선순위를 정합니다.
- Swift 커뮤니티의 요구에 대한 피드백을 Swift Core Team에 전달합니다.

Swift의 [Core Team](/community#core-team)과 유사하게, 워크그룹은 Swift.org 웹사이트에 대한 변경 사항이 제안되고 최종적으로 통합되는 프로세스와 표준을 수립할 책임이 있습니다.

현재 웹사이트 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data.website-workgroup.members | sort: "name" %}

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

다음 명예 워크그룹 멤버들의 기여에 감사드립니다:

{% assign people = site.data.website-workgroup.emeriti | sort: "name" %}

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

## 헌장

Swift 웹사이트 워크그룹의 주된 목표는 Swift.org 웹사이트 기여를 관리하는 프로세스를 정의하고, 위에서 정의한 웹사이트 목표에 맞춰 기여자를 적극적으로 안내하는 것입니다.

이를 위해 워크그룹 멤버는 풀 리퀘스트나 워크그룹의 공식 소통 채널에 게시된 아이디어를 통해 웹사이트 변경 제안을 검토하고, 웹사이트 목표에 부합하는 방식으로 통합할 수 있도록 피드백을 제공합니다.

워크그룹 멤버는 Swift.org 웹사이트의 콘텐츠, 정보 설계, UX 및 UI 디자인, 기술 인프라 등 다양한 측면을 개선하는 프로젝트를 시작할 수도 있습니다.
예를 들어, 초기 워크그룹 목표 중 하나는 Swift로 구축되고 새로운 정보 및 UX/UI 디자인을 갖춘 새로운 웹사이트 구축을 시작하는 것입니다.

Swift 웹사이트 워크그룹 멤버는 Swift Core Team과 Swift 프로젝트 리드의 재량에 따라 활동하며, 프로젝트 리드가 워크그룹 결정에 대한 최종 권한을 가집니다.

## 멤버십

Swift 웹사이트 워크그룹 멤버는 Swift 프로젝트 Core Team이 전문성과 커뮤니티 기여를 기반으로 임명합니다.
워크그룹 멤버십은 기여 기반이며 시간이 지남에 따라 변화할 것으로 예상됩니다.
신규 멤버 추가 및 비활성 멤버 제거는 워크그룹 투표가 필요하며 만장일치 합의가 요구됩니다.
워크그룹 투표 결과는 Swift Core Team의 승인을 받아야 합니다.

워크그룹에 가입하고 싶은 분은 Swift 포럼에서 [@swift-website-workgroup](https://forums.swift.org/new-message?groupname=swift-website-workgroup)으로 연락해 주세요. 메시지에 가입 관심 이유와 워크그룹에 어떻게 기여하고 싶은지를 포함해 주세요. 신청은 다음 가능한 워크그룹 회의에서 검토됩니다.

멤버십 기간은 최대 2년이며, 기간 종료 시 재신청할 수 있습니다.
같은 자리에 여러 후보가 경쟁하는 경우, 워크그룹이 모든 후보를 대상으로 투표하고, 1차 투표에서 가장 많은 표를 받은 두 후보 사이에서 최종 투표를 진행합니다.

3개월 연속 참여하지 않은 비활성 멤버에게는 그룹 잔류 의사를 확인합니다.
6개월간 활동이 없으면 워크그룹이 해당 멤버의 제거를 투표합니다.

## 투표

다양한 상황에서 워크그룹은 투표를 진행합니다. 투표는 전화, 이메일 또는 적절한 경우 투표 서비스를 통해 진행할 수 있습니다. 워크그룹 멤버는 "찬성, yes, +1", "반대, no, -1" 또는 "기권"으로 응답할 수 있습니다. 투표는 워크그룹 헌장에 따라 투표 참여자의 3분의 2 찬성으로 통과됩니다. 기권은 투표하지 않은 것과 동일합니다.

## 소통

Swift 웹사이트 워크그룹은 일반적인 논의에 [Swift.org 웹사이트 포럼](https://forums.swift.org/c/swift-website/)을 사용합니다.
Swift 포럼에서 [@swift-website-workgroup](https://forums.swift.org/new-message?groupname=swift-website-workgroup)으로 비공개 메시지를 보낼 수도 있습니다.
