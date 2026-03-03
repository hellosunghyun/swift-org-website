---
layout: page
title: 커뮤니티 개요
---

Swift.org 커뮤니티는 세계 최고의 범용 프로그래밍 언어를 만드는 것을 목표로 합니다. 참여를 원하는 누구의 기여와 함께 언어를 공개적으로 발전시켜 나갈 것입니다. 이 가이드라인 문서는 Swift 커뮤니티가 어떻게 조직되어 있는지 설명하여, Swift에 놀라운 새 기능을 추가하고 더 많은 플랫폼의 더 많은 개발자가 사용할 수 있도록 함께 노력할 수 있게 합니다.

## 소통

Swift 언어는 공개적으로 개발되며, 언어 또는 커뮤니티 프로세스에 관한 모든 기술적 또는 관리적 주제는 Swift 공개 포럼으로 보내야 합니다. 공개 대화를 권장하며, Swift 언어의 활발한 개발자는 관련 포럼 카테고리를 모니터링해야 합니다.

- 포럼 카테고리 목록과 이메일 안내는 [포럼 섹션](#forums)에 있습니다.
- Swift 프로젝트의 소스 코드는 GitHub의 [github.com/swiftlang][github]에서 확인할 수 있습니다.
- Swift 버그 추적 시스템은 [github.com/swiftlang/swift/issues][bugtracker]에서 관리됩니다.

프로젝트 공간 내의 모든 소통은 Swift 프로젝트의 [행동 강령](/code-of-conduct)을 준수해야 합니다.

## 커뮤니티 구조

일관되고 명확한 비전으로 Swift 프로그래밍 언어를 발전시키려면 강력한 리더십이 필요합니다. 리더십은 커뮤니티에서 나오며, 훨씬 더 넓은 기여자와 사용자 그룹과 긴밀하게 협력합니다. 커뮤니티 내의 역할은 다음과 같습니다:

- **[프로젝트 리드](#project-lead)**는 커뮤니티에서 기술 리더를 임명합니다. Apple Inc.가 프로젝트 리드이며, 대표를 통해 커뮤니티와 상호작용합니다.
- **[Core Team](#core-team)**은 Swift 프로젝트의 전략적 방향과 감독을 담당하는 소규모 그룹입니다.
- **[Code Owner](/contributing/#code-owner)**는 Swift 코드베이스의 특정 영역을 담당하는 개인입니다.
- **[Code Merger](/contributing/#code-merger)**는 Swift 코드베이스에 커밋 권한이 있는 사람입니다.
- **[Member](/contributing/#member)**는 GitHub swiftlang 조직의 멤버인 사람입니다.
- **[기여자](/contributing/#contributor)**는 코드 작성, 포럼에서 질문 답변, 버그 보고 또는 분류, Swift evolution 프로세스 참여 등의 방법으로 Swift에 기여한 모든 사람입니다.
- **운영 그룹**
  - **[Ecosystem](/ecosystem-steering-group)**은 Swift 패키지와 도구의 방향에 집중하는 소규모 전문가 그룹입니다.
  - **[Language](#language-steering-group)**는 일관된 방향으로 Swift 언어를 발전시키는 소규모 전문가 그룹입니다.
  - **[Platforms](/platform-steering-group)**는 Swift 언어와 도구를 새로운 환경에서 사용할 수 있게 하는 소규모 전문가 그룹입니다.
- **워크그룹**
  - **[Android](/android-workgroup)**는 Android 애플리케이션 개발에 Swift를 사용하는 작업을 하는 팀입니다.
  - **[Build and Packaging](/build-and-packaging-workgroup)**은 Swift 생태계에서 빌드 및 패키징 커뮤니티를 대표하는 팀입니다.
  - **[C++ Interoperability](/cxx-interop-workgroup)**는 Swift와 C++ 간의 양방향 상호운용성 지원을 추가하는 작업을 하는 팀입니다.
  - **[Contributor Experience](/contributor-experience-workgroup)**는 Swift 포럼 기여를 포함하여 Swift 프로젝트 기여자를 지원하는 팀입니다.
  - **[Documentation Tooling](/documentation-workgroup)**은 Swift의 문서화 경험을 안내하는 팀입니다.
  - **[Foundation](/foundation-workgroup)**은 Foundation 및 기타 저수준 Swift 라이브러리의 방향을 안내하는 팀입니다.
  - **[Swift on Server](/sswg)**는 서버 애플리케이션 개발 및 배포에 Swift 사용을 촉진하는 팀입니다.
  - **[Testing](/testing-workgroup)**은 Swift 코드 테스트를 위한 경험, 라이브러리, 도구를 안내하는 팀입니다.
  - **[Website](/website-workgroup/)**는 Swift.org 웹사이트의 발전을 안내하는 팀입니다.
  - **[Windows](/windows-workgroup/)**는 Windows 애플리케이션 개발에 Swift를 사용하는 작업을 하는 팀입니다.

가장 중요한 것은 Swift를 사용하는 모든 사람이 확장된 커뮤니티의 소중한 구성원이라는 것입니다.

#### 프로젝트 리드

[포럼을 통한 연락](https://forums.swift.org/new-message?username=tkremenek)

Apple Inc.가 프로젝트 리드이며 프로젝트의 중재자 역할을 합니다. 프로젝트 리드는 전 세계 Swift 기여자 커뮤니티에서 리더십 역할에 시니어를 임명합니다. 커뮤니티 리더와 코드 기여자가 함께 Swift를 지속적으로 개선하며, 참여하는 모든 사람의 노력으로 언어가 발전합니다.

[Ted Kremenek](mailto:kremenek@apple.com)이 Apple에서 임명한 대표이며, 프로젝트 리드의 목소리를 대변합니다.

#### Core Team

[포럼을 통한 연락](https://forums.swift.org/new-message?groupname=core-team)

Core Team은 Swift 커뮤니티의 다양한 워크그룹과 이니셔티브 전반에 걸쳐 응집력을 제공하고, 지원과 전략적 방향을 맞춥니다. 프로젝트 리드는 그룹이 Swift 프로젝트와 커뮤니티의 효과적인 관리자 역할을 할 수 있도록 경험, 전문성, 리더십이 혼합된 Core Team 멤버를 임명합니다. Core Team 멤버십은 시간이 지남에 따라 변경될 것으로 예상됩니다.

현재 Core Team 멤버는 다음과 같습니다:

{% assign people = site.data.core_team | sort: "name" %}
{% for person in people %}\* {{ person.name }}
{% endfor %}

다음 명예 Core Team 멤버의 봉사에 감사드립니다:

{% assign people = site.data.core_team_emeriti | sort: "name" %}
{% for person in people %}\* {{ person.name }}
{% endfor %}

#### Language Steering Group

[포럼을 통한 연락](https://forums.swift.org/new-message?groupname=language-workgroup)

Language Steering Group은 Swift 프로젝트 리드와 Core Team이 언어에 대한 변경을 신중하게 검토, 안내, 전략적으로 조정할 수 있는 균형 잡힌 관점과 전문성을 갖춘 것으로 식별한 전문가들로 구성됩니다. Language Steering Group은 커뮤니티의 [언어 evolution 제안](/contributing/#evolution-process)을 검토하고 반복하도록 돕고, 이러한 제안의 승인자 역할을 합니다. 워크그룹 멤버는 최고의 범용 프로그래밍 언어를 만들기 위해 일관된 방향으로 Swift 언어를 발전시키는 데 기여합니다. Language Steering Group 멤버십은 시간이 지남에 따라 변경될 것으로 예상됩니다.

현재 Language Steering Group 멤버는 다음과 같습니다:

{% assign people = site.data.language_wg | sort: "name" %}
{% for person in people %}\* {{ person.name }}
{% endfor %}

{% include_relative _forums.md %}

[homepage]: ./index.html 'Swift.org 홈페이지'
[community]: ./community.html 'Swift.org 커뮤니티 개요'
[contributing_code]: /contributing/#contributing-code '코드 기여'
[test_guide]: ./test_guide.html '좋은 Swift 테스트 작성 가이드'
[blog]: ./blog_home.html 'Swift.org 엔지니어링 블로그'
[faq]: ./faq.html 'Swift.org에 관한 FAQ'
[downloads]: ./downloads.html '최신 Swift 도구 빌드 다운로드'
[forums]: ./forums.html
[contributors]: ./CONTRIBUTORS.txt '모든 Swift 프로젝트 저자 보기'
[owners]: ./CODE_OWNERS.txt '모든 Swift 프로젝트 코드 오너 보기'
[license]: ./LICENSE.txt 'Swift 라이선스 보기'
[email-conduct]: mailto:conduct@swift.org '행동 강령 워킹 그룹에 이메일 보내기'
[email-owners]: mailto:code-owners@forums.swift.org '코드 오너에게 이메일 보내기'
[email-users]: mailto:swift-users@swift.org '다른 Swift 사용자에게 이메일 보내기'
[email-devs]: mailto:swift-dev@swift.org '개발자 토론 목록에 이메일 보내기'
[email-lead]: mailto:project-lead@swift.org 'Swift.org 담당 Apple 리더'
[github]: https://github.com/swiftlang 'GitHub의 Swift 조직'
[repo]: git+ssh://github.com/apple 'GitHub에 호스팅된 저장소 링크'
[bugtracker]: http://github.com/swiftlang/swift/issues
[swift-apple]: https://developer.apple.com/swift 'Swift에 대한 Apple 개발자 홈페이지'
