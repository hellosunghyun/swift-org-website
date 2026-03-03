---
redirect_from: 'server/guides/building'
layout: page
title: 빌드 시스템
---

서버 애플리케이션을 빌드하는 권장 방법은 [Swift Package Manager](/documentation/package-manager/)를 사용하는 것입니다. SwiftPM은 Swift 코드를 빌드하기 위한 크로스 플랫폼 기반을 제공하며, 하나의 코드베이스로 여러 Swift 플랫폼에서 편집하고 실행할 수 있어 매우 편리합니다.

## 빌드

SwiftPM은 커맨드라인에서 동작하며 Xcode에도 통합되어 있습니다.

터미널에서 `swift build`를 실행하거나 Xcode에서 빌드 액션을 트리거하여 코드를 빌드할 수 있습니다.

### Docker 활용

Swift 바이너리는 아키텍처에 따라 다르므로, macOS에서 빌드 명령을 실행하면 macOS 바이너리가 생성되고 Linux에서 실행하면 Linux 바이너리가 생성됩니다.

많은 Swift 개발자가 Xcode와 함께 제공되는 훌륭한 도구를 활용하기 위해 macOS에서 개발합니다. 하지만 대부분의 서버 애플리케이션은 Linux에서 실행되도록 설계됩니다.

macOS에서 개발하는 경우, Docker는 Linux에서 빌드하고 Linux 바이너리를 만드는 데 유용한 도구입니다. Apple은 공식 Swift Docker 이미지를 [Docker Hub](https://hub.docker.com/_/swift)에 게시하고 있습니다.

예를 들어, 최신 Swift Docker 이미지를 사용하여 애플리케이션을 빌드하려면:

`$ docker run -v "$PWD:/code" -w /code swift:latest swift build`

참고로, Apple Silicon(M1) Mac에서 Intel CPU용 Swift 컴파일러를 실행하려면 커맨드라인에 `--platform linux/amd64 -e QEMU_CPU=max`를 추가하세요. 예:

`$ docker run -v "$PWD:/code" -w /code --platform linux/amd64 -e QEMU_CPU=max swift:latest swift build`

위 명령은 최신 Swift Docker 이미지를 사용하여 Mac의 소스에 대한 바인드 마운트를 활용하여 빌드를 실행합니다.

### 디버그 vs. 릴리스 모드

기본적으로 SwiftPM은 애플리케이션의 디버그 버전을 빌드합니다. 디버그 버전은 상당히 느리므로 프로덕션에서 실행하기에 적합하지 않습니다. 앱의 릴리스 버전을 빌드하려면 `swift build -c release`를 실행하세요.

### 바이너리 위치

배포할 수 있는 바이너리 아티팩트는 Linux에서는 `.build/x86_64-unknown-linux`에, macOS에서는 `.build/x86_64-apple-macosx`에 있습니다.

SwiftPM은 `swift build --show-bin-path -c release`를 사용하여 전체 바이너리 경로를 보여줄 수 있습니다.

### 프로덕션용 빌드

- `swift build -c release`로 릴리스 모드에서 프로덕션 코드를 빌드하세요. 디버그 모드로 컴파일된 코드를 실행하면 성능이 크게 저하됩니다.

- Swift 5.2 이상에서 최상의 성능을 위해 `-Xswiftc -cross-module-optimization`을 전달하세요(Swift 5.2 이전 버전에서는 동작하지 않음). 이 옵션 활성화는 때때로 성능 저하를 일으킬 수 있으므로 성능 테스트로 검증해야 합니다(모든 최적화 변경과 마찬가지로).

- 크래시 시 백트레이스가 출력되도록 애플리케이션에 [`swift-backtrace`](https://github.com/swift-server/swift-backtrace)를 통합하세요. 백트레이스는 Linux에서 기본적으로 동작하지 않으며, 이 라이브러리가 그 격차를 메우는 데 도움을 줍니다. 최종적으로 이는 언어 기능이 되어 별도 라이브러리가 필요 없게 될 것입니다.
