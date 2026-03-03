---
layout: page
title: Contributor Experience 워크그룹
---

Contributor Experience 워크그룹은 Swift 포럼에서의 기여를 포함하여 Swift 프로젝트 기여자를 지원합니다.

## 헌장

Contributor Experience 워크그룹은 다음에 전념합니다:

- Swift 컴파일러 및 관련 오픈 소스 저장소에 대한 기여의 메커니즘과 사용 편의성을 개선합니다:
  - GitHub 풀 리퀘스트 및 이슈 워크플로에 대한 지침을 제공하고 기대치를 설정합니다.
  - 온보딩 문서를 유지 관리합니다.
  - GitHub 레이블을 추가하고 관리합니다.
- 기여자 간 지원 체계를 제공하고 협업을 촉진합니다:
  - Swift 멘토십 프로그램을 통해.
  - 커뮤니티 그룹을 통해.
  - 다른 기여자와 연결할 수 있는 협업 도구와 공간을 통해.

### 다양성

포용적인 커뮤니티를 육성하는 것은 Swift 커뮤니티의 모든 사람이 Swift 프로젝트에 기여할 수 있도록 활성화하고 역량을 강화하는 데 매우 중요합니다. Contributor Experience 워크그룹은 다른 워크그룹과 협력하여 기여 경로를 제시하고, Swift 프로젝트 참여 진입 장벽을 낮추며, 숙련된 기여자가 리더십과 전문성을 발휘할 수 있는 다양한 기회를 제공하고, Swift 멘토십 프로그램 등의 노력에 다른 워크그룹의 참여를 촉진합니다.

## 멤버십

워크그룹 멤버는 기여자 경험 개선을 위해 활동하는 자원봉사자입니다. 워크그룹에 가입하고 싶으시면 Swift 포럼에서 [@contributor-experience-workgroup](https://forums.swift.org/g/contributor-experience-workgroup)으로 메시지를 보내 주시고, 가입 관심 이유와 Swift 프로젝트 기여자를 어떻게 지원하고 싶은지 알려 주세요!

워크그룹 내 교체를 원활하게 하기 위해 매년 참여 확인 절차가 있으며, 워크그룹에서 물러날 수 있는 기회가 제공됩니다. 또한 새로운 멤버 모집을 위한 참여 공개 모집(Call for Participation)이 Swift 포럼에 공지됩니다.

워크그룹 멤버는 Swift Core Team과 Swift 프로젝트 리드의 재량에 따라 활동하며, 프로젝트 리드가 워크그룹 결정에 대한 최종 권한을 가집니다.

현재 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data['contributer-experience-workgroup'].members | sort: "name" %}

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

다음 명예 워크그룹 멤버의 기여에 감사드립니다:

{% assign people = site.data['contributer-experience-workgroup'].emeriti | sort: "name" %}

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

Contributor Experience 워크그룹은 기여자 경험에 대한 일반적인 논의와 질문에 Development 포럼을 통해 더 넓은 Swift 커뮤니티와 소통합니다. 워크그룹에 비공개로 연락하려면 Swift 포럼에서 [@contributor-experience-workgroup](https://forums.swift.org/g/contributor-experience-workgroup)으로 메시지를 보내면 됩니다.

## 커뮤니티 참여

모든 개인의 기여에 감사드리며, 기여는 풀 리퀘스트 제출에만 국한되지 않습니다. 기여에 관심이 있으시면 다음과 같은 참여를 고려해 주세요: Swift 포럼에서 논의에 참여하기, GitHub 이슈를 신고하거나 분류하기, Swift 프로젝트에 대한 자신의 기여 경험에 대해 피드백 제공하기, Swift 멘토십 프로그램의 멘토로 자원하기.
