---
layout: page
title: Android 워크그룹
---

Android 워크그룹은 Swift를 사용한 Android 애플리케이션 개발을 촉진하는 팀입니다.

## 헌장

Android 워크그룹의 주된 목표는 Swift 언어의 공식 지원 플랫폼으로 Android를 추가하고 유지 관리하는 것입니다.

Android 워크그룹은 다음 활동을 수행합니다:

- 별도의 트리 외부 또는 다운스트림 패치가 필요 없도록 공식 Swift 배포판의 Android 지원을 개선하고 유지 관리합니다.
- Foundation, Dispatch 등 핵심 Swift 패키지가 Android 관용구에 맞게 더 잘 동작하도록 개선 사항을 제안합니다.
- Platform Steering Group과 협력하여 플랫폼 지원 수준을 전반적으로 공식 정의하고, Android에 대해 특정 수준의 공식 지원을 달성하기 위해 노력합니다.
- Swift 통합에 지원되는 Android API 수준 및 아키텍처 범위를 결정합니다.
- 풀 리퀘스트 검사에 Android 테스트를 포함하는 Swift 프로젝트의 [지속적 통합](https://www.swift.org/documentation/continuous-integration/)을 개발합니다.
- Swift와 Android의 Java SDK 간 브리징 및 Android 앱에 Swift 라이브러리를 패키징하는 모범 사례를 파악하고 제안합니다.
- Android에서 Swift 애플리케이션의 디버깅 지원을 개발합니다.
- 다양한 커뮤니티 Swift 패키지에 Android 지원을 추가하도록 조언하고 지원합니다.

## 소통

Swift Android 워크그룹은 일반적인 논의에 [Swift Android 포럼](https://forums.swift.org/c/platform/android/115)을 사용합니다. Swift 포럼에서 [@android-workgroup](https://forums.swift.org/g/android-workgroup)으로 비공개 메시지를 보낼 수도 있습니다.

## 멤버십

Android 워크그룹 멤버십은 기여하고자 하는 누구에게나 열려 있습니다. 멤버들은 정기 화상 회의와 Swift 포럼을 통해 소통합니다. 워크그룹 참여에 관심 있는 커뮤니티 멤버는 현재 워크그룹 멤버에게 연락하거나, [Android 워크그룹](https://forums.swift.org/g/android-workgroup)에 직접 추가를 요청할 수 있습니다.

Android 워크그룹은 Swift 행동 강령을 준수합니다. 커뮤니티 멤버가 워크그룹이나 그 구성원의 행동 강령 준수에 대해 우려 사항이 있으면 Swift Core Team 구성원에게 연락해야 합니다.

Platform Steering Group이 Android 워크그룹의 의장을 선출합니다. 의장은 워크그룹에 대한 특별한 권한은 없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- 워크그룹이 커뮤니티와 효과적으로 소통하도록 합니다.
- 필요한 경우 워크그룹 대표와 다른 Swift 워크그룹 또는 팀 간 회의를 조율합니다.

워크그룹이 방향을 확신하지 못하거나 합의에 이르지 못하는 경우, 멤버는 관련 Steering Group에 안건을 상정하여 검토를 요청할 수 있습니다. 중요한 결정은 커뮤니티 참여와 Steering Group 감독을 위해 일반적인 Swift Evolution 프로세스를 따라야 합니다.

현재 Android 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data['android-workgroup'].members | sort: "name" %}

<ul>
{% for person in people %}
<li>{{ person.name }}
{%- if person.affiliation -%}
, {{ person.affiliation }}
{% endif %}
{% if person.handle %}
(<a href="https://forums.swift.org/u/{{person.handle}}/summary">@{{person.handle}}</a>)
{% endif %}
</li>
{% endfor %}
</ul>

## 회의

Android 워크그룹은 격주 수요일 정오(미국 동부 표준시)에 회의를 진행합니다. [홀수 주](http://www.whatweekisit.org/)에 회의가 열립니다.

워크그룹 회의는 공개 토론을 위한 것으로, Swift 커뮤니티 멤버라면 누구나 [@android-workgroup](https://forums.swift.org/new-message?groupname=android-workgroup)으로 사전에 메시지를 보내 초대를 요청할 수 있습니다.

## 커뮤니티 참여

누구나 다음과 같은 방법으로 기여할 수 있습니다:

- 설계 논의에 참여합니다.
- 포럼에서 질문하거나 답변합니다.
- 버그를 신고하거나 분류합니다.
- Android 지원 라이브러리 프로젝트에 풀 리퀘스트를 제출합니다.
- Swift 포럼에서 아이디어를 논의합니다. [Android](https://forums.swift.org/c/development/android/115) 카테고리에서 새 주제를 만들거나, 기존 주제에 android 태그를 추가할 수 있습니다.
- Android 경험을 개선하는 새로운 도구를 개발하거나 기존 도구를 개선합니다.
- Android 워크그룹 멤버에게 포럼의 [@android-workgroup](https://forums.swift.org/new-message?groupname=android-workgroup)으로 직접 피드백을 제공합니다. 워크그룹 의장은 주요 안건과 주제를 정기 회의에서 논의하도록 가져옵니다. 워크그룹이 해당 안건에 대한 조치를 결정합니다.
- Android 워크그룹의 정기 화상 회의에 참여합니다. [@android-workgroup](https://forums.swift.org/new-message?groupname=android-workgroup)으로 메시지를 보내 접근 권한을 요청하세요.
