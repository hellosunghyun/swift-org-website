## REPL 사용하기

`swift repl`을 다른 인수 없이 실행하면
REPL이 시작됩니다. REPL은 대화형 셸로,
입력한 Swift 코드를 읽고, 실행하고,
결과를 출력합니다.

```shell
$ swift repl
Welcome to Apple Swift version 5.7 (swiftlang-5.7.0.127.4 clang-1400.0.29.50).
Type :help for assistance.
  1>
```

REPL은 Swift를 실험해 보기에 좋은 방법입니다.
예를 들어, `1 + 2` 표현식을 입력하면
결과값 `3`이 다음 줄에 출력됩니다:

```shell
  1> 1 + 2
$R0: Int = 3
```

상수와 변수에 값을 할당하고
이후 줄에서 사용할 수 있습니다.
예를 들어, `String` 값 `Hello!`를
상수 `greeting`에 할당한 다음
`print(_:)` 함수의 인수로 전달할 수 있습니다:

```shell
  2> let greeting = "Hello!"
greeting: String = "Hello!"
  3> print(greeting)
Hello!
```

잘못된 표현식을 입력하면
REPL이 문제가 발생한 위치를 보여주는 오류를 출력합니다:

```shell
let answer = "forty"-"two"
error: binary operator '-' cannot be applied to two 'String' operands
let answer = "forty"-"two"
             ~~~~~~~^~~~~~
```

위쪽 화살표와 아래쪽 화살표 키(`↑`, `↓`)를 사용하여
REPL에 이전에 입력한 줄을 탐색할 수 있습니다.
이를 통해 전체 줄을 다시 입력하지 않고도
이전 표현식을 약간 수정할 수 있어,
앞의 예시처럼 오류를 수정할 때 특히 편리합니다:

```shell
let answer = "forty-two"
answer: String = "forty-two"
```

REPL의 또 다른 유용한 기능은
특정 컨텍스트에서 사용할 수 있는 함수와 메서드를
자동으로 제안하는 것입니다.
예를 들어, `String` 값의 점 연산자 뒤에 `re`를 입력한 후
탭 키(`⇥`)를 누르면
`remove(at:)`나 `replaceSubrange(bounds:with:)` 같은
사용 가능한 자동 완성 목록이 표시됩니다:

```shell
5> "Hi!".re⇥
Available completions:
	remove(at: Index) -> Character
	removeAll() -> Void
	removeAll(keepingCapacity: Bool) -> Void
	removeSubrange(bounds: ClosedRange<Index>) -> Void
	removeSubrange(bounds: Range<Index>) -> Void
	replaceSubrange(bounds: ClosedRange<Index>, with: C) -> Void
	replaceSubrange(bounds: ClosedRange<Index>, with: String) -> Void
	replaceSubrange(bounds: Range<Index>, with: C) -> Void
	replaceSubrange(bounds: Range<Index>, with: String) -> Void
	reserveCapacity(n: Int) -> Void
```

`for-in` 루프로 배열을 반복하는 것처럼
코드 블록을 시작하면
REPL이 자동으로 다음 줄을 들여쓰기하고,
프롬프트 문자를 `>`에서 `.`으로 변경하여
해당 줄에 입력한 코드가
전체 코드 블록이 실행될 때만 평가됨을 나타냅니다.

```shell
  6> let numbers = [1,2,3]
numbers: [Int] = 3 values {
  [0] = 1
  [1] = 2
  [2] = 3
}
  7> for n in numbers.reversed() {
  8.     print(n)
  9. }
3
2
1
```

제어 흐름 문 작성부터 구조체와 클래스의
선언 및 인스턴스화까지, Swift의 모든 기능을
REPL에서 사용할 수 있습니다.

macOS에서는 `Darwin`, Linux에서는 `Glibc` 같은
사용 가능한 시스템 모듈을 임포트할 수도 있습니다:

### macOS에서

```swift
1> import Darwin
2> arc4random_uniform(10)
$R0: UInt32 = 4
```

### Linux에서

```swift
1> import Glibc
2> random() % 10
$R0: Int32 = 4
```

### Windows에서

REPL은 Python 바인딩에 의존합니다. Python 3.7이 경로에서
사용 가능한지 확인해야 합니다. 다음 명령은 Visual Studio의
Python 3.7을 `%PATH%`에 추가하여 사용할 수 있게 합니다:

```cmd
path %ProgramFiles(x86)%\Microsoft Visual Studio\Shared\Python37_64;%PATH%
```

Windows 설치는 SDK와 툴체인을 분리하므로
REPL에 몇 가지 추가 매개변수를 전달해야 합니다.
이를 통해 같은 툴체인에서 여러 다른 SDK를 사용할 수 있습니다.

```cmd
set SWIFTFLAGS=-sdk %SDKROOT% -I %SDKROOT%/usr/lib/swift -L %SDKROOT%/usr/lib/swift/windows
swift repl -target x86_64-unknown-windows-msvc %SWIFTFLAGS%
```
