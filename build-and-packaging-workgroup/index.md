---
layout: page
title: 빌드 및 패키징 워크그룹
---

## 헌장

빌드 및 패키징 워크그룹은 Swift 생태계에서 빌드 및 패키징 커뮤니티를 대표하는 팀입니다.

빌드 및 패키징 워크그룹은 다음 활동을 수행합니다:

- Swift 커뮤니티의 빌드 및 패키징 요구를 해결하는 노력을 지원하고 안내합니다.
- [Swift Package Manager](https://github.com/swiftlang/swift-package-manager), [Swift Build](https://github.com/swiftlang/swift-build), [llbuild](https://github.com/swiftlang/swift-llbuild) 등 Swift 프로젝트에 포함된 주요 빌드 및 패키징 도구의 개발을 적극적으로 안내합니다.
- 패키지 의존성 해결 개선을 계획하고 안내합니다.
- Swift 프로젝트 외부의 기존 빌드 및 패키징 시스템(예: CMake, Bazel)에서 Swift 통합 개발을 장려합니다.
- 패키지의 크로스 플랫폼 설치 및 배포를 위한 빌드 도구 개발을 장려합니다.
- 향상된 도구를 통해 일관된 Swift 패키지 생태계의 성장을 가능하게 합니다.
- Swift 커뮤니티의 요구에 대한 피드백을 [Ecosystem Steering Group](/ecosystem-steering-group)에 전달합니다.
- 진행 중인 빌드 및 패키징 관련 작업의 현황을 Swift 커뮤니티에 정기적으로 업데이트합니다.

현재 빌드 및 패키징 워크그룹 구성원은 다음과 같습니다:

{% assign people = site.data['build-and-packaging-workgroup'].members | sort: "name" %}

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

빌드 및 패키징 워크그룹의 주된 목표는 Swift 커뮤니티에 훌륭한 빌드 및 패키징 경험을 제공하는 것입니다. 이를 위해 워크그룹은 [Swift Package Manager](https://github.com/swiftlang/swift-package-manager), [Swift Build](https://github.com/swiftlang/swift-build), [llbuild](https://github.com/swiftlang/swift-llbuild) 같은 도구를 개발하고, 빌드 및 패키징과 교차하는 영역에서 다른 Swift 커뮤니티 그룹과 협력하며, Swift 프로젝트 외부의 도구를 지원하도록 커뮤니티와 협력하고, 관련 Evolution 피치 및 제안에 대한 피드백을 제공합니다.

빌드 및 패키징 워크그룹 멤버는 [Ecosystem Steering Group](/ecosystem-steering-group)의 재량에 따라 활동합니다.

필요한 경우, 워크그룹은 다른 Swift 커뮤니티 그룹과 협력하여 관련 영역의 개선을 추진합니다. 다른 그룹 및 메인테이너와 자주 협력하는 영역은 다음과 같습니다:

- [Testing 워크그룹](/testing-workgroup)과의 swift-package-manager의 swift test 하위 명령
- [SourceKit-LSP](https://github.com/swiftlang/sourcekit-lsp) 및 [vscode-swift](https://github.com/swiftlang/vscode-swift) 각 메인테이너와의 빌드 시스템/에디터 통합
- 각 워크그룹 및 [Platform Steering Group](/platform-steering-group)과의 크로스 플랫폼 빌드 지원

Swift 툴체인 자체의 빌드 및 배포 방식에 대한 결정은 워크그룹 헌장의 범위를 벗어납니다.

## 소통

빌드 및 패키징 워크그룹은 일반적인 논의에 [Swift 포럼](https://forums.swift.org)을 사용합니다. Swift 포럼에서 [@build-and-packaging-workgroup](https://forums.swift.org/g/build-and-packaging-workgroup)으로 비공개 메시지를 보낼 수도 있습니다.

## 회의

빌드 및 패키징 워크그룹은 격주로 회의를 진행합니다. 별도 공지가 없는 한 짝수 주에 회의가 열립니다.

많은 워크그룹 회의는 공개 토론을 위한 것으로, Swift 커뮤니티 멤버라면 누구나 [@build-and-packaging-workgroup](https://forums.swift.org/g/build-and-packaging-workgroup)으로 사전에 메시지를 보내 초대를 요청할 수 있습니다. 일부 회의는 그룹 멤버의 비공개 토론을 위해 지정됩니다.

## 멤버십

빌드 및 패키징 워크그룹의 멤버십은 기여 기반이며 시간이 지남에 따라 변화할 것으로 예상됩니다. 워크그룹 멤버가 신규 멤버를 추천하여 [Ecosystem Steering Group](/ecosystem-steering-group)의 승인을 받습니다. 워크그룹의 추천 투표는 만장일치여야 합니다. [Ecosystem Steering Group](/ecosystem-steering-group)이 워크그룹의 의장을 지정합니다. 의장은 워크그룹에 대한 특별한 권한은 없지만, 다음을 포함하여 원활한 운영을 책임집니다:

- 정기 회의를 조직하고 주도합니다.
- 워크그룹이 커뮤니티와 효과적으로 소통하도록 합니다.
- 필요한 경우 워크그룹 대표와 다른 Swift 워크그룹 또는 팀 간 회의를 조율합니다.

워크그룹 멤버는 가능한 한 합의를 통해 독립적으로 결정을 내리며, 합의에 이르기 어려운 경우 [Ecosystem Steering Group](/ecosystem-steering-group)에 안건을 상정합니다.

## 커뮤니티 참여

Swift의 빌드 및 패키징 경험을 개선하고 워크그룹의 이니셔티브에 참여하는 것을 환영합니다. 다음과 같은 방법으로 참여할 수 있습니다:

- [Swift 포럼](https://forums.swift.org)에서 아이디어를 논의합니다.
- [SwiftPM](https://github.com/swiftlang/swift-package-manager), [Swift Build](https://github.com/swiftlang/swift-build), [llbuild](https://github.com/swiftlang/swift-llbuild) 등 워크그룹이 관리하는 프로젝트에서 개선 사항을 추적하거나 버그를 신고하는 GitHub 이슈를 엽니다.
- [SwiftPM](https://github.com/swiftlang/swift-package-manager), [Swift Build](https://github.com/swiftlang/swift-build), [llbuild](https://github.com/swiftlang/swift-llbuild)에 버그 수정이나 개선 사항을 기여합니다.
- 워크그룹 멤버에게 포럼의 [@build-and-packaging-workgroup](https://forums.swift.org/g/build-and-packaging-workgroup)으로 직접 피드백을 제공합니다. 워크그룹 의장은 주요 안건과 주제를 정기 회의에서 논의하도록 가져옵니다.
- 워크그룹의 정기 화상 회의에 참여합니다. [@build-and-packaging-workgroup](https://forums.swift.org/g/build-and-packaging-workgroup)으로 메시지를 보내 접근 권한을 요청하세요. 참여자 수를 비교적 적게 유지해야 하므로 사전 요청이 필요합니다. 커뮤니티에 공개되는 회의는 Swift 포럼에 사전 공지됩니다.
