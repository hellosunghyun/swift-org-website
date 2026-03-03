---
layout: page
title: 커맨드라인 도구 만들기
---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/apple/swift-getting-started-cli)에서 확인할 수 있습니다.

{% include getting-started/_installing.md %}

## 프로젝트 생성

새로 구성한 Swift 개발 환경으로 간단한 애플리케이션을 만들어 보겠습니다.
먼저 SwiftPM을 사용해 새 프로젝트를 생성합니다. 터미널에서 다음 명령을 실행하세요:

```bash
$ mkdir MyCLI
$ cd MyCLI
$ swift package init --name MyCLI --type executable
```

이 명령은 다음과 같은 파일 구조의 MyCLI 디렉터리를 생성합니다:

```no-highlight
.
├── Package.swift
└── Sources
    └── main.swift
```

`Package.swift`는 Swift의 매니페스트 파일입니다. 프로젝트의 메타데이터와 의존성 정보를 관리하는 곳입니다.

`Sources/main.swift`는 애플리케이션의 진입점이자, 애플리케이션 코드를 작성할 파일입니다.

SwiftPM이 "Hello, world!" 프로젝트를 자동으로 생성해 줍니다!

터미널에서 `swift run`을 실행하면 프로그램을 바로 실행할 수 있습니다.

```bash
$ swift run MyCLI
Building for debugging...
[3/3] Linking MyCLI
Build complete! (0.68s)
Hello, world!
```

## 의존성 추가

Swift 기반 애플리케이션은 보통 유용한 기능을 제공하는 라이브러리들로 구성됩니다.

이 프로젝트에서는 ASCII 아트를 만들어 주는 [example-package-figlet](https://github.com/apple/example-package-figlet) 패키지를 사용하겠습니다.

더 다양한 라이브러리는 Swift의 비공식 패키지 인덱스인 [Swift Package Index](https://swiftpackageindex.com)에서 찾아볼 수 있습니다.

`Package.swift` 파일에 다음과 같이 의존성 정보를 추가합니다:

```swift
// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCLI",
    dependencies: [
      .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MyCLI",
            dependencies: [
                .product(name: "Figlet", package: "example-package-figlet"),
            ],
            path: "Sources"),
    ]
)
```

`swift build`를 실행하면 SwiftPM이 새 의존성을 다운로드한 후 코드를 빌드합니다.

이 명령을 실행하면 `Package.resolved`라는 파일도 생성됩니다.
이 파일은 현재 로컬에서 사용 중인 의존성의 정확한 버전을 기록한 스냅샷입니다.

## 간단한 애플리케이션

먼저 `main.swift`를 삭제합니다. 그 자리에 `MyCLI.swift`라는 새 파일을 만들고 다음 코드를 추가하세요:

```swift
import Figlet

@main
struct FigletTool {
  static func main() {
    Figlet.say("Hello, Swift!")
  }
}
```

이렇게 하면 필요에 따라 비동기로도 동작할 수 있는 새로운 앱 진입점이 만들어집니다. `main.swift` 파일과 `@main` 진입점 중 하나만 사용할 수 있으며, 둘 다 동시에 사용할 수는 없습니다.

`import Figlet`을 통해 `example-package-figlet` 패키지가 제공하는 `Figlet` 모듈을 사용할 수 있습니다.

저장한 후 `swift run`으로 애플리케이션을 실행하면,
문제없이 실행되었다면 화면에 다음과 같이 출력됩니다:

```no-highlight
  _   _          _   _                 ____               _    __   _     _
 | | | |   ___  | | | |   ___         / ___|  __      __ (_)  / _| | |_  | |
 | |_| |  / _ \ | | | |  / _ \        \___ \  \ \ /\ / / | | | |_  | __| | |
 |  _  | |  __/ | | | | | (_) |  _     ___) |  \ V  V /  | | |  _| | |_  |_|
 |_| |_|  \___| |_| |_|  \___/  ( )   |____/    \_/\_/   |_| |_|    \__| (_)
                                |/
```

## 인자 파싱

대부분의 커맨드라인 도구는 커맨드라인 인자를 파싱할 수 있어야 합니다.

이 기능을 추가하기 위해 [swift-argument-parser](https://github.com/apple/swift-argument-parser) 의존성을 추가합니다.

`Package.swift` 파일을 다음과 같이 수정합니다:

```swift
// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCLI",
    dependencies: [
      .package(url: "https://github.com/apple/example-package-figlet", branch: "main"),
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MyCLI",
            dependencies: [
                .product(name: "Figlet", package: "example-package-figlet"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources"),
    ]
)
```

이제 `swift-argument-parser`가 제공하는 인자 파싱 모듈을 import하여 애플리케이션에서 사용할 수 있습니다:

```swift
import Figlet
import ArgumentParser

@main
struct FigletTool: ParsableCommand {
  @Option(help: "Specify the input")
  public var input: String

  public func run() throws {
    Figlet.say(self.input)
  }
}
```

[swift-argument-parser](https://github.com/apple/swift-argument-parser)의 커맨드라인 옵션 파싱 방법에 대한 자세한 내용은 [swift-argument-parser 문서](https://github.com/apple/swift-argument-parser)를 참고하세요.

저장한 후 `swift run MyCLI --input 'Hello, world!'`로 애플리케이션을 실행합니다.

이 경우 실행 파일 이름을 명시해야 `input` 인자를 전달할 수 있습니다.

문제없이 실행되었다면 화면에 다음과 같이 출력됩니다:

```no-highlight
  _   _          _   _                                           _       _   _
 | | | |   ___  | | | |   ___         __      __   ___    _ __  | |   __| | | |
 | |_| |  / _ \ | | | |  / _ \        \ \ /\ / /  / _ \  | '__| | |  / _` | | |
 |  _  | |  __/ | | | | | (_) |  _     \ V  V /  | (_) | | |    | | | (_| | |_|
 |_| |_|  \___| |_| |_|  \___/  ( )     \_/\_/    \___/  |_|    |_|  \__,_| (_)
                                |/
```

---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/apple/swift-getting-started-cli)에서 확인할 수 있습니다.
