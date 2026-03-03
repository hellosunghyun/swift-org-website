---
redirect_from: 'server/guides/performance'
layout: page
title: 성능 문제 디버깅
---

## 개요

이 문서는 코드의 병목 현상이나 비효율성을 식별하고 해결하여 Swift의 성능 문제를 디버깅하는 데 도움을 줍니다. 성능 문제 디버깅을 통해 코드를 최적화하고 Swift 애플리케이션의 전반적인 속도와 효율성을 개선할 수 있습니다.

Swift에서 성능 문제를 디버깅하기 위한 기본적인 방법과 도구는 다음과 같습니다:

1. **성능 측정**: [Xcode의 Instruments](https://help.apple.com/instruments/mac/current/)와 [Linux perf](/documentation/server/guides/linux-perf.html)는 애플리케이션의 성능을 추적하고 과도한 CPU, 메모리 또는 에너지를 소비하는 영역을 식별하는 데 도움이 되는 프로파일링 도구를 제공합니다. 예를 들어, 프로파일링과 플레임 그래프는 CPU 소비를 보여주고, 메모리 그래프는 메모리 소비를 보여줍니다. 각 플랫폼마다 애플리케이션 성능 측정 방법이 다르다는 점에 유의하세요.
   - macOS의 경우 [Getting Started with Instruments](https://developer.apple.com/videos/play/wwdc2019/411/)를 참고하세요.
   - Linux의 경우 [perf: Linux profiling with performance counters](https://perf.wiki.kernel.org/index.php/Main_Page)를 참고하세요.

2. **메모리 사용량 프로파일링**: Xcode의 [Memory Graph Debugger](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use)를 사용하여 메모리 관련 문제를 식별하고 수정합니다.

3. **벤치마크 및 개선 측정**: 원하는 성능에 도달할 때까지 반복적으로 최적화합니다.

> 팁: 최적의 성능을 보장하기 위해 Swift 코드를 `release` 모드로 컴파일하는 것을 권장합니다. 디버그 빌드와 릴리스 빌드의 성능 차이는 상당합니다. 데이터를 수집하도록 코드를 구성하기 전에 `swift build -c release` 명령을 실행하세요.

## 도구

성능 문제 디버깅은 때때로 복잡하고 반복적인 과정이 될 수 있습니다. 기법, 도구, 분석의 조합이 필요합니다. 병목 현상을 효과적으로 식별하고 해결하는 데 도움이 되는 몇 가지 도구와 방법을 정리했습니다:

- **플레임 그래프**
- **Malloc 라이브러리**

### 플레임 그래프

[플레임 그래프](https://www.brendangregg.com/flamegraphs.html)는 프로그램 성능을 분석하는 데 유용한 도구입니다. 프로그램의 어떤 부분이 가장 많은 시간을 차지하는지 보여주어 개선이 필요한 영역을 찾는 데 도움이 됩니다.

#### Xcode의 플레임 그래프

Linux `perf`처럼 플레임 그래프를 생성하도록 특별히 설계된 내장 도구는 Xcode에 없지만, 외부 도구를 사용하여 Xcode로 개발된 일부 앱의 플레임 그래프를 생성할 수 있습니다.

플레임 그래프를 만드는 데 일반적으로 사용되는 도구는 Xcode에 포함된 Instruments입니다. Instruments의 Time Profiler를 사용하여 스택을 캡처하고 [flamegraph.pl](https://github.com/brendangregg/FlameGraph/blob/master/flamegraph.pl)과 같은 도구를 사용하여 캡처된 데이터를 플레임 그래프로 변환할 수 있습니다. Time Profiler로 앱을 실행한 후 수집된 데이터를 플레임 그래프로 변환하면 애플리케이션의 성능 프로파일에 대한 인사이트를 얻을 수 있습니다.

#### Linux의 플레임 그래프

플레임 그래프는 대부분의 플랫폼에서 생성할 수 있으며, Linux의 Swift에서도 가능합니다. 이 섹션에서는 Linux에 초점을 맞춥니다.

설명을 위해, `TerribleArray` 데이터 구조를 활용하는 Linux의 *예제 플레임 그래프 프로그램*이 있습니다. 이 구조는 `Array`의 기대되는 _O(1)_ 분할 상환 시간 복잡도 대신 비효율적인 _O(n)_ 추가 연산을 수행합니다. 이로 인해 성능 문제가 발생하고 프로그램의 전반적인 효율성에 영향을 줄 수 있습니다.

```swift
/* a terrible data structure which has a subset of the operations that Swift's
 * array does:
 *  - retrieving elements by index
 *     --> user's reasonable performance expectation: O(1)   (like Swift's Array)
 *     --> implementation's actual performance:       O(n)
 *  - adding elements
 *     --> user's reasonable performance expectation: amortised O(1)   (like Swift's Array)
 *     --> implementation's actual performance:       O(n)
 *
 * ie. the problem I'm trying to demo here is that this is an implementation
 * where the user would expect (amortised) constant time access but in reality
 * is linear time.
 */
struct TerribleArray<T: Comparable> {
    /* this is a terrible idea: storing the index inside of the array (so we can
     * waste some performance later ;)
     */
    private var storage: Array<(Int, T)> = Array()

    /* oh my */
    private func maximumIndex() -> Int {
        return (self.storage.map { $0.0 }.max()) ?? -1
    }

    /* expectation: amortised O(1) but implementation is O(n) */
    public mutating func append(_ value: T) {
        let maxIdx = self.maximumIndex()
        self.storage.append((maxIdx + 1, value))
        assert(self.storage.count == maxIdx + 2)
    }

    /* expectation: O(1) but implementation is O(n) */
    public subscript(index: Int) -> T? {
        get {
            return self.storage.filter({ $0.0 == index }).first?.1
        }
    }
}

protocol FavouriteNumbers {
    func addFavouriteNumber(_ number: Int)
    func isFavouriteNumber(_ number: Int) -> Bool
}

public class MyFavouriteNumbers: FavouriteNumbers {
    private var storage: TerribleArray<Int>
    public init() {
        self.storage = TerribleArray<Int>()
    }

    /* - user's expectation: O(n)
     * - reality O(n^2) because of TerribleArray */
    public func isFavouriteNumber(_ number: Int) -> Bool {
        var idx = 0
        var found = false
        while true {
            if let storageNum = self.storage[idx] {
                if number == storageNum {
                    found = true
                    break
                }
            } else {
                break
            }
            idx += 1
        }
        return found
    }

    /* - user's expectation: amortised O(1)
     * - reality O(n) because of TerribleArray */
    public func addFavouriteNumber(_ number: Int) {
        self.storage.append(number)
        precondition(self.isFavouriteNumber(number))
    }
}

let x: FavouriteNumbers = MyFavouriteNumbers()

for f in 0..<2_000 {
    x.addFavouriteNumber(f)
}
```

**플레임 그래프 생성**

Linux에서 Swift의 플레임 그래프를 생성하려면 `perf`와 `FlameGraph` 스크립트를 결합하여 CPU 사용량 및 스택 트레이스에 대한 데이터를 수집할 수 있습니다. 그런 다음 플레임 그래프 도구를 사용하여 시각화하여 애플리케이션의 성능 특성에 대한 인사이트를 얻을 수 있습니다:

1. Linux용 `perf`를 [설치하고 구성](/server/guides/linux-perf.html)합니다.
2. `swift build -c release`를 사용하여 코드를 `./slow`라는 바이너리로 컴파일합니다:

   a. 터미널을 열고 Swift 코드가 있는 디렉터리(보통 Swift 패키지의 루트 디렉터리)로 이동합니다.

   b. 다음 명령을 실행하여 릴리스 모드로 코드를 컴파일하고 성능을 최적화합니다:

   ```
   swift build -c release
   ```

   빌드 프로세스가 성공적으로 완료되면 Swift 패키지 디렉터리 내의 `.build/release/` 디렉터리에서 컴파일된 바이너리를 찾을 수 있습니다.

   c. 다음 명령을 사용하여 컴파일된 바이너리를 현재 디렉터리로 복사하고 `slow`로 이름을 변경합니다:

   ```
   cp .build/release/YourExecutableName ./slow
   ```

   `YourExecutableName`을 실제 컴파일된 바이너리 이름으로 교체하세요.

3. `~/FlameGraph` 디렉터리에 저장소를 클론합니다:

   ```
   git clone https://github.com/brendangregg/FlameGraph
   ```

4. 99 Hz 샘플링 주파수로 스택 프레임을 기록하려면 다음 명령을 실행합니다:
   ```
   sudo perf record -F 99 --call-graph dwarf -- ./slow
   ```

또는 기존 프로세스에 연결하려면:
`     sudo perf record -F 99 --call-graph dwarf -p PID_OF_SLOW
    `

5. 다음 명령을 실행하여 기록을 `out.perf`로 내보냅니다:

   ```
   sudo perf script > out.perf
   ```

6. 기록된 스택을 집계하고 심볼을 디맹글링합니다:

   ```
   ~/FlameGraph/stackcollapse-perf.pl out.perf | swift demangle > out.folded
   ```

7. 함수와 상대적 CPU 사용량을 시각적으로 나타내는 SVG 파일로 결과를 내보냅니다:
   ```
   ~/FlameGraph/flamegraph.pl out.folded > out.svg # Produce
   ```

생성된 플레임 그래프 파일은 아래와 비슷해야 합니다:

![플레임 그래프](/assets/images/server-guides/perf-issues-flamegraph.svg)

플레임 그래프에서 `isFavouriteNumber`가 런타임의 대부분을 소비하며 `addFavouriteNumber`에서 호출되는 것을 확인할 수 있습니다. 이 결과는 개선이 필요한 부분을 알려줍니다.

> 참고: `Set<Int>`를 사용하여 `FavouriteNumber`를 저장하면 숫자가 `FavouriteNumber`인지 상수 시간 *(O(1))*으로 확인할 수 있습니다.

### Malloc 라이브러리

Swift에서 메모리 할당 및 해제는 주로 [자동 참조 카운팅(ARC)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/) 메커니즘에 의해 관리됩니다. 특정 경우에는 C나 다른 언어와의 인터페이스에서 _malloc_ 라이브러리를 사용하거나 메모리 관리에 대한 더 세밀한 제어가 필요할 수 있습니다. 예를 들어, 메모리 할당 서브시스템에 상당한 부하를 주는 워크로드에 사용자 정의 malloc 라이브러리를 사용할 수 있습니다. 코드 변경은 필요 없지만, 서버를 실행하기 전에 환경 변수로 인터포즈해야 합니다.

> 팁: 기본 메모리 할당자와 사용자 정의 메모리 할당자를 벤치마크하여 지정된 워크로드에 얼마나 도움이 되는지 확인하는 것이 좋습니다.

멀티 스레드 환경에서 특히 성능 문제를 해결하기 위해 설계된 특수 메모리 할당 라이브러리가 있습니다:

- [TCMalloc](https://github.com/google/tcmalloc)은 Google 환경에서의 속도와 확장성에 맞춰 조정되었습니다.
- [Jemalloc](https://jemalloc.net/)은 더 넓은 범위의 애플리케이션에서 단편화 감소와 효율성을 강조합니다.

다른 `malloc` 구현도 존재하며 일반적으로 LD_PRELOAD를 사용하여 활성화할 수 있습니다:

```bash
> LD_PRELOAD=/usr/bin/libjemalloc.so  myprogram
```

이러한 라이브러리 간의 선택은 애플리케이션이나 시스템의 구체적인 성능 요구사항과 특성에 따라 달라집니다.

요약하면, Swift 서버 애플리케이션에 성능 도구를 사용하면 성능을 최적화하고, 사용자 경험을 향상시키며, 확장성을 계획하고, 프로덕션 환경에서 서버 애플리케이션의 효율적인 운영을 보장하는 데 도움이 됩니다.
