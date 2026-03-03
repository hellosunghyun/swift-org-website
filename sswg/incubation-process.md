---
layout: page
title: SSWG 인큐베이션 프로세스
---

## 개요

[서버 페이지](/documentation/server)에 설명된 대로, Swift Server 워크그룹(SSWG)의 목표는 Swift로 서버 애플리케이션을 개발하기 위한 견고하고 건전한 생태계를 만드는 것입니다. 이 목표를 달성하는 한 가지 방법은 커뮤니티가 안심하고 활용할 수 있는 고품질의 잘 유지 관리되는 라이브러리와 도구의 개발을 장려하는 것입니다.

SSWG와 Swift Evolution 프로세스의 차이점은, 워크그룹 활동의 결과로 생산되는 서버 지향 라이브러리와 도구가 Swift 언어 프로젝트 자체 외부에 존재하며, 여러 코드베이스에 분산된다는 것입니다.

Apple과 Vapor 팀에는 이러한 라이브러리와 도구 개발에 적극적으로 참여할 엔지니어가 있으며, 커뮤니티의 참여도 환영합니다. 이를 위해 워크그룹은 _누구나_ 이러한 라이브러리와 도구를 피치하고, 제안하고, 개발하고, 기여할 수 있는 인큐베이션 프로세스를 정의하고 시작합니다.

인큐베이션 프로세스는 프로젝트의 표준화, 품질, 장기성을 보장하면서 육성하고 성숙시키도록 설계되었습니다. 또한 SSWG 미션에 가치를 더할 수 있는 아이디어, 실험 또는 기타 초기 작업의 가시성을 높이는 것을 목표로 합니다.
다음 문서는 이 인큐베이션 프로세스를 상세히 설명합니다.
SSWG [운영 그룹](/documentation/server/)은 Swift Core Team과 유사한 역할을 하며, 커뮤니티의 피드백을 바탕으로 피치/제안을 인큐베이션 프로세스를 통해 진행시키는 최종 결정을 내립니다.
Swift Evolution과 마찬가지로 피치와 제안은 누구나 할 수 있으며, SSWG 운영 그룹의 멤버일 필요는 전혀 없습니다.

## 프로세스

인큐베이션은 **피치**, **제안**, **개발**, **추천**의 단계로 구성됩니다.
인큐베이션의 대부분은 개발 단계에서 이루어집니다.
SSWG는 추천된 모든 도구와 라이브러리, 인큐베이션 프로세스에 참여 중인 프로젝트와 각각의 인큐베이션 단계를 나열하는 공개 "Swift Server 생태계" 인덱스 페이지를 유지 관리합니다.

### 피치

피치는 새로운 라이브러리나 도구에 대한 아이디어를 소개하는 것입니다.
기존 도구에 대한 새로운 기능이나 변경에 대한 아이디어를 소개하는 데도 사용할 수 있습니다.
피치는 코드를 작성하기 전에 커뮤니티로부터 피드백을 수집하고 프로젝트의 정확한 범위를 정의하는 데 사용됩니다.
SSWG의 목표인 서버에서의 Swift 개선과 어떻게 부합하는지 보여줘야 합니다.
피치는 Swift Server 포럼 영역에 새 스레드를 만들어 제출합니다.

### 제안

피치가 제안 단계로 진행되려면 최소 두 명의 SSWG 멤버의 추천이 필요합니다.
제안된 코드의 범위는 추천된 피치와 밀접하게 일치해야 하며, 아래에 정의된 SSWG 졸업 기준에 따라 검토됩니다.

제안은 [제안 디렉토리](https://github.com/swift-server/sswg/tree/main/proposals)에 제안 문서를 추가하는 PR을 만들어 SSWG에 제출합니다. 제안은 [템플릿](https://github.com/swift-server/sswg/blob/main/proposals/0000-template.md)을 따르며 다음 정보를 포함합니다:

- 이름 (SSWG 내에서 고유해야 함)
- 설명 (무엇을 하는지, 왜 가치가 있는지, 기원 및 역사)
- SSWG 미션과의 정렬에 대한 성명
- 선호하는 초기 성숙도 수준 (SSWG 졸업 기준 참조)
- 초기 커미터 (프로젝트 작업 기간)
- 소스 링크 (기본적으로 GitHub)
- 외부 의존성 (라이선스 포함)
- 릴리스 방법론 및 메커니즘
- 라이선스 (기본적으로 Apache 2)
- 이슈 트래커 (기본적으로 GitHub)
- 소통 채널 (slack, irc, 메일링 리스트)
- 웹사이트 (선택 사항)
- 소셜 미디어 계정 (선택 사항)
- 커뮤니티 규모 및 기존 후원 (선택 사항)

제안 PR이 제출되면 SSWG가 격주 회의에서 검토 관리자를 배정합니다.
검토 관리자의 책임은 다음과 같습니다:

- PR 검토
  - 구조와 언어를 검증합니다.
  - 구현이 완료되었는지 확인합니다.
- PR 업데이트
  - 번호를 배정합니다.
  - 검토 관리자를 배정합니다.
  - 상태를 "활성 검토 + 검토 기간"으로 설정합니다.
- PR 작성자의 승인을 받아 위 변경 사항을 병합합니다.
- [서버 제안 영역](https://forums.swift.org/c/server/proposals)에 커뮤니티 피드백을 요청하는 포럼 게시물을 작성합니다.
- 포럼 스레드에서 행동 문제나 주제 이탈을 감시하고, 작성자가 참여하고 있는지 확인합니다.
- 검토 기간이 끝나면 핵심 요점을 SSWG에 서면으로 요약합니다.

SSWG는 격주 주기로 대기 중인 제안에 대해 투표하며, 월 최소 2개의 제안에 대해 투표하는 것을 목표로 합니다.

투표 후 검토 관리자는 다음을 수행합니다:

1. 검토 스레드에서 투표 결과를 발표합니다.
1. 투표 결과에 따라 제안의 상태를 업데이트합니다.
1. 검토 스레드를 닫습니다.

### 졸업 기준

모든 SSWG 프로젝트에는 **Sandbox**, **Incubating**, **Graduated** 중 하나의 성숙도 수준이 연결됩니다.
제안 시 선호하는 초기 성숙도 수준을 명시해야 하며, SSWG가 실제 수준을 투표로 결정합니다.

프로젝트가 Incubating 또는 Graduated로 승인되려면 **절대 다수**(3분의 2)의 찬성이 필요합니다.
Graduated 수준 진입에 대한 절대 다수 찬성이 없는 경우, Graduated에 대한 투표는 Incubating 수준 진입에 대한 투표로 재집계됩니다.
Incubating 수준 진입에 대한 절대 다수 찬성이 없는 경우, 모든 투표는 Sandbox 수준 진입에 대한 **후원**으로 재집계됩니다.
후원자가 최소 2명이 되지 않으면 제안은 거부됩니다.

#### Sandbox 수준

Sandbox 수준으로 승인되려면 프로젝트는 아래에 상세히 기술된 [SSWG 최소 요구 사항](#minimal-requirements)을 충족하고 최소 두 명의 SSWG 후원자의 추천을 받아야 합니다.

초기 사용자는 초기 단계 프로젝트를 각별히 주의하여 다루어야 합니다.
Sandbox 프로젝트는 사용해 볼 수 있지만, 일부 프로젝트는 실패하여 다음 성숙도 수준으로 진행하지 못할 수 있습니다.
프로덕션 준비 상태, 사용자 수 또는 전문적 수준의 지원에 대한 보장은 없습니다.
따라서 사용자는 자체적으로 판단해야 합니다.

#### Incubating 수준

Incubating 수준으로 승인되려면 프로젝트는 Sandbox 수준 요구 사항에 더해 다음을 충족해야 합니다:

- SSWG의 판단으로 적절한 품질과 규모를 갖춘 최소 두 개의 독립적인 최종 사용자가 프로덕션에서 성공적으로 사용하고 있음을 문서화해야 합니다.
- 2명 이상의 메인테이너 및/또는 커미터가 있어야 합니다. 여기서 커미터란 코드베이스에 쓰기 권한이 부여되어 새로운 기능을 추가하고 버그 및 보안 문제를 수정하는 코드를 적극적으로 작성하는 개인입니다. 메인테이너란 코드베이스에 쓰기 권한이 있으며 나머지 프로젝트 커뮤니티의 기여를 적극적으로 검토하고 관리하는 개인입니다. 모든 경우에 코드는 릴리스 전에 최소 한 명의 다른 개인의 검토를 받아야 합니다.
- 패키지에는 관리자 권한을 가진 사람이 2명 이상이어야 합니다. 이는 패키지에 대한 접근 권한을 잃는 것을 방지하기 위함입니다. GitHub 및 GitLab에 호스팅된 패키지의 경우, 최소 두 명의 관리자가 있는 조직에 패키지가 있어야 합니다. 패키지를 위한 별도의 조직을 만들고 싶지 않다면 [Swift Server Community](https://github.com/swift-server-community) 조직에 호스팅할 수 있습니다.
- 지속적인 커밋 및 병합된 기여의 흐름, 적시에 처리되는 이슈, 또는 유사한 활동 지표를 보여야 합니다.
- SSWG의 절대 다수 투표를 받아 Incubation 단계로 이동해야 합니다.

#### Graduated 수준

Graduated 수준으로 승인되려면 프로젝트는 아래에 상세히 기술된 [SSWG 졸업 요구 사항](#graduation-requirements)에 더해 다음을 충족해야 합니다:

- SSWG의 판단으로 적절한 품질과 규모를 갖춘 최소 세 개의 독립적인 최종 사용자가 프로덕션에서 성공적으로 사용하고 있음을 문서화해야 합니다.
- 최소 두 개의 조직에서 위에서 정의한 커미터와 메인테이너가 있어야 합니다.
- SSWG의 절대 다수 투표를 받아 Graduation 단계로 이동해야 합니다.

## 프로세스 다이어그램

![프로세스 다이어그램](/assets/images/sswg/incubation.png)

### 생태계 인덱스

모든 프로젝트와 각각의 수준은 [Swift Server 생태계 인덱스](/documentation/server/#projects)에 나열됩니다.
특정 문제를 해결하는 프로젝트가 둘 이상인 경우(예: 유사한 데이터베이스 드라이버 2개), 인기도순으로 정렬됩니다.
SSWG는 Logging이나 Metrics API와 같이 생태계 전반의 일관성이 중요한 핵심 구성 요소에 대해 단일 솔루션을 지정할 권리를 보유합니다.

성숙도 수준에 승인된 프로젝트는 다음과 같이 정의된 적절한 배지를 사용하여 프로젝트 README에 성숙도 수준을 표시하는 것이 권장됩니다:

[![sswg:sandbox](https://img.shields.io/badge/sswg-sandbox-lightgrey.svg)](https://swift.org/sswg/incubation-process.html#sandbox-level){: style="display: inline-block; width: 94px; height: 20px"}
[![sswg:incubating](https://img.shields.io/badge/sswg-incubating-blue.svg)](https://swift.org/sswg/incubation-process.html#incubating-level){: style="display: inline-block; width: 104px; height: 20px"}
[![sswg:graduated](https://img.shields.io/badge/sswg-graduated-green.svg)](https://swift.org/sswg/incubation-process.html#graduated-level){: style="display: inline-block; width: 104px; height: 20px"}

SSWG는 6개월마다 모든 프로젝트를 검토하며, 최소 요구 사항을 더 이상 충족하지 않는 프로젝트를 강등, 보관 또는 제거할 권리를 보유합니다.
예를 들어, 더 이상 정기적인 업데이트를 받지 않거나 보안 문제를 적시에 해결하지 못하는 Graduated 프로젝트가 이에 해당합니다. 마찬가지로 SSWG는 더 이상 업데이트를 받지 않는 피치와 제안을 제거하거나 보관할 권리를 보유합니다.

Swift Server 생태계 인덱스 페이지의 변경 사항은 SSWG가 Swift Server 포럼을 통해 발표합니다.

## 최소 요구 사항

- 일반
  - 특별히 Swift on Server와 관련성이 있어야 합니다.
  - github.com 또는 유사한 SCM으로 관리되는 공개 소스
    - Swift의 [가이드라인](https://forums.swift.org/t/moving-default-branch-to-main/38515)에 맞춰 기본 브랜치 이름으로 `main`을 사용하는 것을 권장합니다.
  - [Swift 행동 강령](/community/#code-of-conduct)을 채택합니다.
- 생태계
  - SwiftPM을 사용합니다.
  - Logging 및 Metrics API, IO를 위한 SwiftNIO 등 핵심 SSWG 생태계 빌딩 블록과 통합합니다.
- 장기성
  - 두 개 이상의 공개 저장소가 있는 팀이어야 합니다(또는 유사한 경험 지표).
  - 비상 시 SSWG가 졸업 저장소에 접근/인가할 수 있어야 합니다.
  - [SSWG 보안 모범 사례](/sswg/security/)를 채택합니다.
- 테스트, CI 및 릴리스
  - Linux용 단위 테스트가 있어야 합니다.
  - PR과 main 브랜치 테스트를 포함한 CI 설정이 있어야 합니다.
  - 시맨틱 버전 관리를 따르며, 최소 하나의 프리릴리스(예: 0.1.0, 1.0.0-beta.1) 또는 릴리스(예: 1.0.0)가 게시되어야 합니다.
- 라이선스
  - Apache 2, MIT 또는 BSD (Apache 2 권장)
- 관례 및 스타일
  - [Swift API 설계 가이드라인](/documentation/api-design-guidelines/)을 채택합니다.
  - 해당하는 경우 [SSWG 기술 모범 사례](#technical-best-practices)를 따릅니다.
  - 코드 포매팅 도구를 채택하고 CI에 통합하는 것을 권장합니다.

## 졸업 요구 사항

- [최소 요구 사항](#minimal-requirements)
- 안정적인 API가 있어야 합니다(대기 중/계획된 파괴적 API 변경 없음). 최소 하나의 주요 릴리스(예: 1.0.0)가 게시되어야 합니다.
- 새로운 Swift GA 버전을 30일 이내에 지원해야 합니다.
- Swift.org에서 권장하는 최신 2개 Swift 버전에 대한 CI 설정이 있어야 합니다.
- Swift.org에서 권장하는 Linux 배포판 중 최소 1개에 대한 CI 설정이 있어야 합니다.
- 라이브러리 또는 도구가 지원하는 각 플랫폼에 대한 CI 설정이 있어야 합니다.
- macOS와 Linux 모두에 대한 단위 테스트가 있어야 합니다.
- 적절한 경우 Swift.org Docker 이미지를 사용합니다.
- 문서화된 릴리스 방법론이 있어야 합니다.
- 이전 주요 버전 중 최소 하나에 대한 문서화된 지원 전략이 있어야 합니다.
- 프로젝트 거버넌스와 커미터 프로세스를 명시적으로 정의해야 합니다. GOVERNANCE.md 파일과 OWNERS.md 파일에 각각 기술하는 것이 이상적입니다.
- 최소 기본 저장소에 대한 도입자 목록을 포함해야 합니다. ADOPTERS.md 파일이나 프로젝트 웹사이트의 로고로 기술하는 것이 이상적입니다.
- 선택적으로 [Developer Certificate of Origin](https://developercertificate.org) 또는 [Contributor License Agreement](https://en.wikipedia.org/wiki/Contributor_License_Agreement)를 갖출 수 있습니다.

## 보안

[보안](/sswg/security) 섹션에 기술된 지침을 따라 주세요.

## 기술 모범 사례

- 적절한 경우 C 래핑보다 네이티브 Swift를 선호합니다.
- 동시성 / IO
  - 패키지는 불가능한 경우(블로킹 C 라이브러리 등)를 제외하고 비블로킹(비동기 API)이어야 합니다.
  - NIO 래핑은 가능한 한 적게(최대한 없게) 해야 합니다. NIO 타입을 직접 노출하면 패키지 호환성이 크게 향상됩니다.
  - 블로킹 코드는 [NIOThreadPool](https://swiftpackageindex.com/apple/swift-nio/2.48.0/documentation/nioposix/niothreadpool)(Vapor의 SQLite 패키지처럼)에서 래핑해야 합니다.
- force unwrap과 force try는 전제 조건으로만 사용합니다. 즉, 프로그래머가 불가능하거나 프로그래머 오류로 간주하는 조건에만 사용합니다. 모든 force try/unwrap에는 이유를 설명하는 주석이 있어야 합니다.
- C와 인터페이스하지 않는 한 `*Unsafe*`를 사용하지 않습니다.
  - `*Unsafe*` 구조의 사용 예외는 절대적으로 필요한 이유가 적절히 문서화된 경우에 허용됩니다.
  - 이러한 방식으로 `*Unsafe*`를 사용하는 경우, Swift, SwiftNIO 또는 다른 원인 라이브러리에 대한 근본 원인 개선 요청 티켓이 함께 제출되어야 합니다.
- 오류 처리에 `fatalError`를 사용하지 않고, `throws`하거나 `Result`를 반환하는 API를 설계합니다.

## 변경 관리

인큐베이션 프로세스에 대한 변경 사항은 문서화하고 공개적으로 게시해야 하며, 시맨틱 버전 관리 체계에 따릅니다:

- Major: 접근 방식이나 워크플로의 근본적인 변경을 나타냅니다.
- Minor: 개념이나 명명법의 작은 변경을 나타냅니다.

버전 범프가 필요한 업데이트는 SSWG의 절대 다수 투표가 필요합니다. 오타 수정이나 포매팅 같은 사소한 변경은 버전 범프가 필요하지 않습니다.

## 리소스 및 참고 자료

- [인큐베이션 패키지](/sswg/incubated-packages.html)

* [Swift Evolution](https://www.swift.org/swift-evolution/)
* [CNCF Project Lifecycle & Process](https://github.com/cncf/toc/tree/main/process)
* [The Apache Incubator](https://incubator.apache.org)
