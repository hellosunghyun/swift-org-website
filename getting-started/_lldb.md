## LLDB 디버거 사용하기

LLDB 디버거를 사용하여
Swift 프로그램을 단계별로 실행하고,
브레이크포인트를 설정하고,
프로그램 상태를 검사하고 수정할 수 있습니다.

예시로,
`factorial(n:)` 함수를 정의하고
그 함수를 호출한 결과를 출력하는
다음 Swift 코드를 살펴보겠습니다:

```swift
func factorial(n: Int) -> Int {
    if n <= 1 { return n }
    return n * factorial(n: n - 1)
}

let number = 4
print("\(number)! is equal to \(factorial(n: number))")
```

위 코드로 `Factorial.swift`라는 파일을 만들고
디버그 정보를 생성하기 위한 `-g` 옵션과 함께
파일명을 커맨드라인 인수로 전달하여
`swiftc` 명령을 실행합니다.
현재 디렉토리에 `Factorial`이라는 실행 파일이 생성됩니다.

```shell
$ swiftc -g Factorial.swift
$ ls
Factorial.dSYM
Factorial.swift
Factorial*
```

`Factorial` 프로그램을 직접 실행하는 대신,
`lldb` 명령에 커맨드라인 인수로 전달하여
LLDB 디버거를 통해 실행합니다.

```text
$ lldb Factorial
(lldb) target create "Factorial"
Current executable set to 'Factorial' (x86_64).
```

이렇게 하면 LLDB 명령을 실행할 수 있는
대화형 콘솔이 시작됩니다.

> LLDB 명령에 대한 자세한 내용은
> [LLDB 튜토리얼](http://lldb.llvm.org/tutorial.html)을 참조하세요.

`breakpoint set`(`b`) 명령으로
`factorial(n:)` 함수의 2번째 줄에 브레이크포인트를 설정하여
함수가 실행될 때마다 프로세스가 멈추도록 합니다.

```text
(lldb) b 2
Breakpoint 1: where = Factorial`Factorial.factorial (Swift.Int) -> Swift.Int + 12 at Factorial.swift:2, address = 0x0000000100000e7c
```

`run`(`r`) 명령으로 프로세스를 실행합니다.
`factorial(n:)` 함수의 호출 지점에서 프로세스가 멈춥니다.

```text
(lldb) r
Process 40246 resuming
Process 40246 stopped
* thread #1: tid = 0x14dfdf, 0x0000000100000e7c Factorial`Factorial.factorial (n=4) -> Swift.Int + 12 at Factorial.swift:2, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100000e7c Factorial`Factorial.factorial (n=4) -> Swift.Int + 12 at Factorial.swift:2
   1    func factorial(n: Int) -> Int {
-> 2        if n <= 1 { return n }
   3        return n * factorial(n: n - 1)
   4    }
   5
   6    let number = 4
   7    print("\(number)! is equal to \(factorial(n: number))")
```

`print`(`p`) 명령으로
`n` 매개변수의 값을 확인합니다.

```text
(lldb) p n
(Int) $R0 = 4
```

`print` 명령은 Swift 표현식을 평가할 수도 있습니다.

```text
(lldb) p n * n
(Int) $R1 = 16
```

`backtrace`(`bt`) 명령으로
`factorial(n:)`이 호출되기까지의 프레임을 확인합니다.

```text
(lldb) bt
* thread #1: tid = 0x14e393, 0x0000000100000e7c Factorial`Factorial.factorial (n=4) -> Swift.Int + 12 at Factorial.swift:2, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x0000000100000e7c Factorial`Factorial.factorial (n=4) -> Swift.Int + 12 at Factorial.swift:2
    frame #1: 0x0000000100000daf Factorial`main + 287 at Factorial.swift:7
    frame #2: 0x00007fff890be5ad libdyld.dylib`start + 1
    frame #3: 0x00007fff890be5ad libdyld.dylib`start + 1
```

`continue`(`c`) 명령으로
브레이크포인트에 다시 도달할 때까지 프로세스를 재개합니다.

```text
(lldb) c
Process 40246 resuming
Process 40246 stopped
* thread #1: tid = 0x14e393, 0x0000000100000e7c Factorial`Factorial.factorial (n=3) -> Swift.Int + 12 at Factorial.swift:2, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100000e7c Factorial`Factorial.factorial (n=3) -> Swift.Int + 12 at Factorial.swift:2
   1    func factorial(n: Int) -> Int {
-> 2        if n <= 1 { return n }
   3        return n * factorial(n: n - 1)
   4    }
   5
   6    let number = 4
   7    print("\(number)! is equal to \(factorial(n: number))")
```

`print`(`p`) 명령을 다시 사용하여
두 번째 `factorial(n:)` 호출의 `n` 매개변수 값을 확인합니다.

```text
(lldb) p n
(Int) $R2 = 3
```

`breakpoint disable`(`br di`) 명령으로
모든 브레이크포인트를 비활성화하고,
`continue`(`c`) 명령으로
프로세스가 종료될 때까지 실행합니다.

```text
(lldb) br di
All breakpoints disabled. (1 breakpoints)
(lldb) c
Process 40246 resuming
4! is equal to 24
Process 40246 exited with status = 0 (0x00000000)
```
