---
redirect_from: '/continuous-integration/'
layout: page
title: Swift 지속적 통합
---

Swift 프로젝트는 [점진적 개발 모델](/contributing/#contributing-code)을 따르며, 프로젝트 안정성을 유지하기 위한 핵심 도구로서 머지 전 Pull Request의 변경 사항에 대한 지속적 통합(CI) 테스트를 활용합니다. 이 시스템은 swift.org에 게시되는 스냅샷 빌드를 생성하고, 활성 브랜치에 대해 테스트를 실행합니다. 또한 커밋 전 Pull Request에 대해 테스트를 실행하는 리뷰 프로세스의 일부로도 사용됩니다.

## 구성

[지속적 통합 시스템](https://ci.swift.org)은 [Jenkins](https://jenkins.io)로 구동되며 현재 macOS, Ubuntu 18.04, Ubuntu 20.04, Ubuntu 22.04, CentOS 7, Amazon Linux 2에서 빌드 및 테스트를 지원합니다. iOS, tvOS, watchOS 시뮬레이터에서의 테스트도 지원됩니다.

### 작업 구성

지속적 통합 작업은 [CI 시스템](https://ci.swift.org)에서 다음과 같은 카테고리로 구성되어 있습니다:

- Development - main 브랜치로 빌드하도록 구성된 모든 작업
- Swift 5.6 - release/5.6으로 빌드하도록 구성된 모든 작업
- Packages - main 및 release/5.6 브랜치용 툴체인을 생성하는 작업
- Pull Request - main에 머지하기 전 GitHub Pull Request를 검증하는 작업

## 사용법

swift.org CI 시스템과 상호 작용하는 방법은 여러 가지가 있습니다:

- 통합 작업 상태 - [https://ci.swift.org](https://ci.swift.org)에서 모든 통합 작업의 빌드 및 테스트 상태를 확인할 수 있습니다.
- Pull Request 테스트 - Pull Request를 통해 변경하면 통합 전에 변경 사항이 테스트되며, 결과가 Pull Request에 인라인으로 게시됩니다.

더 많은 사용법 문서는 [여기](https://github.com/swiftlang/swift/blob/main/docs/ContinuousIntegration.md)에서 찾을 수 있습니다.

### Pull Request 테스트

Pull Request에서 변경 사항이 검토되면, Swift 팀원이 CI 시스템에 의한 테스트를 트리거합니다. macOS, Linux, 또는 양쪽 플랫폼에서 테스트를 실행할 수 있습니다.

![pull request CI trigger](../continuous-integration/images/ci_pull_command.png)

그러면 테스트 진행 상태가 Pull Request에 인라인으로 게시됩니다. "details" 링크를 클릭하면 진행 중인 테스트의 상태 페이지로 바로 이동할 수 있습니다.

![CI Progress](../continuous-integration/images/ci_pending.png)

테스트가 완료되면 해당 결과도 Pull Request에 업데이트됩니다.

![CI Pass](../continuous-integration/images/ci_pass.png)

테스트 중 문제가 발견되면 실패 상세 정보로 연결되는 링크를 받게 됩니다.

![CI Pass](../continuous-integration/images/ci_failure.png)

변경 사항이 개발 브랜치에 커밋되기 전에 Swift 프로젝트의 [품질 기준](/contributing/#quality)을 충족해야 하며, 변경으로 인해 발생한 문제를 수정할 책임이 있습니다. 개발 또는 릴리스 브랜치의 빌드나 테스트가 변경으로 인해 깨지면 이메일 알림을 받게 됩니다.

## 커뮤니티 참여

Swift 프로젝트는 다른 구성을 지원하기 위한 커뮤니티의 제안을 환영합니다.

### Swift 커뮤니티 호스팅 지속적 통합

커뮤니티 구성원은 [Swift 커뮤니티 호스팅 지속적 통합](https://ci-external.swift.org)에서 추가 플랫폼을 위한 노드를 호스팅하는 데 자원할 수 있으며, 호스트 시스템을 유지 관리할 책임이 있습니다. 새 노드는 [Swift 커뮤니티 호스팅 CI 저장소](https://github.com/swiftlang/swift-community-hosted-continuous-integration)에 Pull Request를 생성하여 시작할 수 있습니다. 프로세스에 대한 자세한 정보는 [README.md](https://github.com/swiftlang/swift-community-hosted-continuous-integration/blob/main/README.md)에 문서화되어 있습니다.

Swift 커뮤니티 호스팅 CI는 지원되지 않는 플랫폼을 사례별로 지원 플랫폼으로 이전할 수 있습니다. 제공되는 노드 수에 따라 @swift-ci Pull Request 테스트도 커뮤니티 호스팅 CI와 통합될 수 있습니다.
