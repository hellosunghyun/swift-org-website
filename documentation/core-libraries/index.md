---
redirect_from: '/core-libraries/'
layout: page
title: Swift 코어 라이브러리
---

Swift 코어 라이브러리 프로젝트는 Swift 표준 라이브러리보다 높은 수준의 기능을 제공합니다. 이 라이브러리들은 Swift가 지원하는 모든 플랫폼에서 개발자가 의존할 수 있는 강력한 도구를 제공합니다. 코어 라이브러리는 다음 주요 영역에서 안정적이고 유용한 기능을 제공하는 것을 목표로 합니다:

- 데이터, URL, 문자 집합, 특수 컬렉션 등 자주 사용되는 타입
- 유닛 테스트
- 네트워킹 기본 요소
- 스레드, 큐, 알림 등 작업 스케줄링 및 실행
- 프로퍼티 리스트, 아카이브, JSON 파싱, XML 파싱 등 영속성
- 날짜, 시간, 달력 계산 지원
- OS별 동작 추상화
- 파일 시스템 상호 작용
- 날짜 및 숫자 포맷팅, 언어별 리소스 등 국제화
- 사용자 환경 설정

### 프로젝트 현황

이 라이브러리들은 Swift의 크로스 플랫폼 역량을 확장하기 위한 지속적인 작업의 일부입니다. 커뮤니티와 함께 작업할 수 있도록 오픈 소스 릴리스에 포함하기로 했습니다.

이 모든 기능을 처음부터 작성하는 것은 막대한 작업이 될 것입니다. 따라서 이 분야에서 이미 이루어진 훌륭한 작업을 활용하여 프로젝트를 시작하기로 했습니다. 구체적으로, 기존 세 개의 라이브러리인 `Foundation`, `libdispatch`, `XCTest`의 API와 가능한 한 많은 구현을 재사용합니다. 이 외에도 Swift를 위해 처음부터 설계된 새로운 테스트 라이브러리인 `Swift Testing`이 있습니다.

---

{% include_relative _foundation.md %}
{% include_relative _libdispatch.md %}
{% include_relative _swift-testing.md %}
{% include_relative _xctest.md %}

---
