## `swiftc` 커맨드로 컴파일하기

`swiftc` 커맨드는 Swift 코드를
운영체제에서 실행 가능한 프로그램으로 컴파일합니다.

    // QUESTION: What is our cross-platform story?

> 특정 머신에서 빌드한 프로그램은
> 같은 하드웨어 아키텍처와 운영체제를 가진 다른 머신에서만 실행할 수 있습니다.
> 예를 들어, x86*64에서 macOS 10.11을 실행하는 컴퓨터에서 빌드한 실행 파일은
> ARMv7에서 Ubuntu를 실행하는 머신에서 직접 실행할 수 없습니다.
> 하지만 같은 *코드\_는 Swift를 지원하는 모든 머신에서
> 컴파일하고 실행할 수 있습니다.

### Hello, world!

전통적으로, 새로운 언어의 첫 번째 프로그램은
화면에 "Hello, world!"를 표시해야 합니다.
Swift에서는 한 줄로 가능합니다.
새 파일 `hello.swift`를 만들고
다음을 입력하세요:

```swift
print("Hello, world!")
```

이제 터미널에서
다음 명령을 입력하세요:

```shell
$ swiftc hello.swift
```

이 명령을 실행하면 새 실행 파일 `hello`가 생성되며,
커맨드라인에서 실행할 수 있습니다:

```shell
$ ./hello
$ Hello, world!
```
