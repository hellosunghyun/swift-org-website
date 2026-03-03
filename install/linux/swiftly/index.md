---
layout: page
title: Linux에서 Swiftly 시작하기
---

[Linux (Intel)](https://download.swift.org/swiftly/linux/swiftly-{{ site.data.builds.swiftly_release.version }}-x86_64.tar.gz) 또는 [Linux (ARM)](https://download.swift.org/swiftly/linux/swiftly-{{ site.data.builds.swiftly_release.version }}-aarch64.tar.gz)용 swiftly를 다운로드하세요.

```
curl -O "https://download.swift.org/swiftly/linux/swiftly-{{ site.data.builds.swiftly_release.version }}-$(uname -m).tar.gz"
```

PGP 서명을 사용하여 아카이브의 무결성을 검증할 수 있습니다. 다음 명령으로 서명을 다운로드하고, swift.org 서명을 키체인에 설치한 후, 서명을 검증합니다.

```
curl https://www.swift.org/keys/all-keys.asc | gpg --import -
curl -O "https://download.swift.org/swiftly/linux/swiftly-{{ site.data.builds.swiftly_release.version }}-$(uname -m).tar.gz.sig"
gpg --verify swiftly-{{ site.data.builds.swiftly_release.version }}-$(uname -m).tar.gz.sig swiftly-{{ site.data.builds.swiftly_release.version }}-$(uname -m).tar.gz
```

아카이브를 압축 해제합니다.

```
tar -zxf swiftly-{{ site.data.builds.swiftly_release.version }}-$(uname -m).tar.gz
```

터미널에서 다음 명령을 실행하여 swiftly를 설정하고 최신 Swift 툴체인을 자동으로 다운로드합니다.

```
./swiftly init
```

참고: SWIFTLY_HOME_DIR과 SWIFTLY_BIN_DIR 환경 변수를 설정하여 설치 위치를 변경할 수 있습니다.

현재 사용 중인 셸에서 세션을 업데이트하기 위해 추가 단계가 필요할 수 있습니다. 환경 파일 소싱, 셸 PATH 재해싱 등 설치 마지막에 안내되는 지침을 따르면 원활하게 설치할 수 있습니다.

Swift 툴체인이 정상적으로 동작하려면 시스템에 특정 패키지가 설치되어 있어야 할 수 있습니다. swiftly 초기화 과정에서 누락된 패키지의 설치 방법을 안내합니다.

swiftly와 Swift가 설치되었으므로 최신 Swift 릴리스의 `swift` 명령을 사용할 수 있습니다:

```
swift --version
--
Swift version {{ site.data.builds.swift_releases.last.name }} (swift-{{ site.data.builds.swift_releases.last.name }}-RELEASE)
Target: x86_64-unknown-linux-gnu
```

다른 Swift 릴리스를 설치하고 사용할 수도 있습니다:

```
swiftly install --use 5.10
swift --version
--
Swift version 5.10 (swift-5.10-RELEASE)
Target: x86_64-unknown-linux-gnu
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
