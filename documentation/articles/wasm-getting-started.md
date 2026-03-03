---
layout: page
date: 2025-06-01 12:00:00
title: WebAssembly용 Swift SDK 시작하기
author: [maxdesiatov]
---

[WebAssembly(Wasm)는 이식성, 보안, 성능에 중점을 둔 가상 명령어 집합](https://webassembly.org/)입니다. 개발자는 Wasm용 클라이언트 및 서버 애플리케이션을 빌드한 후 브라우저나 다른 Wasm 런타임 구현에 배포할 수 있습니다.

Swift의 WebAssembly 지원은 커뮤니티 프로젝트로 시작되었습니다. 모든 명령어 집합은 표준화된 ABI와 시스템 인터페이스로부터 큰 이점을 얻으며, Swift의 Wasm 지원은 처음부터 [WebAssembly System Interface](https://wasi.dev/)를 대상으로 했기 때문에 이 플랫폼에 Swift 코어 라이브러리를 포팅하기가 훨씬 쉬웠습니다.

Swift 6.2 및 개발 스냅샷부터 [swift.org](/download)에서 배포되는 Wasm용 Swift SDK로 Wasm 모듈을 쉽게 크로스 컴파일하고 실행할 수 있습니다.
배포되는 아티팩트 번들에는 실험적인 Embedded Swift 모드에 대한 지원도 포함되어 있습니다.

## 설치

{% assign last_release = site.data.builds.swift_releases.last %}
{% assign platform = last_release.platforms | where: 'name', 'Wasm SDK'| first %}
{% assign release_name = last_release.name %}
{% assign tag = last_release.tag %}
{% assign tag_downcase = last_release.tag | downcase %}

{% assign base_url = "https://download.swift.org/" | append: tag_downcase | append: "/wasm-sdk/" | append: tag | append: "/" | append: tag %}
{% assign command = "swift sdk install " | append: base_url | append: "_wasm.artifactbundle.tar.gz --checksum " | append: platform.checksum %}

이 단계는 최신 Xcode가 이미 설치되어 있더라도 macOS에서 필요합니다. Windows 호스트에서의 Swift SDK 크로스 컴파일은 [아직 지원되지 않습니다](https://github.com/swiftlang/swift-package-manager/issues/9148).

1. 빌드할 플랫폼에 맞는 [설치 안내에 따라 `swiftly`를 설치](/install/)합니다.

2. `swiftly install {{ release_name }}`으로 Swift {{ release_name }}을 설치합니다.

3. `swiftly use {{ release_name }}`으로 설치한 툴체인을 선택합니다.

4. 터미널에서 다음 명령을 실행하여 Wasm용 Swift SDK를 설치합니다.

   ```
   {{ command }}
   ```

5. `swift sdk list`를 실행하여 Swift SDK가 설치되었는지 확인하고 출력에서 ID를 기록해 둡니다. 두 개의 Swift SDK가 설치됩니다. 하나는 모든 Swift 기능을 지원하고, 다른 하나는 실험적인 [Embedded Swift 모드](#embedded-swift-support)에서 허용되는 기능의 하위 집합을 지원합니다.

   |          Swift SDK ID           |                                            설명                                            |
   | :-----------------------------: | :----------------------------------------------------------------------------------------: |
   |     `swift-<version>_wasm`      |                                    모든 Swift 기능 지원                                    |
   | `swift-<version>_wasm-embedded` | 실험적인 [Embedded Swift 모드](#embedded-swift-support)에서 허용되는 기능의 하위 집합 지원 |

6. 향후 `swiftly`로 새 버전의 툴체인을 설치하거나 선택한 후에는 정확히 일치하는 Swift SDK 버전을 설치하고 사용해야 합니다.

## 빌드 및 실행

Swift SDK를 실제로 사용해 보기 위해 간단한 패키지를 만들어 봅시다:

```
mkdir Hello
cd Hello
swift package init --type executable
```

새로 생성된 `Sources/Hello/Hello.swift` 파일을 수정하여 대상 플랫폼에 따라 다른 문자열을 출력하도록 합니다:

```swift
@main
struct wasi_test {
    static func main() {
#if os(WASI)
        print("Hello from WASI!")
#else
        print("Hello from the host system!")
#endif
    }
}
```

위 [설치 섹션](#installation)의 5단계에서 확인한 ID를 대입하여 다음 명령으로 패키지를 빌드합니다.

```
swift build --swift-sdk {{ tag }}_wasm
```

Wasm용 Swift SDK와 호환되는 최신 툴체인 스냅샷에는 `swift run`이 실행을 위임할 수 있는 Wasm 런타임인 [WasmKit](https://github.com/swiftwasm/wasmkit/)도 포함되어 있습니다. 방금 빌드한 모듈을 실행하려면 같은 `--swift-sdk` 옵션으로 `swift run`을 사용합니다:

```
swift run --swift-sdk {{ tag }}_wasm
```

다음과 같은 출력을 볼 수 있습니다:

```
[1/1] Planning build
Building for debugging...
[8/8] Linking Hello.wasm
Build of product 'Hello' complete! (1.31s)
Hello from WASI!
```

## Embedded Swift 지원

[Embedded Swift](https://github.com/swiftlang/swift-evolution/blob/main/visions/embedded-swift.md)는 툴체인이 수 배 더 작은 Wasm 바이너리를 생성할 수 있게 하는 실험적인 [언어 하위 집합](https://docs.swift.org/embedded/documentation/embedded/languagesubset)입니다. `swift sdk install` 명령으로 설치한 아티팩트 번들의 Swift SDK 중 하나는 Embedded Swift 전용으로 맞춤 제작되었습니다.

Embedded Swift SDK로 빌드하려면 `swift sdk list` 출력에서 확인한 ID(`-embedded` 접미사가 붙은 것)를 `--swift-sdk` 옵션에 전달합니다. 예시:

```
swift build --swift-sdk {{ tag }}_wasm-embedded
```

또는

```
swift run --swift-sdk {{ tag }}_wasm-embedded
```

## 에디터 설정

이 섹션에서는 이전 섹션에서 설치한 Swift SDK를 사용하여 Swift WebAssembly 개발을 위한 개발 환경을 구성하는 방법을 안내합니다.

### Visual Studio Code

아직 VSCode에서 Swift 개발을 설정하지 않았다면, [VS Code에서 Swift 개발 환경 구성 가이드](/documentation/articles/getting-started-with-vscode-swift/)를 참고하세요.

**WebAssembly용 VSCode 구성:**

1. VSCode에서 Swift 패키지를 엽니다.

2. Command Palette(macOS: `Cmd + Shift + P`, 기타 플랫폼: `Ctrl + Shift + P`)를 열고 `Swift: Select Toolchain...`을 선택합니다.

3. 목록에서 Swift 툴체인을 선택합니다(`swiftly`로 설치한 버전과 일치해야 합니다).

4. 프롬프트가 나타나면 **Workspace Settings**에 툴체인 설정을 저장합니다. 이렇게 하면 `.vscode/settings.json`의 `swift.path` 설정이 생성되거나 업데이트됩니다.

5. 프로젝트 루트에 `.sourcekit-lsp/config.json` 파일을 생성합니다:

   ```json
   {
     "swiftPM": {
       "swiftSDK": "{{ tag }}_wasm"
     }
   }
   ```

   `{{ tag }}_wasm`을 `swift sdk list` 출력의 정확한 Swift SDK ID로 교체하세요. Embedded Swift를 사용하는 경우 `{{ tag }}_wasm-embedded`를 사용합니다.

6. Command Palette에서 `Developer: Reload Window`로 VSCode를 다시 로드합니다.

### 기타 에디터

Swift용 LSP 지원이 이미 설정된 다른 에디터(Vim, Neovim, Emacs 등)의 경우:

1. 에디터가 올바른 Swift 툴체인(`swiftly`로 설치한 것)을 사용하고 있는지 확인합니다.

2. 프로젝트 루트에 `.sourcekit-lsp/config.json` 파일을 생성합니다:

   ```json
   {
     "swiftPM": {
       "swiftSDK": "{{ tag }}_wasm"
     }
   }
   ```

   `{{ tag }}_wasm`을 `swift sdk list`의 Swift SDK ID로 교체하세요. Embedded Swift의 경우 `{{ tag }}_wasm-embedded`를 사용합니다.

Swift LSP 초기 설정 가이드는 다음을 참고하세요:

- [Neovim으로 Swift 시작하기](/documentation/articles/zero-to-swift-nvim/)
- [Emacs로 Swift 시작하기](/documentation/articles/zero-to-swift-emacs/)
