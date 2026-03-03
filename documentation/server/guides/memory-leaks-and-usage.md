---
redirect_from: 'server/guides/memory-leaks-and-usage'
layout: page
title: 메모리 누수 및 사용량 디버깅
---

# 개요

메모리 누수 및 사용량 디버깅은 애플리케이션의 메모리 관리와 관련된 문제를 식별하고 해결하는 데 도움이 됩니다. 메모리 누수는 메모리가 할당되었지만 적절히 해제되지 않을 때 발생하며, 시간이 지남에 따라 메모리 사용량이 점진적으로 증가합니다. 이는 애플리케이션의 성능과 안정성에 심각한 영향을 미칠 수 있습니다.

그러나 시간이 지남에 따라 메모리 사용량이 점진적으로 증가한다고 해서 항상 누수를 의미하지는 않습니다. 오히려 애플리케이션의 메모리 프로파일일 수 있습니다. 예를 들어, 애플리케이션의 캐시가 점진적으로 채워질 때 동일한 점진적 메모리 증가를 보여줍니다. 따라서 캐시가 지정된 한도를 초과하지 않도록 구성하면 메모리 사용량이 안정화됩니다. 또한 할당자 라이브러리는 성능이나 기타 이유로 메모리를 즉시 시스템에 반환하지 않을 수 있지만, 시간이 지나면 안정화됩니다.

## 도구와 기법

macOS와 Linux 환경에서 Swift의 메모리 누수를 디버깅하는 것은 서로 다른 도구와 기법을 사용하여 수행할 수 있으며, 각각 고유한 강점과 사용성을 가지고 있습니다.

### 기본 문제 해결 방법:

- 프로파일링 도구 사용
- 코드 검토 및 잠재적 누수 식별
- 디버그 메모리 할당 기능 활성화

**1. 프로파일링 도구 사용**: 각 운영 체제와 개발 환경에서 제공하는 메모리 사용량 분석 도구를 활용합니다.

_macOS의 경우_: [Memory Graph Debugger](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use#Inspect-the-debug-memory-graph)와 [메모리 문제 감지 및 진단](https://developer.apple.com/videos/play/wwdc2021/10180/) 영상이 도움이 됩니다. [Xcode Instruments](https://help.apple.com/instruments/mac/10.0/#/dev022f987b) 도구에서 [Allocations instrument](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use#Profile-your-app-using-the-Allocations-instrument)를 포함한 다양한 프로파일링 기능을 사용하여 Swift 코드의 메모리 할당 및 해제를 추적할 수도 있습니다.

_Linux의 경우_: [Valgrind](https://valgrind.org/)나 [Heaptrack](https://github.com/KDE/heaptrack)과 같은 도구를 사용하여 아래 예제와 같이 애플리케이션을 프로파일링할 수 있습니다. 이러한 도구는 주로 C/C++ 코드용이지만 Swift에서도 사용할 수 있습니다.

**2. 코드 검토 및 잠재적 누수 식별**: 메모리 누수가 발생할 수 있는 잠재적 영역을 찾기 위해 코드를 검토합니다. 일반적인 누수 원인에는 참조 유지나 균형이 맞지 않는 retain-release 순환이 있지만, Swift는 [자동 참조 카운팅(ARC)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/)을 수행하므로 이런 경우가 드뭅니다.

> 참고: Swift에서 객체 간에 클로저를 포함하는 상당한 참조 순환이 있거나 객체가 적절히 해제되지 않는 외부 리소스에 대한 참조를 보유하는 경우 메모리 누수가 발생할 수 있습니다. 그러나 자동 메모리 관리가 참조를 추가하고 제거하는 능력을 통해 이러한 문제의 가능성이 크게 줄어들어, 참조 유지 및 균형이 맞지 않는 retain-release 순환과 같은 누수 원인이 Swift 코드에서 덜 흔합니다.

**3. 디버그 메모리 할당 기능 활성화**: 객체와 메모리 할당에 대한 추가 정보를 얻을 수 있습니다.

_macOS의 경우_: Xcode를 사용하여 Zombie Objects를 활성화하거나 [MallocStackLogging](https://developer.apple.com/videos/play/wwdc2022/10106/)을 사용하여 과도하게 해제되거나 이미 해제된 객체에 접근하는 경우를 감지할 수 있습니다.

Zombie Objects를 활성화하려면:

1. Xcode 프로젝트를 엽니다.
2. 도구 모음의 스킴 드롭다운을 클릭하여 **Edit Scheme** 메뉴로 이동합니다.
3. 스킴 편집기 창에서 **Run** 탭을 선택합니다.
4. **Diagnostics** 탭을 선택합니다.
5. **Memory Management**에서 **Enable Zombie Objects** 옆의 체크박스를 선택합니다.

_Linux의 경우_: Swift는 Address Sanitizer를 사용하여 활성화할 수 있는 내장 LeakSanitizer 지원을 제공합니다. 자세한 내용은 [LeakSanitizer로 누수 디버깅](#leaksanitizer로-누수-디버깅) 섹션을 참고하세요.

## 문제 해결

이 섹션에서는 **Valgrind**, **LeakSanitizer**, **Heaptrack**을 사용하여 누수 및 사용량을 디버깅하는 유용한 서버사이드 문제 해결 기법을 제공합니다.

다음 **예제 프로그램**은 메모리를 누수합니다. 아래에 언급된 다양한 문제 해결 방법을 *설명하기 위한 예제*로만 사용합니다.

```
public class MemoryLeaker {
   var closure: () -> Void = { () }

   public init() {}

   public func doNothing() {}

   public func doSomethingThatLeaks() {
      self.closure = {
         // This will leak as it'll create a permanent reference cycle:
         //
         //     self -> self.closure -> self
         self.doNothing()
      }
   }
}
@inline(never) // just to be sure to get this in a stack trace
func myFunctionDoingTheAllocation() {
   let thing = MemoryLeaker()
   thing.doSomethingThatLeaks()
}

myFunctionDoingTheAllocation()
```

### Valgrind로 누수 디버깅

Valgrind는 Linux 애플리케이션을 디버깅하고 프로파일링하기 위한 오픈소스 프레임워크입니다. Memcheck를 포함한 여러 도구를 제공하며, 메모리 누수, 잘못된 메모리 접근 및 기타 메모리 오류를 감지할 수 있습니다. Valgrind는 주로 C/C++ 애플리케이션에 초점을 맞추지만 Linux의 Swift에서도 사용할 수 있습니다.

Linux에서 Swift의 메모리 누수를 Valgrind로 디버깅하려면 시스템에 설치하세요.

1. Linux 시스템에 Swift를 설치합니다. [공식 웹사이트](https://swift.org/download/)에서 Swift를 다운로드하고 설치할 수 있습니다.
2. 패키지 관리자를 사용하여 Linux 시스템에 Valgrind를 설치합니다. 예를 들어 Ubuntu를 사용하는 경우 다음 명령을 실행할 수 있습니다:

```
sudo apt-get install valgrind
```

3. Valgrind가 설치되면 다음 명령을 실행합니다:

```
valgrind --leak-check=full swift run
```

`valgrind` 명령은 프로그램에서 메모리 누수를 분석하고, 아래와 같이 할당이 발생한 스택 트레이스를 포함한 관련 정보를 보여줍니다:

```
==1== Memcheck, a memory error detector
==1== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==1== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==1== Command: ./test
==1==
==1==
==1== HEAP SUMMARY:
==1==     in use at exit: 824 bytes in 4 blocks
==1==   total heap usage: 5 allocs, 1 frees, 73,528 bytes allocated
==1==
==1== 32 bytes in 1 blocks are definitely lost in loss record 1 of 4
==1==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==1==    by 0x52076B1: swift_slowAlloc (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x5207721: swift_allocObject (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x108E58: $s4test12MemoryLeakerCACycfC (in /tmp/test)
==1==    by 0x10900E: $s4test28myFunctionDoingTheAllocationyyF (in /tmp/test)
==1==    by 0x108CA3: main (in /tmp/test)
==1==
==1== LEAK SUMMARY:
==1==    definitely lost: 32 bytes in 1 blocks
==1==    indirectly lost: 0 bytes in 0 blocks
==1==      possibly lost: 0 bytes in 0 blocks
==1==    still reachable: 792 bytes in 3 blocks
==1==         suppressed: 0 bytes in 0 blocks
==1== Reachable blocks (those to which a pointer was found) are not shown.
==1== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==1==
==1== For counts of detected and suppressed errors, rerun with: -v
==1== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)
```

다음 트레이스 블록(위에서 발췌)은 메모리 누수를 나타냅니다.

```
==1== 32 bytes in 1 blocks are definitely lost in loss record 1 of 4
==1==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==1==    by 0x52076B1: swift_slowAlloc (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x5207721: swift_allocObject (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x108E58: $s4test12MemoryLeakerCACycfC (in /tmp/test)
==1==    by 0x10900E: $s4test28myFunctionDoingTheAllocationyyF (in /tmp/test)
==1==    by 0x108CA3: main (in /tmp/test)
```

그러나 Swift는 함수 및 심볼 이름에 네임 맹글링을 사용하므로 스택 트레이스를 이해하기 어려울 수 있습니다.

스택 트레이스에서 Swift 심볼을 디맹글하려면 `swift demangle` 명령을 실행합니다:

```
swift demangle <mangled_symbol>
```

`<mangled_symbol>`을 스택 트레이스에 표시된 맹글된 심볼 이름으로 교체합니다. 예를 들어:

`swift demangle $s4test12MemoryLeakerCACycfC`

**참고:** `swift demangle`은 Swift 명령줄 유틸리티이며 Swift 툴체인이 설치되어 있으면 사용할 수 있습니다.

이 유틸리티는 심볼을 디맹글하여 다음과 같이 사람이 읽을 수 있는 버전을 표시합니다:

```
==1== 32 bytes in 1 blocks are definitely lost in loss record 1 of 4
==1==    at 0x4C2FB0F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==1==    by 0x52076B1: swift_slowAlloc (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x5207721: swift_allocObject (in /usr/lib/swift/linux/libswiftCore.so)
==1==    by 0x108E58: test.MemoryLeaker.__allocating_init() -> test.MemoryLeaker (in /tmp/test)
==1==    by 0x10900E: test.myFunctionDoingTheAllocation() -> () (in /tmp/test)
==1==    by 0x108CA3: main (in /tmp/test)
```

디맹글된 심볼을 분석하면 코드의 어떤 부분이 메모리 누수를 일으키는지 이해할 수 있습니다. 이 예제에서 `valgrind` 명령은 누수된 할당이 다음에서 발생했음을 나타냅니다:

`test.myFunctionDoingTheAllocation`이 `test.MemoryLeaker.__allocating_init()`을 호출

#### 제한 사항

- `valgrind` 명령은 `String`이나 연관 값이 있는 `enum`과 같은 많은 Swift 데이터 타입에서 사용되는 비트 패킹을 이해하지 못합니다. 따라서 `valgrind` 명령은 때때로 존재하지 않는 메모리 오류나 누수를 보고하며, 실제 문제를 감지하지 못하는 위음성이 발생하기도 합니다.
- `valgrind` 명령은 프로그램을 매우 느리게 실행하며(100배 이상 느릴 수 있음), 이로 인해 문제를 재현하고 성능을 분석하는 능력이 저하될 수 있습니다.
- Valgrind는 주로 Linux에서 지원됩니다. macOS나 iOS와 같은 다른 플랫폼에 대한 지원은 제한적이거나 없을 수 있습니다.

### LeakSanitizer로 누수 디버깅

LeakSanitizer는 [AddressSanitizer](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early)에 통합된 메모리 누수 감지기입니다. Address Sanitizer가 활성화된 상태에서 LeakSanitizer를 사용하여 Swift의 메모리 누수를 디버깅하려면, 적절한 환경 변수를 설정하고, 필요한 옵션으로 Swift 패키지를 컴파일한 후 애플리케이션을 실행해야 합니다.

단계는 다음과 같습니다:

1. 터미널 세션을 열고 Swift 패키지 디렉터리로 이동합니다.
2. `ASAN_OPTIONS` 환경 변수를 설정하여 AddressSanitizer를 활성화하고 동작을 구성합니다. 다음 명령을 실행하여 설정할 수 있습니다:

```
export ASAN_OPTIONS=detect_leaks=1
```

3. [Address Sanitizer](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early)를 활성화하는 추가 옵션과 함께 `swift build`를 실행합니다:

```
swift build --sanitize=address
```

빌드 프로세스는 AddressSanitizer가 활성화된 상태로 코드를 컴파일하며, 자동으로 누수된 메모리 블록을 찾습니다. 빌드 중 메모리 누수가 감지되면 아래 예제와 같이 정보를 출력합니다(Valgrind와 유사):

```
=================================================================
==478==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 32 byte(s) in 1 object(s) allocated from:
    #0 0x55f72c21ac8d  (/tmp/test+0x95c8d)
    #1 0x7f7e44e686b1  (/usr/lib/swift/linux/libswiftCore.so+0x3cb6b1)
    #2 0x55f72c24b2ce  (/tmp/test+0xc62ce)
    #3 0x55f72c24a4c3  (/tmp/test+0xc54c3)
    #4 0x7f7e43aecb96  (/lib/x86_64-linux-gnu/libc.so.6+0x21b96)

SUMMARY: AddressSanitizer: 32 byte(s) leaked in 1 allocation(s).
```

현재 출력은 [LeakSanitizer가 Linux에서 스택 트레이스를 심볼화하지 않기 때문에](https://github.com/swiftlang/swift/issues/55046) 함수 이름의 사람이 읽을 수 있는 표현을 제공하지 않습니다. 그러나 `binutils`가 설치되어 있다면 `llvm-symbolizer` 또는 `addr2line`을 사용하여 심볼화할 수 있습니다.

Linux에서 실행되는 Swift 서버에 `binutils`를 설치하려면 다음 단계를 따르세요:

1단계: 터미널을 통해 SSH로 Swift 서버에 연결합니다.

2단계: 다음 명령을 실행하여 패키지 목록을 업데이트합니다:

```
sudo apt update
```

3단계: 다음 명령을 실행하여 `binutils`를 설치합니다:

```
sudo apt install binutils
```

이렇게 하면 바이너리, 오브젝트 파일, 라이브러리 작업에 유용한 `binutils`와 관련 도구가 설치되며, Linux에서 Swift 애플리케이션을 개발하고 디버깅하는 데 유용합니다.

이제 다음 명령을 실행하여 스택 트레이스의 심볼을 디맹글할 수 있습니다:

```
# /tmp/test+0xc62ce
addr2line -e /tmp/test -a 0xc62ce -ipf | swift demangle
```

이 예제에서 누수된 할당은 다음에서 발생했습니다:

```
0x00000000000c62ce: test.myFunctionDoingTheAllocation() -> () at crtstuff.c:?
```

#### 제한 사항

- LeakSanitizer는 C나 C++와 같은 언어에 비해 Swift 코드의 모든 유형의 메모리 누수를 감지하고 보고하는 데 효과적이지 않을 수 있습니다.
- LeakSanitizer가 존재하지 않는 메모리 누수를 보고하는 위양성이 발생합니다.
- LeakSanitizer는 주로 macOS와 Linux에서 지원됩니다. iOS 또는 Swift를 지원하는 다른 플랫폼에서도 사용할 수 있지만, 제한 사항이나 플랫폼별 문제를 고려해야 할 수 있습니다.
- Swift 프로젝트에서 Address Sanitizer와 LeakSanitizer를 활성화하면 성능에 영향을 미칠 수 있습니다. 프로덕션 환경에서 지속적으로 실행하기보다는 대상을 지정한 분석 및 디버깅에 사용하는 것이 좋습니다.

### Heaptrack으로 일시적 메모리 사용량 디버깅

[Heaptrack](https://github.com/KDE/heaptrack)은 Valgrind보다 적은 오버헤드로 메모리 누수 및 사용량을 찾고 분석하는 데 도움이 되는 오픈소스 힙 메모리 프로파일러 도구입니다. 또한 애플리케이션의 일시적 메모리 사용량을 분석하고 디버깅할 수 있습니다. 그러나 할당자에 과부하를 줄 수 있어 성능에 상당한 영향을 미칠 수 있습니다.

명령줄 접근 외에도 GUI 프론트엔드 분석기 `heaptrack_gui`를 사용할 수 있습니다. 분석기를 사용하면 `feature branch`와 `main` 사이의 `malloc` 동작 변동을 문제 해결하기 위해 애플리케이션의 두 실행 결과를 비교(diff)할 수 있습니다.

다른 예제를 사용하여, 일시적 사용량을 분석하기 위한 [Ubuntu](https://www.swift.org/download/)에서의 간단한 사용법을 소개합니다.

1단계: 다음 명령을 실행하여 `heaptrack`을 설치합니다:

```
sudo apt-get install heaptrack
```

2단계: `heaptrack`을 사용하여 바이너리를 두 번 실행합니다. 첫 번째 실행은 `main`의 기준선을 제공합니다.

```
heaptrack .build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
heaptrack output will be written to "/tmp/.nio_alloc_counter_tests_GRusAy/heaptrack.test_1000_autoReadGetAndSet.84341.gz"
starting application, this might take some time...
...
heaptrack stats:
    allocations:              319347
    leaked allocations:       107
    temporary allocations:    68
Heaptrack finished! Now run the following to investigate the data:

  heaptrack --analyze "/tmp/.nio_alloc_counter_tests_GRusAy/heaptrack.test_1000_autoReadGetAndSet.84341.gz"
```

3단계: 브랜치를 변경하고 재컴파일하여 `feature branch`에 대해 두 번째로 실행합니다.

```
heaptrack .build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
heaptrack output will be written to "/tmp/.nio_alloc_counter_tests_GRusAy/heaptrack.test_1000_autoReadGetAndSet.84372.gz"
starting application, this might take some time...
...
heaptrack stats:
    allocations:              673989
    leaked allocations:       117
    temporary allocations:    341011
Heaptrack finished! Now run the following to investigate the data:

  heaptrack --analyze "/tmp/.nio_alloc_counter_tests_GRusAy/heaptrack.test_1000_autoReadGetAndSet.84372.gz"
ubuntu@ip-172-31-25-161 /t/.nio_alloc_counter_tests_GRusAy>
```

출력에서 `feature branch` 버전에서는 `673989`번의 할당이, `main`에서는 `319347`번의 할당이 있어 회귀가 있음을 나타냅니다.

4단계: 다음 명령을 실행하여 `heaptrack_print`를 사용하여 이 두 실행의 출력을 diff로 분석하고 가독성을 위해 `swift demangle`을 통해 파이프합니다:

```
heaptrack_print -T -d heaptrack.test_1000_autoReadGetAndSet.84341.gz heaptrack.test_1000_autoReadGetAndSet.84372.gz | swift demangle
```

**참고:** `-T`는 일시적 할당을 출력하며, 누수가 아닌 일시적 할당을 제공합니다. 누수가 감지되면 `-T`를 제거하세요.

일시적 할당을 보려면 아래로 스크롤합니다(출력이 길 수 있음):

```
MOST TEMPORARY ALLOCATIONS
307740 temporary allocations of 290324 allocations in total (106.00%) from
swift_slowAlloc
  in /home/ubuntu/bin/usr/lib/swift/linux/libswiftCore.so
43623 temporary allocations of 44553 allocations in total (97.91%) from:
    swift_allocObject
      in /home/ubuntu/bin/usr/lib/swift/linux/libswiftCore.so
    NIO.ServerBootstrap.(bind0 in _C131C0126670CF68D8B594DDFAE0CE57)(makeServerChannel: (NIO.SelectableEventLoop, NIO.EventLoopGroup) throws -> NIO.ServerSocketChannel, _: (NIO.EventLoop, NIO.ServerSocketChannel) -> NIO.EventLoopFuture<()>) -> NIO.EventLoopFuture<NIO.Channel>
      at /home/ubuntu/swiftnio/swift-nio/Sources/NIO/Bootstrap.swift:295
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
    merged NIO.ServerBootstrap.bind(host: Swift.String, port: Swift.Int) -> NIO.EventLoopFuture<NIO.Channel>
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
    NIO.ServerBootstrap.bind(host: Swift.String, port: Swift.Int) -> NIO.EventLoopFuture<NIO.Channel>
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
    Test_test_1000_autoReadGetAndSet.run(identifier: Swift.String) -> ()
      at /tmp/.nio_alloc_counter_tests_GRusAy/Sources/Test_test_1000_autoReadGetAndSet/file.swift:24
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
    main
      at Sources/bootstrap_test_1000_autoReadGetAndSet/main.c:18
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
22208 temporary allocations of 22276 allocations in total (99.69%) from:
    swift_allocObject
      in /home/ubuntu/bin/usr/lib/swift/linux/libswiftCore.so
    generic specialization <Swift.UnsafeBufferPointer<Swift.Int8>> of Swift._copyCollectionToContiguousArray<A where A: Swift.Collection>(A) -> Swift.ContiguousArray<A.Element>
      in /home/ubuntu/bin/usr/lib/swift/linux/libswiftCore.so
    Swift.String.utf8CString.getter : Swift.ContiguousArray<Swift.Int8>
      in /home/ubuntu/bin/usr/lib/swift/linux/libswiftCore.so
    NIO.URing.getEnvironmentVar(Swift.String) -> Swift.String?
      at /home/ubuntu/swiftnio/swift-nio/Sources/NIO/LinuxURing.swift:291
      in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
    NIO.URing._debugPrint(@autoclosure () -> Swift.String) -> ()
      at /home/ubuntu/swiftnio/swift-nio/Sources/NIO/LinuxURing.swift:297
...
22196 temporary allocations of 22276 allocations in total (99.64%) from:
```

위 출력을 보면 추가 일시적 할당이 아래와 같이 추가 디버그 출력과 환경 변수 쿼리 때문임을 알 수 있습니다:

```
NIO.URing.getEnvironmentVar(Swift.String) -> Swift.String?
  at /home/ubuntu/swiftnio/swift-nio/Sources/NIO/LinuxURing.swift:291
  in /tmp/.nio_alloc_counter_tests_GRusAy/.build/x86_64-unknown-linux-gnu/release/test_1000_autoReadGetAndSet
NIO.URing._debugPrint(@autoclosure () -> Swift.String) -> ()
```

이 예제에서 디버그 출력은 테스트용으로만 사용되며, 브랜치를 병합하기 전에 코드에서 제거될 것입니다.

**팁:** Heaptrack은 [RPM 기반 배포판에도 설치](https://rhel.pkgs.org/8/epel-x86_64/heaptrack-1.2.0-7.el8.x86_64.rpm.html)하여 일시적 메모리 사용량을 디버깅할 수 있습니다. 특정 저장소 설정 단계는 배포판 문서를 참고해야 할 수 있습니다. Heaptrack이 올바르게 설치되면 버전 및 사용법 정보를 표시해야 합니다.

#### 제한 사항

- Heaptrack은 주로 C 및 C++ 애플리케이션을 위해 설계되었으므로 Swift 애플리케이션에 대한 지원이 제한적입니다.
- Heaptrack은 Swift 애플리케이션의 메모리 할당 및 해제에 대한 인사이트를 제공할 수 있지만, Swift의 내장 Instruments 프로파일러와 같은 Swift 특화 메모리 관리 메커니즘을 캡처하지 못할 수 있습니다.
