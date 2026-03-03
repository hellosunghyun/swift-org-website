## 패키지 매니저 사용하기

Swift 패키지 매니저는 라이브러리와 실행 파일을 빌드하고,
서로 다른 패키지 간에 코드를 공유하기 위한 규약 기반 시스템을 제공합니다.

이 예제들은 `swift`를 경로에서 사용할 수 있도록 설정했다고 가정합니다.
자세한 내용은 [설치하기](#installing-swift)를 참조하세요.
설정이 완료되면 패키지 매니저 도구를 호출할 수 있습니다: `swift package`, `swift run`, `swift build`, `swift test`.

```shell
$ swift package --help
OVERVIEW: Perform operations on Swift packages
...
```

### 패키지 만들기

새 Swift 패키지를 만들려면 먼저 `Hello`라는 이름의 디렉토리를 만들고 이동합니다:

```shell
$ mkdir Hello
$ cd Hello
```

모든 패키지는 루트 디렉토리에 `Package.swift`라는 매니페스트 파일이 있어야 합니다.
다음 명령으로 `Hello`라는 이름의 최소 패키지를 만들 수 있습니다:

```shell
$ swift package init
```

기본적으로 init 명령은 라이브러리 패키지 디렉토리 구조를 생성합니다:

```shell
├── Package.swift
├── README.md
├── Sources
│   └── Hello
│       └── Hello.swift
└── Tests
    ├── HelloTests
    │   └── HelloTests.swift
    └── LinuxMain.swift
```

`swift build`를 사용하여 패키지를 빌드할 수 있습니다. 이 명령은 매니페스트 파일
`Package.swift`에 명시된 의존성을 다운로드, 해석, 컴파일합니다.

```shell
$ swift build
Compile Swift Module 'Hello' (1 sources)
```

패키지의 테스트를 실행하려면 `swift test`를 사용합니다:

```shell
$ swift test
Compile Swift Module 'HelloTests' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/HelloPackageTests.xctest/Contents/MacOS/HelloPackageTests
Test Suite 'All tests' started at 2016-08-29 08:00:31.453
Test Suite 'HelloPackageTests.xctest' started at 2016-08-29 08:00:31.454
Test Suite 'HelloTests' started at 2016-08-29 08:00:31.454
Test Case '-[HelloTests.HelloTests testExample]' started.
Test Case '-[HelloTests.HelloTests testExample]' passed (0.001 seconds).
Test Suite 'HelloTests' passed at 2016-08-29 08:00:31.455.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.001 (0.001) seconds
Test Suite 'HelloPackageTests.xctest' passed at 2016-08-29 08:00:31.455.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.001 (0.001) seconds
Test Suite 'All tests' passed at 2016-08-29 08:00:31.455.
	 Executed 1 test, with 0 failures (0 unexpected) in 0.001 (0.002) seconds
```

### 실행 파일 빌드하기

`main.swift`라는 이름의 파일을 포함하는 타겟은 실행 파일로 간주됩니다.
패키지 매니저가 해당 파일을 바이너리 실행 파일로 컴파일합니다.

이 예제에서는 "Hello, world!"를 출력하는
`Hello`라는 이름의 실행 파일을 생성합니다.

먼저 `Hello`라는 디렉토리를 만들고 이동합니다:

```shell
$ mkdir Hello
$ cd Hello
```

이제 swift package의 init 명령을 executable 타입으로 실행합니다:

```shell
$ swift package init --type executable
```

`swift run` 명령을 사용하여 실행 파일을 빌드하고 실행합니다:

```shell
$ swift run Hello
Compile Swift Module 'Hello' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/Hello
Hello, world!
```

참고: 이 패키지에 실행 파일이 하나뿐이므로 `swift run` 명령에서
실행 파일 이름을 생략할 수 있습니다.

`swift build` 명령으로 패키지를 컴파일한 다음 .build 디렉토리에서
바이너리를 실행할 수도 있습니다:

```shell
$ swift build
Compile Swift Module 'Hello' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/Hello

$ .build/x86_64-apple-macosx10.10/debug/Hello
Hello, world!
```

다음 단계로, 새 소스 파일에 `sayHello(name:)` 함수를 정의하고
`print(_:)`를 직접 호출하는 대신
실행 파일이 그 함수를 호출하도록 해보겠습니다.

### 여러 소스 파일로 작업하기

`Sources/Hello` 디렉토리에 `Greeter.swift`라는 새 파일을 만들고
다음 코드를 입력합니다:

```swift
func sayHello(name: String) {
    print("Hello, \(name)!")
}
```

`sayHello(name:)` 함수는 하나의 `String` 인수를 받아
"World" 대신 함수 인수로 대체하여
"Hello" 인사를 출력합니다.

이제 `main.swift`를 다시 열고 기존 내용을 다음 코드로 교체합니다:

```swift
if CommandLine.arguments.count != 2 {
    print("Usage: hello NAME")
} else {
    let name = CommandLine.arguments[1]
    sayHello(name: name)
}
```

이전처럼 하드코딩된 이름을 사용하는 대신,
`main.swift`는 이제 커맨드라인 인수를 읽습니다.
그리고 `print(_:)`를 직접 호출하는 대신
`sayHello(name:)` 메서드를 호출합니다.
이 메서드는 `Hello` 모듈의 일부이므로
`import` 문이 필요하지 않습니다.

`swift run`을 실행하여 새 버전의 `Hello`를 사용해 보세요:

```shell
$ swift run Hello `whoami`
```

---

> Swift 패키지 매니저에 대해 더 알아보려면,
> 모듈 빌드, 의존성 임포트, 시스템 라이브러리 매핑 방법을 포함하여,
> 웹사이트의 [Swift 패키지 매니저](/documentation/package-manager) 섹션을 참조하세요.

> 패키지 플러그인에 대해 더 알아보려면 [플러그인 시작하기](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/Plugins.md#getting-started-with-plugins)를 참조하세요.
