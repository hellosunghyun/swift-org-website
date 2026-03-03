---
layout: page
title: macOS에서 Swiftly 시작하기
---

[macOS용 swiftly 패키지](https://download.swift.org/swiftly/darwin/swiftly-{{ site.data.builds.swiftly_release.version }}.pkg)를 다운로드하세요.

사용자 계정에 패키지를 설치합니다:

```
installer -pkg swiftly-{{ site.data.builds.swiftly_release.version }}.pkg -target CurrentUserHomeDirectory
```

터미널에서 다음 명령을 실행하여 swiftly를 설정하고 최신 Swift 툴체인을 자동으로 다운로드합니다.

```
~/.swiftly/bin/swiftly init
```

참고: SWIFTLY_HOME_DIR과 SWIFTLY_BIN_DIR 환경 변수를 설정하여 설치 위치를 변경할 수 있습니다.

<div class="warning" markdown="1">
현재 사용 중인 셸에서 세션을 업데이트하기 위해 추가 단계가 필요할 수 있습니다. 환경 파일 소싱, 셸 PATH 재해싱 등 설치 마지막에 안내되는 지침을 따르면 원활하게 설치할 수 있습니다.
</div>

swiftly와 Swift가 설치되었으므로 최신 Swift 릴리스의 `swift` 명령을 사용할 수 있습니다:

```
swift --version
--
Apple Swift version {{ site.data.builds.swift_releases.last.name }} (swift-{{ site.data.builds.swift_releases.last.name }}-RELEASE)
Target: arm64-apple-macosx15.0
```

다른 Swift 릴리스를 설치하고 사용할 수도 있습니다:

```
swiftly install --use 5.10
swift --version
--
Apple Swift version 5.10 (swift-5.10-RELEASE)
Target: arm64-apple-macosx15.0
```

최신 스냅샷 릴리스를 설치하여 최신 기능을 사용할 수도 있습니다:

```
swiftly install --use main-snapshot
```

self-update 명령을 실행하여 swiftly 업데이트를 확인하고 설치합니다:

```
swiftly self-update
```

swiftly에 대한 자세한 내용은 [공식 문서](https://www.swift.org/swiftly/documentation/swiftlydocs/)에서 확인할 수 있습니다.
