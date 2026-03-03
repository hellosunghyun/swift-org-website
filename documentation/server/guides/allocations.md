---
redirect_from: 'server/guides/allocations'
layout: page
title: 메모리 할당
---

## 개요

서버사이드 Swift 애플리케이션에서 메모리 할당은 객체 생성, 데이터 구조 조작, 리소스 관리 등 다양한 작업의 기반입니다. Swift는 필요에 따라 메모리 리소스를 할당하고, 자동 참조 카운팅(ARC)과 같은 내장 메모리 관리 메커니즘을 제공하여 할당, 해제, 메모리 소유권을 처리합니다.

할당은 각 객체나 데이터 구조에 필요한 정확한 양의 메모리를 할당하여 메모리 사용을 최적화하고, 메모리 낭비를 줄이며 애플리케이션 성능을 향상시킵니다. 그러나 Swift 할당은 하드웨어에 의해 효율적으로 접근되어야 하는 데이터 타입이나 구조에 대한 메모리 정렬 요구사항을 충족하기 위해 패딩될 수 있으며, 정렬되지 않은 메모리 접근 문제의 위험을 줄이고 성능을 향상시킵니다.

또한, 적절한 할당 관리는 메모리 누수를 방지하고 더 이상 필요하지 않은 메모리가 해제되도록 보장합니다. 이는 서버 애플리케이션의 안정성과 신뢰성을 유지하는 데 도움이 됩니다.

## 힙과 스택

일반적으로 Swift에는 메모리 할당을 위한 두 가지 기본 위치가 있습니다: **힙**과 **스택**.

Swift는 힙 또는 스택 데이터 구조에 자동으로 메모리를 할당합니다.

Swift에서 고성능 소프트웨어를 만들려면, 힙 할당의 원인을 파악하고 소프트웨어가 제공하는 할당 수를 줄이는 것이 매우 중요합니다. 이러한 질문을 식별하는 것은 다른 성능 질문을 식별하는 것과 유사합니다:

- 성능을 최적화하기 전에 리소스가 어디에 할당되고 있는가?
- 어떤 유형의 리소스가 사용되는가? CPU? 메모리? 힙 할당?

> 참고: 힙 할당은 계산 오버헤드 측면에서 비교적 비용이 높을 수 있지만, 가변 크기 또는 동적 데이터 구조 작업과 같은 작업에 필수적인 유연성과 동적 메모리 관리 기능을 제공합니다.

## 프로파일링

프로젝트의 특정 요구사항에 따라 다양한 도구와 기법을 사용하여 Swift 코드를 프로파일링할 수 있습니다. 일반적으로 사용되는 프로파일링 기법은 다음과 같습니다:

- macOS의 [Instruments](https://help.apple.com/instruments/mac/current/#/dev7b09c84f5)나 Linux의 [`perf`](/server/guides/linux-perf.html)와 같은 OS 벤더 제공 프로파일링 도구 사용
- 중요한 코드 섹션 전후에 타임스탬프를 추가하는 등의 수동 시간 측정 기법 추가
- [SwiftMetrics](https://swiftpackageregistry.com/RuntimeTools/SwiftMetrics)나 [XCGLogger](https://github.com/XCGLogger/)와 같은 Swift용 성능 프로파일링 라이브러리 및 프레임워크 활용

macOS의 경우, [Xcode](https://developer.apple.com/xcode/) Instruments의 [Allocations instrument](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use#Profile-your-app-using-the-Allocations-instrument)를 사용하여 앱의 메모리 사용량을 분석하고 최적화할 수 있습니다. Allocations instrument는 모든 힙 및 익명 가상 메모리 할당의 크기와 수를 추적하고 카테고리별로 구성합니다.

프로덕션 워크로드가 macOS가 아닌 Linux에서 실행되는 경우, 설정에 따라 할당 수가 크게 다를 수 있습니다.

_이 문서는 주로 힙 할당의 크기가 아닌 수에 초점을 맞춥니다._

## 시작하기

Swift의 옵티마이저는 `release` 모드에서 더 빠른 코드를 생성하고 더 적은 메모리를 할당합니다. `release` 모드에서 Swift 코드를 프로파일링하고 결과를 기반으로 최적화하면, 애플리케이션에서 더 나은 성능과 효율성을 달성할 수 있습니다.

아래 단계를 따르세요:

1단계. 다음 명령을 실행하여 `release` 모드로 **코드를 빌드**합니다:

```bash
swift run -c release
```

2단계. 환경에 맞게 [**`perf`를 설치**](/server/guides/linux-perf.html)하여 코드를 프로파일링하고 성능 관련 데이터를 수집하며 Swift 서버 애플리케이션의 성능을 최적화합니다.

3단계. **FlameGraph 프로젝트를 클론**하여 코드베이스의 핫스팟을 빠르게 식별하고, 호출 경로를 시각화하고, 실행 흐름을 이해하고, 성능을 최적화하는 데 도움이 되는 플레임 그래프 시각화를 생성합니다. 플레임 그래프를 생성하려면 머신이나 컨테이너에 [`FlameGraph`](https://github.com/brendangregg/FlameGraph) 저장소를 클론하여 `~/FlameGraph`에서 사용할 수 있도록 해야 합니다.

다음 명령을 실행하여 `~/FlameGraph`에 `https://github.com/brendangregg/FlameGraph` 저장소를 클론합니다:

```bash
git clone https://github.com/brendangregg/FlameGraph
```

Docker에서 실행할 때는 다음 명령을 사용하여 `FlameGraph` 저장소를 컨테이너에 바인드 마운트합니다:

```bash
docker run -it --rm \
           --privileged \
           -v "/path/to/FlameGraphOnYourMachine:/FlameGraph:ro" \
           -v "$PWD:PWD" -w "$PWD" \
           swift:latest
```

가장 자주 호출되거나 가장 많은 처리 시간을 소비하는 함수를 시각적으로 강조하여, 중요한 코드 경로의 성능을 개선하기 위한 최적화 노력에 집중할 수 있습니다.

## 도구

[Linux `perf`](https://perf.wiki.kernel.org/index.php/Main_Page) 도구를 사용하여 최적화 영역을 식별하고 Swift 서버 코드의 성능과 효율성을 개선하기 위한 정보에 기반한 결정을 내릴 수 있습니다.

`perf` 도구는 Linux 시스템에서 사용할 수 있는 성능 프로파일링 및 분석 도구입니다. Swift에 특화된 것은 아니지만, 다음과 같은 이유로 서버에서 Swift 코드를 프로파일링하는 데 유용할 수 있습니다:

- **낮은 오버헤드**: Swift 코드 실행에 최소한의 영향을 미치면서 성능 데이터를 수집할 수 있습니다.
- **풍부한 기능 세트**: CPU 프로파일링, 메모리 프로파일링, 이벤트 기반 샘플링 등을 제공합니다.
- **플레임 그래프 생성**: 코드의 여러 영역에서 소요된 상대적 시간을 이해하고 성능 병목 현상을 식별하는 데 도움이 됩니다.
- **시스템 수준 프로파일링**: 커널 수준에서 성능 데이터를 수집하고, 시스템 전체 이벤트를 분석하며, 다른 프로세스나 시스템 구성 요소가 Swift 애플리케이션의 성능에 미치는 영향을 이해합니다.
- **유연성과 확장성**: 프로파일링할 이벤트 유형을 사용자 정의하고, 샘플링 속도를 설정하며, 필터를 지정하는 등의 작업이 가능합니다.

> 팁 1: Docker 컨테이너에서 `perf`를 실행하는 경우, 성능 데이터를 수집하기 위한 필요한 권한과 도구 접근을 제공하려면 특권 컨테이너가 필요합니다.

> 팁 2: `root` 접근이 필요한 경우 명령 앞에 `sudo`를 붙이세요.
> 자세한 내용은 [`perf` 설정하기](/server/guides/linux-perf.html)를 참고하세요.

## perf user probe 설치

앞서 언급했듯이, 이 문서의 예제 프로그램은 할당 *수*를 카운트하는 데 초점을 맞춥니다.

대부분의 할당은 Linux에서 Swift 프로그램의 `malloc` 함수를 사용합니다. 할당 함수에 `perf` user probe를 설치하면 할당 함수가 호출될 때의 정보를 제공합니다.

이 경우, Swift는 `calloc`이나 `posix_memalign`과 같은 다른 함수도 사용하므로 모든 할당 함수에 user probe를 설치했습니다.

```bash
# figures out the path to libc
libc_path=$(readlink -e /lib64/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6)

# delete all existing user probes on libc (instead of * you can also list them individually)
perf probe --del 'probe_libc:*'

# installs a probe on `malloc`, `calloc`, and `posix_memalign`
perf probe -x "$libc_path" --add malloc --add calloc --add posix_memalign
```

이후 할당 함수 중 하나가 호출될 때마다 `perf`에서 이벤트가 트리거됩니다.

출력은 다음과 같아야 합니다:

```
Added new events:
  probe_libc:malloc    (on malloc in /usr/lib/x86_64-linux-gnu/libc-2.31.so)
  probe_libc:calloc    (on calloc in /usr/lib/x86_64-linux-gnu/libc-2.31.so)
  probe_libc:posix_memalign (on posix_memalign in /usr/lib/x86_64-linux-gnu/libc-2.31.so)

[...]
```

여기서 `perf`가 각 함수가 호출될 때마다 새 이벤트 `probe_libc:malloc`, `probe_libc:calloc`을 트리거하는 것을 볼 수 있습니다.

user probe `probe_libc:malloc`이 작동하는지 확인하려면 다음 명령을 실행합니다:

```bash
perf stat -e probe_libc:malloc -- bash -c 'echo Hello World'
```

출력은 다음과 비슷해야 합니다:

```
Hello World

 Performance counter stats for 'bash -c echo Hello World':

              1021      probe_libc:malloc

       0.003840500 seconds time elapsed

       0.000000000 seconds user
       0.003867000 seconds sys
```

이 경우, user probe가 할당 함수를 1021번 호출한 것으로 나타납니다.

> 중요: probe가 할당 함수를 0번 호출했다면 오류가 있음을 나타냅니다.

## 할당 분석 실행

할당 분석을 실행하면 애플리케이션의 메모리 사용 패턴을 더 잘 이해하고, 누수나 비효율적인 사용과 같은 메모리 문제를 식별하고 수정하여 궁극적으로 코드의 성능과 안정성을 개선할 수 있습니다.

### 예제 프로그램

`malloc`의 user probe가 작동하는 것을 확인한 후, 프로그램의 할당을 분석할 수 있습니다. 예를 들어, [AsyncHTTPClient](https://github.com/swift-server/async-http-client)를 사용하여 10개의 연속 HTTP 요청을 수행하는 프로그램을 분석할 수 있습니다.

AsyncHTTPClient를 사용하는 프로그램을 분석하면 성능을 최적화하고, 오류 처리를 개선하며, 적절한 동시성과 스레딩을 보장하고, 코드 가독성과 유지보수성을 향상시키며, 확장성 고려 사항을 평가하는 데 도움이 됩니다.

다음은 의존성이 포함된 프로그램 소스 코드 예제입니다:

```swift
dependencies: [
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.3.0"),
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.29.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
],
```

AsyncHTTPClient를 사용하는 예제 프로그램은 다음과 같이 작성할 수 있습니다:

```swift
import AsyncHTTPClient
import NIO
import Logging

let urls = Array(repeating:"http://httpbin.org/get", count: 10)
var logger = Logger(label: "ahc-alloc-demo")

logger.info("running HTTP requests", metadata: ["count": "\(urls.count)"])
MultiThreadedEventLoopGroup.withCurrentThreadAsEventLoop { eventLoop in
    let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoop),
                                backgroundActivityLogger: logger)

    func doRemainingRequests(_ remaining: ArraySlice<String>,
                             overallResult: EventLoopPromise<Void>,
                             eventLoop: EventLoop) {
        var remaining = remaining
        if let first = remaining.popFirst() {
            httpClient.get(url: first, logger: logger).map { [remaining] _ in
                eventLoop.execute { // for shorter stacks
                    doRemainingRequests(remaining, overallResult: overallResult, eventLoop: eventLoop)
                }
            }.whenFailure { error in
                overallResult.fail(error)
            }
        } else {
            return overallResult.succeed(())
        }
    }

    let promise = eventLoop.makePromise(of: Void.self)
    // Kick off the process
    doRemainingRequests(urls[...],
                        overallResult: promise,
                        eventLoop: eventLoop)

    promise.futureResult.whenComplete { result in
        switch result {
        case .success:
            logger.info("all HTTP requests succeeded")
        case .failure(let error):
            logger.error("HTTP request failure", metadata: ["error": "\(error)"])
        }

        httpClient.shutdown { maybeError in
            if let error = maybeError {
                logger.error("AHC shutdown failed", metadata: ["error": "\(error)"])
            }
            eventLoop.shutdownGracefully { maybeError in
                if let error = maybeError {
                    logger.error("EventLoop shutdown failed", metadata: ["error": "\(error)"])
                }
            }
        }
    }
}

logger.info("exiting")
```

Swift 패키지로 프로그램을 실행하는 경우, 먼저 다음 명령을 사용하여 `release` 모드로 컴파일합니다:

```bash
swift build -c release
```

`.build/release/your-program-name`이라는 바이너리가 생성되며, 이를 분석하여 할당 수를 확인할 수 있습니다.

### 할당 카운팅

할당을 카운팅하고 그래프로 시각화하면 메모리 활용도를 분석하고, 메모리 사용량을 프로파일링하며, 성능을 최적화하고, 코드를 리팩토링 및 최적화하며, 프로그램의 메모리 관련 문제를 디버깅하는 데 도움이 됩니다.

할당을 플레임 그래프로 시각화하기 전에, 바이너리를 사용하여 할당 수를 얻는 분석부터 시작합니다:

```bash
perf stat -e 'probe_libc:*' -- .build/release/your-program-name
```

이 명령은 `perf`에 프로그램을 실행하고 user probe `probe_libc:malloc`이 트리거되거나 애플리케이션 내에서 메모리가 할당된 횟수를 카운트하도록 지시합니다.

출력은 다음과 비슷해야 합니다:

```
Performance counter stats for '.build/release/your-program-name':

                68      probe_libc:posix_memalign
                35      probe_libc:calloc_1
                 0      probe_libc:calloc
              2977      probe_libc:malloc

[...]
```

이 경우, 프로그램은 `malloc`을 통해 2977번, 기타 할당 함수를 통해 소수의 할당을 수행했습니다.

`-e probe_libc:*` 명령은 다음과 같이 개별적으로 모든 이벤트를 나열하는 대신 사용됩니다:

- `-e probe_libc: malloc`
- `probe_libc:calloc`
- `probe_libc:calloc_1`
- `probe_libc:posix_memalign`

> 팁: 이 접근 방식은 _다른_ `perf` user probe가 설치되어 있지 않다고 가정합니다. 다른 `perf` user probe가 설치된 경우 사용할 각 이벤트를 개별적으로 지정해야 합니다.

### 원시 데이터 수집

원시 데이터 수집은 시스템 동작의 정확한 표현을 얻고, 상세한 성능 분석 및 디버깅을 수행하며, 추세를 분석하고, 프로파일링 유연성을 가능하게 하며, 성능 최적화 노력을 안내하는 데 중요합니다.

`perf` 명령은 프로그램이 실행되는 동안 실시간 그래프를 생성하는 것을 허용하지 않습니다. 그러나 [Linux Perf 도구](https://perf.wiki.kernel.org/index.php/Main_Page)는 나중에 분석하기 위해 성능 이벤트를 캡처하는 `perf record` 유틸리티 명령을 제공합니다. 수집된 데이터는 그래프로 변환할 수 있습니다.

일반적으로 `perf record` 명령을 사용하여 프로그램을 실행하고 `libc_probe:malloc`으로 정보를 수집할 수 있습니다:

```bash
perf record --call-graph dwarf,16384 \
     -m 50000 \
     -e 'probe_libc:*' -- \
     .build/release/your-program-name
```

이 명령의 구성 요소를 분석하면:

- `perf record` 명령은 `perf`에 데이터를 기록하도록 지시합니다.
- `--call-graph dwarf,16384` 명령은 `perf`에 [DWARF(Debugging With Attributed Record Formats)](http://www.dwarfstd.org/) 정보를 사용하여 콜 그래프를 생성하도록 지시합니다. 또한 최대 스택 덤프 크기를 16k로 설정하며, 이는 전체 스택 트레이스에 충분해야 합니다.
  - DWARF 사용은 느리지만(아래 참고), 최상의 콜 그래프를 생성합니다.
- `-m 50000`은 `perf`가 사용하는 링 버퍼의 크기를 나타내며 `PAGE_SIZE`(보통 4kB)의 배수로 출력합니다.
  - DWARF를 사용할 때 데이터 손실을 방지하기 위해 상당한 버퍼가 필요합니다.
- `-e 'probe_libc:*'`는 `malloc`; `calloc`; 기타 `malloc/calloc/...` user probe가 발동할 때 데이터를 기록합니다.
  - 발동 이벤트는 probe가 트리거되거나 실행될 때 발생하며, 추가 분석 및 디버깅을 위해 할당에 대한 관련 정보를 캡처합니다.

프로그램 출력은 다음과 비슷해야 합니다:

```
<your program's output>
[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 401.088 MB perf.data (49640 samples) ]
```

코드베이스의 전략적 지점에 user probe를 배치하면, 할당 이벤트를 추적하고 기록하여 메모리 할당 패턴에 대한 인사이트를 얻고, 잠재적 성능 문제나 메모리 누수를 식별하며, 애플리케이션의 메모리 사용량을 분석할 수 있습니다.

> 중요: `perf` 출력에서 `lost chunks`를 반환하고 `check the IO/CPU overload!`를 요청하는 경우, 아래의 **데이터 손실 극복** 섹션을 참고하세요.

### 플레임 그래프 생성

`perf record`를 사용하여 데이터를 성공적으로 기록한 후, 다음 명령을 실행하여 플레임 그래프가 포함된 SVG 파일을 생성할 수 있습니다:

```bash
perf script | \
    /FlameGraph/stackcollapse-perf.pl - | \
    swift demangle --simplified | \
    /FlameGraph/flamegraph.pl --countname allocations \
        --width 1600 > out.svg
```

이 명령 구성의 분석:

- `perf` script 명령은 `perf record`가 캡처한 바이너리 정보를 텍스트 형태로 변환합니다.
- `stackcollapse-perf` 명령은 `perf script`가 생성한 스택을 플레임 그래프에 맞는 올바른 형식으로 변환합니다.
- `swift demangle --simplified` 명령은 심볼 이름을 사람이 읽을 수 있는 형식으로 변환합니다.
- 마지막 두 명령은 할당 수를 기반으로 플레임 그래프를 생성합니다.

명령이 완료되면 브라우저에서 열 수 있는 SVG 파일이 생성됩니다.

> 참고: 데이터 크기, 알고리즘 복잡성, CPU 성능이나 메모리와 같은 리소스 제한, 최적화되지 않거나 비효율적인 코드, 외부 서비스, API 또는 네트워크 지연으로 인한 속도 저하에 따라 긴 실행 시간이 발생할 수 있습니다.

### 플레임 그래프 읽기

이 플레임 그래프는 이 섹션의 예제 프로그램의 직접적인 결과입니다. 스택 프레임 위에 마우스를 올려 자세한 정보를 확인하거나, 스택 프레임을 클릭하여 하위 트리를 확대할 수 있습니다.

<p><img src="/assets/images/server-guides/perf-malloc-full.svg" alt="플레임 그래프" /></p>

- 플레임 *그래프*를 해석할 때 X축은 시간이 아닌 **카운트**를 의미합니다. 플레임 *차트*와 달리, 스택의 배치(왼쪽 또는 오른쪽)는 해당 스택이 활성화된 시점에 의해 결정되지 않습니다.

- 이 플레임 그래프는 CPU 플레임 그래프가 아니라 할당 플레임 그래프이며, 하나의 샘플은 하나의 할당을 나타내고 CPU에서 소비된 시간이 아닙니다.
- 넓은 스택 프레임이 반드시 직접 할당하는 것은 아닙니다. 즉, 해당 함수나 함수가 호출한 다른 함수가 여러 번 할당했다는 의미입니다.
  - 예를 들어, `BaseSocketChannel.readable`은 넓은 프레임이지만, 이 함수는 직접 할당하지 않습니다. 대신 SwiftNIO와 AsyncHTTPClient의 다른 부분과 같은 다른 함수를 호출했고, 그 함수들이 상당히 많이 할당했습니다.

## macOS에서의 할당 플레임 그래프

이 튜토리얼의 대부분이 `perf` 도구에 초점을 맞추고 있지만, macOS에서도 동일한 그래프를 생성할 수 있습니다.

1단계. 시작하려면 다음 명령을 실행하여 [DTrace](https://en.wikipedia.org/wiki/DTrace) 프레임워크를 사용하여 원시 데이터를 수집합니다:

```bash
sudo dtrace -n 'pid$target::malloc:entry,pid$target::posix_memalign:entry,pid$target::calloc:entry,pid$target::malloc_zone_malloc:entry,pid$target::malloc_zone_calloc:entry,pid$target::malloc_zone_memalign:entry { @s[ustack(100)] = count(); } ::END { printa(@s); }' -c .build/release/your-program > raw.stacks
```

Linux의 `perf` user probe와 마찬가지로 DTrace도 probe를 사용합니다. 이전 명령은 `dtrace`에 할당 함수에 해당하는 호출 수를 집계하도록 지시합니다:

- `malloc`
- `posix_memalign`
- `calloc`
- `malloc_zone_*`

> 참고: Apple 플랫폼에서 Swift는 Linux보다 약간 더 많은 수의 할당 함수를 사용합니다.

2단계. 데이터가 수집되면 다음 명령을 실행하여 SVG 파일을 생성합니다:

```bash
cat raw.stacks |\
    /FlameGraph/stackcollapse.pl - | \
    swift demangle --simplified | \
    /FlameGraph/flamegraph.pl --countname allocations \

        --width 1600 > out.svg
```

이 명령은 `perf` 호출과 유사하지만, 다음이 다릅니다:

- `cat raw.stacks` 명령은 `dtrace`가 이미 텍스트 데이터 파일을 포함하고 있으므로 `perf script` 명령을 대체합니다.
- `stackcollapse.pl` 명령은 `dtrace` 집계 출력을 파싱하며, `perf script` 출력을 파싱하는 `stackcollapse-perf.pl` 명령을 대체합니다.

## 기타 perf 팁

### Swift의 할당 패턴

플레임 그래프에서 제공하는 정보를 기반으로 메모리 할당을 최적화하고 코드 효율성을 개선하면 Swift 코드를 더 성능이 좋고 시각적으로 이해하기 쉽게 만들 수 있습니다. Swift에서 할당의 형태는 할당되는 메모리 유형과 사용 방식에 따라 달라질 수 있습니다.

Swift에서 일반적인 할당 형태는 다음과 같습니다:

- 단일 객체 할당
- 컬렉션 할당
- 문자열
- 함수 호출 스택
- 프로토콜 existential
- 구조체와 클래스

예를 들어, 클래스 인스턴스(할당 발생)는 `swift_allocObject`를 호출하고, 이는 `swift_slowAlloc`을 호출하며, 이는 user probe가 포함된 `malloc`을 호출합니다.

### 할당 패턴 "정리하기"

플레임 그래프를 보기 좋게 만들려면(축소된 스택을 디맹글한 후) 다음 코드를 Linux `perf script` 코드(위)에 삽입합니다:

- `specialized`를 제거하고 `swift_allocObject`로 교체합니다.
- `swift_slowAlloc`을 호출하고, 이는 `malloc`을 호출합니다.
- 할당에 `A`를 사용합니다.

이러한 변경사항은 다음과 같습니다:

```bash
sed -e 's/specialized //g' \
    -e 's/;swift_allocObject;swift_slowAlloc;__libc_malloc/;A/g'
```

Swift의 메모리 할당을 분석할 때 시각적으로 보기 좋은 SVG 파일 플레임 그래프를 생성하려면 다음 전체 명령을 사용합니다:

```bash
perf script | \
    /FlameGraph/stackcollapse-perf.pl - | \
    swift demangle --simplified | \
    sed -e 's/specialized //g' \
        -e 's/;swift_allocObject;swift_slowAlloc;__libc_malloc/;A/g' | \
    /FlameGraph/flamegraph.pl --countname allocations --flamechart --hash \
    > out.svg
```

## 데이터 손실 극복

DWARF 콜 스택 언와인딩과 함께 perf를 사용할 때 다음 문제가 발생할 수 있습니다:

```
[ perf record: Woken up 189 times to write data ]
Warning:
Processed 4346 events and lost 144 chunks!

Check IO/CPU overload!

[ perf record: Captured and wrote 30.868 MB perf.data (3817 samples) ]
```

`perf`가 여러 *청크*를 잃었다고 표시하면 데이터를 잃었다는 의미입니다. `perf`가 데이터를 잃으면 다음 옵션을 사용하여 문제를 해결할 수 있습니다:

- 프로그램이 수행하는 작업량을 줄입니다.
  - 모든 할당에 대해 `perf`는 스택 트레이스를 기록합니다.
- `--call-graph dwarf` 매개변수를 변경하여 `perf`가 기록하는 최대 *스택 덤프*를 줄입니다.
  예: `--call-graph dwarf,2048`로 변경 - 기본값은 최대 4096바이트를 기록하여 깊은 스택을 렌더링합니다. 대용량 출력이 필요하지 않으면 이 숫자를 줄일 수 있습니다. 그러나 플레임 그래프에 `[unknown]` 스택 프레임이 표시될 수 있으며, 이는 누락된 스택 프레임이 있음을 의미합니다(바이트 단위).
- `-m` 매개변수의 숫자를 늘립니다. 이는 `perf`가 메모리에서 사용하는 링 버퍼의 크기이며 `PAGE_SIZE`(보통 4kB)의 배수로 렌더링합니다.
- `--call-tree dwarf` 명령을 `--call-tree fp`로 교체하여 프로그램 내 함수 호출의 계층적 뷰를 제공하는 콜 트리 보고서를 생성하며, 함수가 어떻게 호출되는지와 서로 다른 함수 간의 관계를 보여줍니다.

전반적으로, 이러한 방법은 프로그램의 동작을 이해하고, 병목 현상을 식별하며, Swift 애플리케이션의 성능을 개선하는 데 도움이 됩니다.
