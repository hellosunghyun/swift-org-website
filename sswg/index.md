---
layout: page
title: Swift Server 워크그룹 (SSWG)
---

Swift Server 워크그룹은 서버 애플리케이션 개발에 Swift 사용을 촉진하는 운영 팀입니다. Swift Server 워크그룹은 다음 활동을 수행합니다:

- Swift 서버 커뮤니티의 요구를 해결하는 작업을 정의하고 우선순위를 정합니다.
- 이러한 작업에 대해 중복을 줄이고, 호환성을 높이며, 모범 사례를 촉진하기 위한 [인큐베이션 프로세스](/sswg/incubation-process.html)를 정의하고 운영합니다.
- 서버 개발 커뮤니티에 필요한 Swift 언어 기능에 대한 피드백을 Swift Core Team에 전달합니다.

Swift의 [Core Team](/community#core-team)과 유사하게, 워크그룹은 라이브러리와 도구가 제안되고, 개발되며, 최종적으로 추천되는 전반적인 기술 방향을 제시하고 표준을 수립할 책임이 있습니다. 워크그룹 멤버십은 기여 기반이며 시간이 지남에 따라 변화할 것으로 예상됩니다.

현재 Swift Server 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data.server-workgroup.members | sort: "name" %}

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

{% assign people = site.data.server-workgroup.emeriti | sort: "name" %}

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

## 소통

Swift Server 워크그룹은 일반적인 논의에 [Swift Server 포럼](https://forums.swift.org/c/server)을 사용합니다.

## 커뮤니티 참여

누구나 다음과 같은 방법으로 기여할 수 있습니다:

- 새로운 라이브러리와 도구를 검토 대상으로 제안합니다.
- 설계 논의에 참여합니다.
- 포럼에서 질문하거나 답변합니다.
- 버그를 신고하거나 분류합니다.
- 라이브러리 프로젝트에 구현이나 테스트를 위한 풀 리퀘스트를 제출합니다.

이러한 논의는 [Swift Server 포럼](https://forums.swift.org/c/server)에서 이루어집니다. 시간이 지남에 따라 워크그룹은 특정 기술 영역에 집중하는 소규모 작업 그룹을 구성할 수 있습니다.

## 헌장

Swift Server 워크그룹의 주된 목표는 궁극적으로 Swift를 사용한 서버 애플리케이션 개발에 적합한 라이브러리와 도구를 추천하는 것입니다. 이 워크그룹과 Swift Evolution 프로세스의 차이점은, 워크그룹 활동의 결과로 생산되는 서버 지향 라이브러리와 도구가 Swift 언어 프로젝트 자체 외부에 존재한다는 것입니다. 워크그룹은 프로젝트가 개발 및 릴리스 단계로 진입할 때 육성하고, 성숙시키고, 추천하는 역할을 합니다.

## 멤버십

워크그룹 멤버십은 기여 기반이며 시간이 지남에 따라 변화할 것으로 예상됩니다. 신규 멤버 추가 및 비활성 멤버 제거는 SSWG 투표가 필요하며 만장일치 합의가 요구됩니다. 과다 대표를 방지하기 위해 회사당 최대 2명으로 제한됩니다. 그룹의 효율성을 위해 총 10명으로 제한됩니다. 멤버십 기간은 최대 2년이며, 기간 종료 시 재신청할 수 있습니다. 같은 자리에 여러 후보가 경쟁하는 경우, SSWG가 모든 후보를 대상으로 투표하고, 1차 투표에서 가장 많은 표를 받은 두 후보 사이에서 최종 투표를 진행합니다.

워크그룹에 가입하고자 하는 회사나 개인은 [Swift Server 포럼](https://forums.swift.org/c/server)에 요청을 게시하여 신청할 수 있습니다. 신청자는 다음 가능한 SSWG 회의에 초대되어 발표할 기회를 가집니다.

4회 연속 워크그룹 회의에 참여하지 않은 비활성 멤버에게는 그룹 잔류 의사를 확인합니다. 10회 연속 회의 불참 시 SSWG가 해당 멤버의 제거를 투표합니다.

## 투표

다양한 상황에서 SSWG는 투표를 진행합니다. 투표는 전화, 이메일 또는 적절한 경우 투표 서비스를 통해 진행할 수 있습니다. SSWG 멤버는 "찬성, yes, +1", "반대, no, -1" 또는 "기권"으로 응답할 수 있습니다. 투표는 SSWG 헌장에 따라 투표 참여자의 3분의 2 찬성으로 통과됩니다. 기권은 투표하지 않은 것과 동일합니다.

## 회의 시간

SSWG는 격주 수요일 오후 2:00(미국 태평양 표준시)에 회의를 진행합니다. [홀수 주](http://www.whatweekisit.org)에 회의가 열립니다.
