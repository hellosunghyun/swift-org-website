---
layout: page
date: 2024-06-04 12:00:00
title: Static Linux SDK 시작하기
author: [al45tair, incertum, etcwilde]
---

Swift가 macOS나 iOS 같은 Apple 플랫폼용 소프트웨어를 빌드하는 데 사용될 수 있다는 것은 잘 알려져 있지만, Swift는 Linux와 Windows를 포함한 다른 플랫폼에서도 지원됩니다.

Linux용 빌드가 특히 흥미로운 이유는 역사적으로 Swift로 작성된 Linux 프로그램이 대상 시스템에 Swift 런타임과 모든 의존성의 복사본이 설치되어 있어야 했기 때문입니다. 또한 특정 배포판이나 특정 배포판의 특정 주요 버전용으로 빌드된 프로그램이 다른 배포판에서, 심지어 같은 배포판의 다른 주요 버전에서도 반드시 실행되지는 않았습니다.

Swift Static Linux SDK는 프로그램을 외부 의존성이 전혀 없는(C 라이브러리조차 없는) _완전히 정적으로 링크된_ 실행 파일로 빌드할 수 있게 하여 이 두 가지 문제를 모두 해결합니다. 이는 Linux 시스템 콜 인터페이스에만 의존하므로 _어떤_ Linux 배포판에서든 실행됩니다.

이러한 이식성에는 비용이 따르는데, 프로그램이 의존하는 모든 것이 정적으로 링크되어야 합니다. 동적 링크는 전혀 지원되지 않으며 `dlopen()` 함수도 작동하지 않습니다.

이러한 설계 선택의 결과로 Static Linux SDK는 Swift Package Manager에서 익숙할 수 있는 "의존성 직접 관리" 모델을 사용합니다. 시스템 라이브러리는 사용할 수 없으며, Static SDK에 포함된 소수의 공통 라이브러리(아래 참조)에 의존하거나 추가로 필요한 것은 직접 빌드해야 합니다.

또한 Static Linux SDK는 Swift 컴파일러와 패키지 관리자가 지원하는 모든 플랫폼에서 사용할 수 있습니다. 즉, macOS에서 프로그램을 개발하고 테스트한 다음 로컬이든 클라우드든 Linux 기반 서버에 빌드하고 배포할 수 있습니다.

마지막으로, Apple 플랫폼용 동등한 SDK가 있는지 궁금한 분들을 위해 말씀드리면, 그러한 정적 SDK는 존재하지 않습니다. Apple 운영체제에서는 완전히 정적인 실행 파일을 빌드하는 것이 불가능합니다. Linux와 달리 Darwin 커널의 시스템 콜 테이블이 ABI의 일부가 아니기 때문입니다. 이 설계로 인해 모든 시스템 콜이 동적 라이브러리 `libsystem.dylib`를 통해 라우팅되어야 하므로 100% 정적 링크된 바이너리를 근본적으로 만들 수 없습니다.

### 정적 링크 vs 동적 링크

*링크*는 컴퓨터 프로그램의 여러 조각을 가져와 조각 간의 참조를 연결하는 과정입니다. _정적_ 링크의 경우 일반적으로 이러한 조각은 _오브젝트 파일_ 또는 _정적 라이브러리_(실제로는 오브젝트 파일의 모음)입니다.

_동적_ 링크의 경우 조각은 *실행 파일*과 _동적 라이브러리_(dylib, shared object, DLL이라고도 함)입니다.

동적 링크와 정적 링크 사이에는 두 가지 핵심적인 차이가 있습니다:

- 링크가 수행되는 시점. 정적 링크는 프로그램을 빌드할 때, 동적 링크는 런타임에 수행됩니다.

- 정적 라이브러리(또는 _아카이브_)는 실제로 개별 오브젝트 파일의 모음인 반면, 동적 라이브러리는 단일체라는 점.

후자가 중요한 이유는 전통적으로 정적 링커가 커맨드 라인에 명시적으로 나열된 모든 오브젝트를 포함하지만, 정적 라이브러리에서는 미해결 심볼 참조를 해결할 수 있는 경우에*만* 오브젝트를 포함하기 때문입니다. 실제로 사용하지 않는 라이브러리에 정적으로 링크하면 전통적인 정적 링커는 해당 라이브러리를 완전히 폐기하고 최종 바이너리에 어떤 코드도 포함하지 않습니다.

실제로는 더 복잡할 수 있습니다. 정적 링커는 실제로 오브젝트 파일의 개별 *섹션*이나 _원자_ 단위로 작업하여 전체 오브젝트가 아닌 개별 함수나 데이터 조각을 폐기할 수 있습니다.

### 정적 링크의 장단점

정적 링크의 장점:

- 런타임 오버헤드가 없습니다.

- 실제로 필요한 라이브러리 코드만 포함합니다.

- 별도로 설치된 동적 라이브러리가 필요 없습니다.

- 런타임 버전 관리 문제가 없습니다.

정적 링크의 단점:

- 프로그램이 코드를 공유할 수 없습니다(전체 메모리 사용량이 높아짐).

- 프로그램을 재빌드하지 않고는 의존성을 업데이트할 수 없습니다.

- 실행 파일이 더 커집니다(별도의 동적 라이브러리를 설치할 필요가 없다는 점으로 상쇄될 수 있음).

특히 Linux에서는 정적 링크를 사용하여 배포판이 제공하는 시스템 라이브러리에 대한 의존성을 완전히 제거할 수 있어, 어떤 배포판에서든 작동하고 단순히 복사하는 것만으로 설치할 수 있는 실행 파일을 만들 수 있습니다.

### SDK 설치

#### (1) 사전 요구 사항

시작하기 전에 다음 요구 사항을 확인하세요:

- swift.org에서 오픈소스 [Swift 도구체인](/install/)을 설치해야 합니다.

- macOS를 사용하는 경우, SDK로 프로그램을 빌드할 때 Xcode에 포함된 도구체인은 사용할 수 없습니다. 대신 오픈소스 도구체인의 Swift 컴파일러를 사용해야 합니다(위 참조).

#### (2) 설치 전 참고사항

다음 사항에 유의하세요:

- 버전 호환성: Swift 도구체인은 설치하는 Static Linux SDK의 버전과 일치해야 합니다.

- 클린 설치: 이전에 다른 Swift 도구체인 버전용 SDK를 설치한 경우, 새 것을 설치하기 전에 이전 것을 제거하세요(아래 관리 명령 참조).

- 체크섬 확인: 원격 URL에서 Swift SDK를 설치할 때 SDK 저자가 제공한 체크섬과 함께 `--checksum` 옵션을 전달해야 합니다.

- 명령 패턴: 설치는 다음 섹션에 설명된 패턴을 따릅니다.

#### (3) Static Linux SDK 다운로드 및 설치

Static Linux SDK를 가져오려면:

- 전체 Static Linux SDK 설치 안내가 있는 swift.org [설치 페이지](https://www.swift.org/install)를 방문하여 직접 다운로드하거나 "설치 명령 복사"를 클릭하세요.

- 이전 릴리스의 경우 설치 페이지에서 "이전 릴리스"로 이동하세요.

#### (4) 설치 명령 패턴

기본 설치 명령은 다음 패턴을 따릅니다:

```console
$ swift sdk install <URL-or-filename-here> [--checksum <checksum-for-archive-URL>]
```

URL(해당 체크섬과 함께) 또는 SDK가 있는 로컬 파일 이름을 제공할 수 있습니다.

<!--
{% assign platform = site.data.builds.swift_releases.last.platforms | where: 'name', 'Static SDK'| first %}
{% assign tag = site.data.builds.swift_releases.last.tag %}
{% assign tag_downcase = site.data.builds.swift_releases.last.tag | downcase %}
{% assign base_url = "https://download.swift.org/" | append: tag_downcase | append: "/static-sdk/" | append: tag | append: "/" | append: tag %}
{% assign command = "swift sdk install " | append: base_url | append: "_static-linux-" | append: platform.version | append: ".artifactbundle.tar.gz --checksum " | append: platform.checksum %}

{% comment %} Generate branch information - ONLY major.minor {% endcomment %}
-->

예를 들어, {{ tag }} 도구체인을 설치한 경우 다음을 입력합니다:

```console
$ {{ command }}
```

이 명령은 시스템에 해당하는 Static Linux SDK를 다운로드하고 설치합니다.

#### (5) 설치된 SDK 관리

설치 후 다음 명령으로 SDK를 관리할 수 있습니다:

설치된 모든 SDK 목록 보기:

```console
$ swift sdk list
```

SDK 제거:

```console
$ swift sdk remove <name-of-SDK>
```

### 첫 번째 정적 링크된 Linux 프로그램

먼저 코드를 담을 디렉토리를 만듭니다:

```console
$ mkdir hello
$ cd hello
```

다음으로 Swift에 새 프로그램 패키지를 만들도록 요청합니다:

```console
$ swift package init --type executable
```

로컬에서 빌드하고 실행할 수 있습니다:

```console
$ swift build
Building for debugging...
[8/8] Applying hello
Build complete! (15.29s)
$ .build/debug/hello
Hello, world!
```

Static Linux SDK가 설치되어 있으면 x86-64 및 ARM64 머신용 Linux 바이너리도 빌드할 수 있습니다:

```console
$ swift build --swift-sdk x86_64-swift-linux-musl
Building for debugging...
[8/8] Linking hello
Build complete! (2.04s)
$ file .build/x86_64-swift-linux-musl/debug/hello
.build/x86_64-swift-linux-musl/debug/hello: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, with debug_info, not stripped
```

```console
$ swift build --swift-sdk aarch64-swift-linux-musl
Building for debugging...
[8/8] Linking hello
Build complete! (2.00s)
$ file .build/aarch64-swift-linux-musl/debug/hello
.build/aarch64-swift-linux-musl/debug/hello: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, with debug_info, not stripped
```

이를 적절한 Linux 기반 시스템에 복사하여 실행할 수 있습니다:

```console
$ scp .build/x86_64-swift-linux-musl/debug/hello linux:~/hello
$ ssh linux ~/hello
Hello, world!
```

### 패키지 의존성은 어떻게 되나요?

Foundation이나 SwiftNIO를 사용하는 Swift 패키지는 별다른 조치 없이 작동합니다. 하지만 C 라이브러리를 사용하는 패키지를 사용하려면 약간의 작업이 필요할 수 있습니다. 이러한 패키지에는 종종 다음과 같은 코드가 있는 파일이 포함되어 있습니다:

```swift
#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#elseif os(Windows)
import ucrt
#else
#error("Unknown platform")
#endif
```

Static Linux SDK는 Glibc를 사용하지 않습니다. 대신 [Musl](https://musl-libc.org)이라는 Linux용 대체 C 라이브러리 위에 구축되었습니다. 이 방법을 선택한 이유는 두 가지입니다:

1. Musl은 정적 링크에 대한 지원이 뛰어납니다.

2. Musl은 허용적 라이선스를 사용하므로 정적으로 링크된 실행 파일을 배포하기 쉽습니다.

이러한 의존성을 사용하는 경우, `Glibc` 모듈 대신 `Musl` 모듈을 import하도록 조정해야 합니다:

```swift
#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif os(Windows)
import ucrt
#else
#error("Unknown platform")
#endif
```

때때로 Musl과 Glibc 사이에 C 라이브러리 타입이 import되는 방식에 차이가 있을 수 있습니다. 이는 누군가 nullability 어노테이션을 추가했거나, 포인터 타입이 실제 정의가 제공되지 않는 전방 선언된 `struct`를 사용하는 경우에 발생합니다. 일반적으로 문제는 명확합니다 — 함수 인수나 결과가 한쪽에서는 `Optional`이고 다른 쪽에서는 비`Optional`이거나, 포인터 타입이 `UnsafePointer<FOO>` 대신 `OpaquePointer`로 import됩니다.

이러한 종류의 조정이 필요한 경우, 패키지 의존성의 [로컬 복사본](https://developer.apple.com/documentation/xcode/editing-a-package-dependency-as-a-local-package)을 편집 가능하게 만들 수 있습니다:

```console
$ swift package edit SomePackage
```

그런 다음 프로그램의 소스 디렉토리에 나타나는 `Packages` 디렉토리의 파일을 편집합니다. 수정 사항에 대해 업스트림 PR을 제출하는 것도 고려해 볼 만합니다.

프로젝트에서 C 또는 C++ 언어 라이브러리를 사용하는 경우 추가 단계가 필요할 수 있습니다. Static SDK for Linux에는 매우 일반적인 소수의 의존성이 포함되어 있습니다(예: [libxml2](https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home), [zlib](https://www.zlib.net/), [curl](https://curl.se/)). SDK 자체에 의존성을 추가하는 데는 높은 기준이 적용되는데, SDK 이미지가 커지고 해당 의존성의 버전을 추적하기 위해 SDK를 업데이트해야 하기 때문입니다.

Static SDK에는 [SPDX 형식](https://spdx.dev/)의 SBOM이 포함되어 있어 Static SDK for Linux의 특정 릴리스에 정확히 무엇이 포함되어 있는지 확인할 수 있습니다. 예를 들어 `bom` 도구를 사용하면 다음과 같은 명령으로 SBOM을 표시할 수 있습니다:

```console
$ bom document outline ~/.swiftpm/swift-sdks/swift-6.1.2-RELEASE-static-linux-0.0.1.artifactbundle/sbom.spdx.json
              _
 ___ _ __   __| |_  __
/ __| '_ \ / _` \ \/ /
\__ \ |_) | (_| |>  <
|___/ .__/ \__,_/_/\_\
    |_|

 📂 SPDX Document SBOM-SPDX-648fa59a-9d9d-476f-9183-78d57d847c31
  │
  │ 📦 DESCRIBES 1 Packages
  │
  ├ Swift statically linked SDK for Linux@0.0.1
  │  │ 🔗 7 Relationships
  │  ├ GENERATED_FROM PACKAGE swift@6.1.2-RELEASE
  │  ├ GENERATED_FROM PACKAGE musl@1.2.5
  │  ├ GENERATED_FROM PACKAGE musl-fts@1.2.7
  │  ├ GENERATED_FROM PACKAGE libxml2@2.12.7
  │  ├ GENERATED_FROM PACKAGE curl@8.7.1
  │  ├ GENERATED_FROM PACKAGE boringssl@fips-20220613
  │  └ GENERATED_FROM PACKAGE zlib@1.3.1
  │
  └ 📄 DESCRIBES 0 Files
```

프로젝트에 추가적인 C/C++ 의존성이 있는 경우, 직접 빌드한 정적 라이브러리를 다른 컨텍스트에서 사용하는 것과 동일한 과정입니다. 정적 라이브러리(`.a` 파일)가 링커의 검색 경로에 있어야 합니다. 또한 라이브러리의 함수를 Swift 코드에서 직접 호출하려면 헤더 파일도 컴파일러의 include 경로에 추가해야 합니다. Swift 특유의 부분은 라이브러리에 대한 모듈 맵이 필요하다는 것뿐이지만, 이는 Static SDK for Linux 외부에서도 마찬가지입니다([Swift와 C++ 혼합 사용](https://www.swift.org/documentation/cxx-interop/) 참고).

Static SDK에 번들된 일부 의존성은 해당 기능을 사용하면 Swift의 런타임 라이브러리에 의해 포함될 수 있습니다 — 예를 들어, Foundation Networking은 `libcurl`을 사용하고 `libcurl`은 `libz`를 사용합니다 — 하지만 정적 링크의 작동 방식 덕분에 일반적으로 "사용한 만큼만 비용을 지불"합니다.

Static SDK에 포함된 라이브러리의 버전을 링커의 검색 경로에서 더 앞에 새 빌드를 배치하여 오버라이드할 수 있습니다. 다만 Static SDK에 포함된 다른 라이브러리가 해당 라이브러리에 대해 빌드된 경우, 새 빌드는 Static SDK에 포함된 버전과 ABI 호환이 되어야 합니다. Static SDK의 다른 라이브러리들이 해당 버전의 헤더를 기준으로 빌드되었기 때문입니다.
