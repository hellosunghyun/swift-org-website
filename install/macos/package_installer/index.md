---
layout: page
title: macOS 패키지 설치 프로그램
---

Xcode에는 Apple이 지원하는 Swift 릴리스가 포함되어 있습니다.
아직 개발 중인 버전을 사용해 보려면
[다운로드](/install/macos) 페이지에서 패키지를 받아 설치하세요.

<div class="warning" markdown="1">
App Store에 앱을 제출하려면 Xcode에 포함된 Swift 버전으로 빌드해야 합니다.
</div>

<div class="warning" markdown="1">
패키지 설치 프로그램을 실행하거나 설치된 툴체인을 사용하는 데 Xcode가 필수는 아닙니다. 단, Xcode가 설치되어 있지 않으면 일부 [미해결 이슈](https://github.com/swiftlang/swift-package-manager/issues/4396)로 인해 Swift Package Manager의 기능이 제한될 수 있습니다.
</div>

0. 최신 Swift 릴리스
   ([{{ site.data.builds.swift_releases.last.name }}](/install/macos))
   또는 개발 [스냅샷](/install/macos/#development-snapshots) 패키지를 다운로드하세요.
   시스템이 해당 패키지의 요구 사항을 충족하는지 확인하세요.

1. 패키지 설치 프로그램을 실행하면
   `~/Library/Developer/Toolchains/`에 Xcode 툴체인이 설치됩니다:

   ```shell
   installer -target CurrentUserHomeDirectory -pkg ~/Downloads/swift-DEVELOPMENT-SNAPSHOT-2025-02-26-a-osx.pkg
   ```

   Xcode 툴체인(`.xctoolchain`)에는 특정 Swift 버전에서 일관된 개발 환경을 제공하는 데 필요한 컴파일러, LLDB 및 기타 관련 도구의 사본이 포함되어 있습니다.

- 설치된 툴체인을 Xcode에서 선택하려면 `Xcode > Toolchains`로 이동하세요.

  Xcode는 선택한 툴체인을 Swift 코드 빌드, 디버깅, 코드 자동 완성 및 구문 강조에 사용합니다. Xcode가 설치된 툴체인을 사용하면 툴바에 새로운 툴체인 표시기가 나타납니다. 기본 도구로 돌아가려면 기본 툴체인을 선택하세요.

- 설치된 툴체인을 IDE 외부에서 사용하려면:
  - `xcrun`의 경우 `--toolchain swift` 옵션을 전달합니다. 예:

    ```shell
    xcrun --toolchain swift swift --version
    ```

  - `xcodebuild`의 경우 `-toolchain swift` 옵션을 전달합니다.

  또는 다음과 같이 `TOOLCHAINS` 환경 변수를 내보내 커맨드라인에서 툴체인을 선택할 수 있습니다:

  ```shell
  export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw ~/Library/Developer/Toolchains/<toolchain name>.xctoolchain/Info.plist)
  ```

### macOS에서의 코드 서명

macOS `.pkg` 파일은
Swift 오픈 소스 프로젝트의 개발자 ID로 디지털 서명되어 있어
변조되지 않았음을 확인할 수 있습니다.
패키지 내의 모든 바이너리도 서명되어 있습니다.

macOS의 Swift 툴체인 설치 프로그램은
제목 표시줄 오른쪽에 잠금 아이콘을 표시해야 합니다.
잠금을 클릭하면 서명에 대한 자세한 정보를 확인할 수 있습니다.
서명은 `Developer ID Installer: Swift Open Source (V9AUD2URP3)`에서
생성된 것이어야 합니다.

<div class="warning" markdown="1">
  잠금이 표시되지 않거나
  서명이 Swift 오픈 소스 개발자 ID에서 생성된 것이 아니라면
  설치를 진행하지 마세요.
  설치 프로그램을 종료한 후
  가능한 한 자세한 내용을 포함하여 <swift-infrastructure@forums.swift.org>로
  이메일을 보내 주시면 문제를 조사하겠습니다.
</div>
