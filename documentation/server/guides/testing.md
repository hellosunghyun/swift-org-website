---
redirect_from: 'server/guides/testing'
layout: page
title: 테스트
---

SwiftPM은 [Apple의 유닛 테스트 프레임워크인 XCTest](https://developer.apple.com/documentation/xctest)와 통합되어 있습니다. 터미널에서 `swift test`를 실행하거나 IDE(Xcode 등)에서 테스트 액션을 트리거하면 모든 XCTest 테스트 케이스가 실행됩니다. 테스트 결과는 IDE에 표시되거나 터미널에 출력됩니다.

Linux에서 테스트하는 편리한 방법은 Docker를 사용하는 것입니다. 예를 들어:

`$ docker run -v "$PWD:/code" -w /code swift:latest swift test`

위 명령은 최신 Swift Docker 이미지를 사용하여 파일 시스템의 소스에 바인드 마운트를 활용하여 테스트를 실행합니다.

Swift는 아키텍처별 코드를 지원합니다. 기본적으로 Foundation은 Darwin이나 Glibc 같은 아키텍처별 라이브러리를 가져옵니다. macOS에서 개발하면서 Linux에서 사용할 수 없는 API를 사용하게 될 수 있습니다. 클라우드 서비스는 대부분 Linux에 배포하므로 Linux에서 테스트하는 것이 매우 중요합니다.

Linux 테스트와 관련하여 역사적으로 중요한 세부 사항은 `Tests/LinuxMain.swift` 파일입니다.

- Swift 5.4 이상에서는 모든 플랫폼에서 테스트가 자동으로 검색되며, 특별한 파일이나 플래그가 필요 없습니다.
- Swift 5.1 이상 5.4 미만에서는 `swift test --enable-test-discovery` 플래그를 사용하여 Linux에서 테스트를 자동으로 검색할 수 있습니다.
- Swift 5.1 이전 버전에서는 `Tests/LinuxMain.swift` 파일이 SwiftPM에 Linux에서 실행해야 할 모든 테스트의 인덱스를 제공하며, 유닛 테스트를 추가할 때 이 파일을 최신 상태로 유지하는 것이 중요합니다. 이 파일을 재생성하려면 테스트를 추가한 후 `swift test --generate-linuxmain`을 실행하세요. CI 설정에 이 명령을 포함하는 것도 좋은 방법입니다.

### 프로덕션을 위한 테스트

- Swift 5.1에서 5.4 사이 버전의 경우, Linux에서 테스트를 놓치지 않으려면 항상 `--enable-test-discovery`로 테스트하세요.

- 새니타이저를 활용하세요. 코드를 프로덕션에서 실행하기 전, 그리고 가급적 CI 프로세스의 정기적인 부분으로 다음을 수행하세요:
  - TSan(스레드 새니타이저)으로 테스트 스위트 실행: `swift test --sanitize=thread`
  - ASan(주소 새니타이저)으로 테스트 스위트 실행: `swift test --sanitize=address` 및 `swift test --sanitize=address -c release -Xswiftc -enable-testing`

- 일반적으로 테스트할 때 `swift build --sanitize=thread`로 빌드하는 것이 좋습니다. 바이너리 실행이 느려지고 프로덕션에는 적합하지 않지만 배포 전에 스레딩 이슈를 조기에 발견할 수 있습니다. 스레딩 이슈는 디버그하고 재현하기 매우 어렵고 무작위 문제를 일으키는 경우가 많습니다. TSan은 이를 조기에 발견하는 데 도움을 줍니다.
