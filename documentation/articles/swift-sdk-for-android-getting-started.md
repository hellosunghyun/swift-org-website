---
layout: page
date: 2025-10-24 11:00:00
title: Android용 Swift SDK 시작하기
author: [marcprux]
---

2015년 처음 오픈 소스로 공개된 이래, Swift는 Darwin 기반 시스템(iOS, macOS 등) 앱 개발에 집중된 언어에서 Linux, Windows, 다양한 임베디드 시스템을 지원하는 크로스 플랫폼 개발 언어로 성장했습니다. Android용 Swift SDK가 출시되면서 이제 Android 애플리케이션 개발에도 Swift를 사용할 수 있게 되었습니다.

### 시작하기

Android용 Swift 패키지를 빌드하려면 크로스 컴파일 SDK를 설치하고 구성해야 합니다. 크로스 컴파일은 하나의 플랫폼(호스트)에서 다른 플랫폼(대상)에서 실행할 코드를 빌드하는 과정입니다. Swift for Android의 맥락에서, 이는 일반적으로 호스트 macOS 또는 Linux 머신에서 Swift 코드를 컴파일하여 대상 Android OS용 실행 파일이나 라이브러리를 생성하는 것을 의미합니다. 이는 호스트와 대상이 같은(예: macOS에서 macOS용으로 Swift 코드를 컴파일하고 실행하는) 호스트 플랫폼용 Swift 컴파일과 다릅니다.

Android용 Swift 코드를 크로스 컴파일하려면 세 가지 별도의 구성 요소가 필요합니다:

1. **호스트 툴체인**: Swift 코드를 빌드하고 실행하는 데 사용할 `swift` 명령 및 관련 도구입니다.
2. **Android용 Swift SDK**: Android 대상용 Swift 코드를 생성하고 실행하는 데 필요한 라이브러리, 헤더 및 기타 리소스 집합입니다.
3. **Android NDK**: Android "Native Development Kit"에는 호스트 툴체인이 크로스 컴파일 및 링크하는 데 사용하는 `clang` 및 `ld` 같은 크로스 컴파일 도구가 포함되어 있습니다.

#### 1. 호스트 툴체인 설치

먼저 알아야 할 점은, 시스템에 `swift`가 이미 설치되어 있을 수 있지만(macOS의 Xcode 설치를 통해), 크로스 컴파일 Swift SDK를 사용하려면 호스트 툴체인과 Swift SDK 버전이 정확히 일치해야 한다는 것입니다. 이런 이유로 주어진 Swift SDK 버전에 맞는 특정 버전의 호스트 툴체인을 설치해야 합니다.

macOS와 Linux에서 호스트 툴체인을 관리하는 가장 쉽고 권장되는 방법은 [swiftly 명령](/swiftly/documentation/swiftly/getting-started)을 사용하는 것입니다. 설정이 완료되면 다음과 같이 호스트 툴체인을 설치할 수 있습니다:

```console
$ swiftly install main-snapshot-2025-12-17
Installing Swift main-snapshot-2025-12-17
Installing package in user home directory...
main-snapshot-2025-12-17 installed successfully!

$ swiftly use main-snapshot-2025-12-17
The global default toolchain has been set to `main-snapshot-2025-12-17` (was 6.2.3)

$ swiftly run swift --version
Apple Swift version 6.3-dev (LLVM 2bc32d2793f525d, Swift f1a704763ffd2c8)
Target: arm64-apple-macosx15.0
```

또는 최신 `6.3-snapshot-2025-12-14`를 설치할 수 있습니다.

#### 2. Android용 Swift SDK 설치

다음으로, 내장된 `swift sdk` 명령을 사용하여 Swift SDK 번들을 다운로드하고 설치합니다:

```console
$ swift sdk install https://download.swift.org/development/android-sdk/swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a/swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a_android.artifactbundle.tar.gz --checksum 5b5cd4da30ececb28c678c3a17a922f3c5fdb82f0ff6dc777bd44275fcc222e0

Swift SDK bundle at `https://download.swift.org/development/android-sdk/swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a/swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a_android.artifactbundle.tar.gz` successfully installed as swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a_android.artifactbundle.
```

마찬가지로 설치 페이지에서 [다양한 SDK 번들에 대한 설치 명령](/install/macos/#swift-sdk-buindles-dev)을 복사하여 최신 6.3 스냅샷을 설치할 수 있습니다.

이제 `swift sdk list` 명령에 Android Swift SDK가 포함되어 있어야 합니다:

```console
$ swiftly run swift sdk list
swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a_android
```

#### 3. Android NDK 설치 및 구성

Android용 Swift SDK는 Android 아키텍처로 크로스 컴파일하는 데 필요한 헤더와 도구를 제공하기 위해 Android NDK 버전 27d에 의존합니다. [Android NDK를 설치](https://developer.android.com/ndk/guides)하는 다양한 방법이 있지만, 가장 간단한 것은 [NDK 다운로드 페이지](https://developer.android.com/ndk/downloads/#lts-downloads)에서 직접 아카이브를 다운로드하여 압축을 푸는 것입니다.

원하는 디렉터리에서 다음 명령으로 자동화할 수 있습니다:

```console
$ mkdir ~/android-ndk
$ cd ~/android-ndk
$ curl -fSLO https://dl.google.com/android/repository/android-ndk-r27d-$(uname -s).zip
$ unzip -q android-ndk-r27d-*.zip
$ export ANDROID_NDK_HOME=$PWD/android-ndk-r27d
```

NDK를 다운로드하고 압축을 풀었으면, Swift SDK 번들에 포함된 `setup-android-sdk.sh` 유틸리티 스크립트를 실행하여 Android용 Swift SDK에 연결해야 합니다:

```console
$ cd ~/Library/org.swift.swiftpm || cd ~/.swiftpm
$ ./swift-sdks/swift-DEVELOPMENT-SNAPSHOT-2025-12-17-a_android.artifactbundle/swift-android/scripts/setup-android-sdk.sh
setup-android-sdk.sh: success: ndk-sysroot linked to Android NDK at android-ndk-r27d/toolchains/llvm/prebuilt
```

_이미 다른 위치에 NDK를 설치한 경우, `ANDROID_NDK_HOME` 환경 변수를 해당 위치로 설정하고 `setup-android-sdk.sh` 스크립트를 실행하면 됩니다._

이 시점에서 Android용 완전히 작동하는 크로스 컴파일 툴체인을 갖추게 됩니다.

### Android에서 Hello World

이제 정석적인 "Hello World" 프로그램으로 시도해 봅시다. 먼저 코드를 담을 디렉터리를 만듭니다:

```console
$ cd /tmp
$ mkdir hello
$ cd hello
```

다음으로 Swift에 새 패키지를 만들도록 요청합니다:

```console
$ swiftly run swift package init --type executable
```

호스트 머신에서 로컬로 빌드하고 실행해 봅니다:

```console
$ swiftly run swift build
Building for debugging...
[8/8] Applying hello
Build complete! (15.29s)

$ .build/debug/hello
Hello, world!
```

Android용 Swift SDK가 설치 및 구성되었으므로, 이제 `x86_64` 아키텍처의 Android용으로 실행 파일을 크로스 컴파일할 수 있습니다:

```console
$ swiftly run swift build --swift-sdk x86_64-unknown-linux-android28 --static-swift-stdlib
Building for debugging...
[8/8] Linking hello
Build complete! (2.04s)

$ file .build/x86_64-unknown-linux-android28/debug/hello
.build/x86_64-unknown-linux-android28/debug/hello: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /system/bin/linker64, with debug_info, not stripped
```

또는 `aarch64` 아키텍처용으로:

```console
$ swiftly run swift build --swift-sdk aarch64-unknown-linux-android28 --static-swift-stdlib
Building for debugging...
[8/8] Linking hello
Build complete! (2.04s)

$ file .build/aarch64-unknown-linux-android28/debug/hello
.build/aarch64-unknown-linux-android28/debug/hello: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /system/bin/linker64, with debug_info, not stripped
```

[USB 디버깅이 활성화된](https://developer.android.com/studio/debug/dev-options#Enable-debugging) 연결된 Android 기기 또는 로컬에서 실행 중인 Android [에뮬레이터](https://developer.android.com/studio/run/emulator#get-started)가 있으면, Android NDK의 필수 `libc++_shared.so` 의존성과 함께 실행 파일을 복사하고 [`adb`](https://developer.android.com/tools/adb) 유틸리티로 실행할 수 있습니다:

```console
$ adb push .build/aarch64-unknown-linux-android28/debug/hello /data/local/tmp
.build/aarch64-unknown-linux-android28/debug/hello: 1 file pushed, 0 skipped. 155.9 MB/s (69559568 bytes in 0.425s)

$ adb push $ANDROID_NDK_HOME/toolchains/llvm/prebuilt/*/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so /data/local/tmp/
aarch64-linux-android/libc++_shared.so: 1 file pushed, 0 skipped. 145.7 MB/s (1794776 bytes in 0.012s)

$ adb shell /data/local/tmp/hello
Hello, world!
```

### 다음 단계

축하합니다. Android에서 첫 번째 Swift 프로그램을 빌드하고 실행했습니다!

Android 애플리케이션은 일반적으로 커맨드라인 실행 파일로 배포되지 않습니다. 대신 `.apk` 아카이브로 조립되어 홈 화면에서 앱으로 실행됩니다. 이를 지원하기 위해 Swift 모듈을 지원하는 각 아키텍처용 공유 객체 라이브러리로 빌드하여 앱 아카이브에 포함할 수 있습니다. 그런 다음 Swift 코드는 일반적으로 Java나 Kotlin으로 작성된 Android 앱에서 [swift-java](https://github.com/swiftlang/swift-java) 상호 운용성 라이브러리와 도구를 사용하여 Java Native Interface([JNI](https://developer.android.com/training/articles/perf-jni))를 통해 접근할 수 있습니다.

Android용 Swift SDK를 활용하여 전체 Android 애플리케이션을 빌드하는 방법을 보여주는 다양한 프로젝트를 [swift-android-examples](https://github.com/swiftlang/swift-android-examples) 저장소에서 확인하세요.

이러한 더 큰 개발 주제는 향후 아티클과 문서에서 다룰 예정입니다. 그 동안 Android용 Swift SDK에 대해 논의하고 도움을 받으려면 [Swift Android 포럼](https://forums.swift.org/c/platform/android/115)을 방문하세요.
