---
redirect_from: 'server/guides/libraries/concurrency-adoption-guidelines'
layout: page
title: Swift 동시성 도입 가이드라인
---

이 문서는 서버사이드 Swift 라이브러리 작성자가 따를 수 있는 가이드라인을 제공합니다. 특히 Swift NIO의 `EventLoopFuture` 및 관련 타입을 광범위하게 사용하는 기존 API와 라이브러리를 어떻게 처리할지에 대한 논의가 중심입니다.

Swift 동시성은 다년간의 노력입니다. 서버 커뮤니티가 동시성 기능의 다년간 도입에 참여하고 피드백을 제공하는 것은 매우 가치 있습니다. 따라서 귀중한 동시성 모델 개선 기회를 놓칠 수 있으므로 Swift 6까지 동시성 기능 도입을 미루어서는 안 됩니다.

2021년에 Swift 5.5와 함께 구조적 동시성과 액터가 도입되었습니다. 이제 이러한 원시 타입을 사용하는 API를 제공하기에 좋은 시점입니다. 앞으로 완전히 검사된 Swift 동시성이 도입될 예정이며, 이는 호환성을 깨는 변경을 수반합니다. 이러한 이유로 새로운 동시성 기능의 도입은 두 단계로 나눌 수 있습니다.

## 지금 할 수 있는 것

### API 설계

먼저, 기존 라이브러리는 가능한 곳에서 기존 `*Future` 기반 API에 추가로 사용자 대면 "표면" API에 `async` 함수를 추가해야 합니다. 이러한 추가 API는 Swift 버전에 따라 조건부로 적용할 수 있으며, 기존 사용자의 코드를 깨뜨리지 않고 추가할 수 있습니다. 예를 들어:

```swift
extension Worker {
  func work() -> EventLoopFuture<Value> { ... }

  #if compiler(>=5.5) && canImport(_Concurrency)
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
  func work() async throws -> Value { ... }
  #endif
}
```

함수가 실패할 수 없지만 이전에 Future를 사용했다면, 새 버전에는 `throws` 키워드를 포함해서는 안 됩니다.

이러한 도입은 즉시 시작할 수 있으며, 기존 라이브러리 사용자에게 문제를 일으키지 않아야 합니다.

### SwiftNIO 헬퍼 함수

async 코드로의 쉬운 전환을 위해 SwiftNIO는 `EventLoopFuture` 및 `-Promise`에 대한 여러 헬퍼 메서드를 제공합니다.

모든 `EventLoopFuture`에서 `.get()`을 호출하여 Future를 `await` 가능한 호출로 전환할 수 있습니다. async/await 호출을 `EventLoopFuture`로 변환하려면 다음 패턴을 권장합니다:

```swift
#if compiler(>=5.5) && canImport(_Concurrency)

func yourAsyncFunctionConvertedToAFuture(on eventLoop: EventLoop)
    -> EventLoopFuture<Result> {
    let promise = context.eventLoop.makePromise(of: Out.self)
    promise.completeWithTask {
        try await yourMethod(yourInputs)
    }
    return promise.futureResult
}
#endif
```

`EventLoopGroup`, `Channel`, `ChannelOutboundInvoker`, `ChannelPipeline`에 대한 추가 헬퍼도 있습니다.

### 동시성 사용 코드의 `#if` 가드

동시성을 사용하는 코드와 사용하지 않는 코드를 함께 사용하려면 특정 코드 조각에 `#if` 가드를 적용해야 할 수 있습니다. 올바른 방법은 다음과 같습니다:

```swift
#if compiler(>=5.5) && canImport(_Concurrency)
...
#endif
```

`_Concurrency`를 직접 *import*할 필요는 _없습니다_. 사용 가능한 경우 자동으로 import됩니다.

```swift
#if compiler(>=5.5) && canImport(_Concurrency)
// DO NOT DO THIS.
// Instead don't do any import and it'll import automatically when possible.
import _Concurrency
#endif
```

### Sendable 검사

> [SE-0302][SE-0302]는 `Sendable` 프로토콜을 도입했습니다. 이 프로토콜은 액터 간에 또는 더 일반적으로 값의 복사본이 원본과 동시에 사용될 수 있는 모든 컨텍스트에 안전하게 복사할 수 있는 값을 가진 타입을 나타내는 데 사용됩니다. 모든 Swift 코드에 균일하게 적용되는 `Sendable` 검사는 공유 가변 상태로 인한 대규모 데이터 레이스를 제거합니다.
>
> -- [Sendable 검사 단계적 도입][sendable-staging]에서 발췌. Swift 6의 `Sendable` 도입 계획을 설명합니다.

앞으로 완전히 검사된 Swift 동시성이 도입될 예정입니다. 이를 지원하는 언어 기능은 `Sendable` 프로토콜과 클로저를 위한 `@Sendable` 키워드입니다. Sendable 검사는 기존 Swift 코드를 깨뜨리므로 새로운 주요 Swift 버전이 필요합니다.

완전히 검사된 Swift 코드로의 전환을 용이하게 하기 위해, 현재 API에 `Sendable` 프로토콜을 어노테이션할 수 있습니다.

Swift 5.5에서 `-warn-concurrency` 플래그를 전달하여 Sendable을 도입하고 적절한 경고를 받을 수 있습니다. SwiftPM에서 전체 프로젝트에 적용하려면:

```
swift build -Xswiftc -Xfrontend -Xswiftc -warn-concurrency
```

#### 현재의 Sendable 검사

Sendable 검사는 현재 Swift 5.5(.0)에서 비활성화되어 있는데, 해결할 도구가 부족한 여러 까다로운 상황을 야기했기 때문입니다.

이러한 대부분의 문제는 현재 컴파일러의 `main` 브랜치에서 해결되었으며, 다음 Swift 5.5 릴리스에 반영될 예정입니다. 5.5.0 이후 다음 버전까지 도입을 기다리는 것이 좋을 수 있습니다.

예를 들어, 이러한 기능 중 하나는 `Sendable` 타입의 튜플이 `Sendable`에 준수하는 기능입니다. 이 패치가 Swift 5.5에 반영될 때까지(비교적 빨리 반영될 예정) `Sendable` 도입을 보류하는 것을 권장합니다. 이 변경으로 `-warn-concurrency`가 활성화된 Swift 5.5와 Swift 6 모드 사이의 차이는 매우 작아지며, 사례별로 관리할 수 있습니다.

#### 선언의 하위 호환성과 "검사된" Swift 동시성

Swift 동시성을 도입하면 점진적으로 더 많은 경고가 발생하고, 결국 Swift 6에서는 Sendability 검사가 위반될 때 컴파일 타임 오류가 발생하여 잠재적으로 안전하지 않은 코드를 표시합니다.

Swift 6 이전 버전과 호환되는 버전을 유지하면서 새로운 동시성 검사를 완전히 수용하기 어려울 수 있습니다. 예를 들어, 제네릭 타입을 다음과 같이 `Sendable`로 표시해야 할 수 있습니다:

```swift
struct Container<Value: Sendable>: Sendable { ... }
```

여기서 `Value` 타입은 Swift 6의 동시성 검사가 이러한 컨테이너와 올바르게 작동하려면 `Sendable`로 표시해야 합니다. 그러나 `Sendable` 타입은 Swift 5.5 이전에는 존재하지 않으므로, Swift 5.4+와 Swift 6 모두를 지원하는 라이브러리를 유지하기 어려울 수 있습니다.

이러한 상황에서는 다음과 같은 트릭을 활용하여 라이브러리의 두 Swift 버전 간에 동일한 `Container` 선언을 공유할 수 있습니다:

```swift
#if swift(>=5.5) && canImport(_Concurrency)
public typealias MYPREFIX_Sendable = Swift.Sendable
#else
public typealias MYPREFIX_Sendable = Any
#endif
```

> **참고:** 여기서는 `swift(>=5.5)`를 사용하고, 동시성 기능을 사용하는 특정 API를 가드할 때는 `compiler(>=5.5)`를 사용합니다.

`Any` alias는 제네릭 제약조건으로 적용될 때 실질적으로 아무 작업도 하지 않으므로, 이 방법으로 동일한 `Container<Value>` 선언을 Swift 버전 간에 동작하게 유지할 수 있습니다.

### Task 로컬 값과 로깅

새로 도입된 Task 로컬 값 API([SE-0311][SE-0311])는 `Task` 실행과 함께 메타데이터를 암시적으로 전달할 수 있게 합니다. 트레이싱과 Task 실행에 메타데이터를 전달하고 로그 메시지에 포함하는 데 자연스럽게 적합합니다.

현재 [SwiftLog](https://github.com/apple/swift-log)를 조정하여 특정 Task 로컬 값을 자동으로 가져와 로깅할 수 있을 만큼 강력하게 만드는 작업을 진행하고 있습니다. 이 변경은 소스 호환되는 방식으로 도입될 예정입니다.

현재로서는 라이브러리에서 logger 메타데이터를 계속 사용해야 하지만, 앞으로 메타데이터를 각 로그 문에 수동으로 전달하는 많은 경우를 Task 로컬 값 설정으로 대체할 수 있을 것으로 기대합니다.

### 데드라인 개념 준비

데드라인은 Swift 동시성과 밀접하게 관련된 또 다른 기능으로, 원래 구조적 동시성 제안의 초기 버전에서 제안되었다가 나중에 분리되었습니다. Swift 팀은 데드라인 개념을 언어에 도입하는 데 여전히 관심이 있으며, 동시성 런타임 내에서 이미 일부 준비 작업이 수행되었습니다. 그러나 현재 Swift 동시성에서 데드라인은 지원되지 않으며, `NIODeadline`이나 유사한 메커니즘을 사용하여 일정 시간이 지난 후 Task를 취소하는 것은 괜찮습니다.

Swift 동시성에 데드라인 지원이 추가되면, 데드라인(시점)이 초과되었을 때 Task(및 하위 Task)를 취소할 수 있게 됩니다. API가 "데드라인에 대비"하려면 `Task`와 그 취소를 처리할 수 있도록 준비하는 것 외에 특별한 작업은 필요 없습니다.

### Task 취소의 협력적 처리

`Task` 취소는 현재 Swift 동시성에 존재하며 라이브러리에서 이미 처리할 수 있는 기능입니다. 실질적으로, `Task` 내에서 호출될 것으로 예상되는 비동기 함수(또는 함수)가 [`Task.isCancelled`](https://developer.apple.com/documentation/swift/task/3814832-iscancelled) 또는 [`try Task.checkCancellation()`](https://developer.apple.com/documentation/swift/task/3814826-checkcancellation) API를 사용하여 실행 중인 Task가 취소되었는지 확인하고, 취소된 경우 현재 수행 중인 작업을 협력적으로 중단할 수 있습니다.

취소는 장시간 실행되는 작업이나 비용이 많이 드는 작업을 시작하기 전에 유용할 수 있습니다. 예를 들어, HTTP 클라이언트는 요청을 보내기 전에 취소를 확인할 수 있습니다 — 결과를 기다리는 Task가 더 이상 결과에 관심이 없다면 요청을 보내는 것이 의미가 없을 수 있습니다!

일반적으로 취소는 "이 Task의 결과를 기다리는 쪽이 더 이상 관심이 없다"로 이해할 수 있으며, 취소가 발견되면 보통 "cancelled" 오류를 던지는 것이 가장 좋습니다. 그러나 일부 상황에서는 "부분적" 결과를 반환하는 것이 적절할 수도 있습니다(예: Task가 여러 결과를 수집하는 경우, 취소를 무시하고 나머지 결과를 모두 수집하거나 아무것도 반환하지 않는 대신, 지금까지 수집한 결과를 반환할 수 있습니다).

## Swift 6에서 기대할 수 있는 것

### Sendable: 전역 변수와 임포트된 코드

현재 Swift 5.5는 동시성 검사 모델에서 전역 변수를 아직 처리하지 않습니다. 이는 곧 변경되겠지만 정확한 의미론은 아직 확정되지 않았습니다. 일반적으로, 향후 문제를 피하기 위해 가능한 한 전역 프로퍼티와 변수의 사용을 피하세요. 가능하다면 전역 변수를 더 이상 사용하지 않도록 표시하는 것을 고려하세요.

일부 전역 변수는 특별한 속성을 가지고 있습니다. 예를 들어 시스템 호출의 오류 코드를 포함하는 `errno`는 스레드 로컬 변수이므로 어떤 스레드/`Task`에서든 안전하게 읽을 수 있습니다. 이러한 전역 변수에 대해 완전히 검사된 동시성 모드에서도 경고가 발생하지 않도록 "안전한 것으로 알려진" 어노테이션으로 표시하도록 임포터를 개선할 계획입니다. 다만, `errno` 및 기타 "스레드 로컬" API는 Swift 동시성에서 매우 오류가 발생하기 쉽습니다. 중단점에서 스레드 전환이 발생할 수 있으므로 다음 코드 조각은 매우 높은 확률로 잘못되었습니다:

```swift
sys_call(...)
await ...
let err = errno // BAD, we are most likely on a different thread here (!)
```

Swift 동시성에서 스레드 로컬 API와 상호 작용할 때 주의하세요. 라이브러리에서 이전에 스레드 로컬 스토리지를 사용했다면, Swift의 구조적 동시성 Task와 올바르게 작동하는 [Task 로컬 값](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0311-task-locals.md)으로 마이그레이션해야 합니다.

임포트된 C 코드의 또 다른 까다로운 상황이 있습니다. 임포트된 타입을 Sendable로 어노테이션할 좋은 방법이 없을 수 있으며(또는 수동으로 하기에 너무 번거로울 수 있습니다). Swift는 임포트된 코드에 대한 개선된 지원을 얻고 잠재적으로 임포트된 코드에 대한 일부 동시성 안전 검사를 무시할 수 있게 될 것입니다.

임포트된 코드에 대한 이러한 완화된 의미론은 아직 구현되지 않았지만, C API에서 Swift를 사용하고 현재 `-warn-concurrency` 모드를 도입하려고 할 때 이를 염두에 두세요. 발견한 문제는 [bugs.swift.org](https://bugs.swift.org/secure/Dashboard.jspa)에 제출하여 실제 문제를 기반으로 검사 휴리스틱 개발에 기여해 주세요.

### 커스텀 실행자(Custom Executors)

Swift 동시성이 앞으로 커스텀 실행자를 허용할 것으로 기대합니다. 커스텀 실행자는 액터/Task를 해당 실행자 "위에서" 실행할 수 있게 합니다. `EventLoop`가 이러한 실행자가 될 가능성이 있지만, 커스텀 실행자 제안은 아직 제안되지 않았습니다.

"동일한 이벤트 루프에서" 커스텀 실행자를 사용하면 서로 다른 액터 간의 비동기 홉을 피함으로써 잠재적인 성능 향상을 기대할 수 있지만, 커스텀 실행자의 도입이 NIO 라이브러리의 구조를 근본적으로 변경하지는 않을 것입니다.

커스텀 실행자에 대한 Swift Evolution 제안이 제안됨에 따라 가이드가 발전할 것이지만, 커스텀 실행자가 "도입"될 때까지 Swift 동시성 도입을 미루지 마세요 — 조기 도입이 중요합니다. 대부분의 코드에서 Swift 동시성 도입의 이점이 액터 홉으로 인한 약간의 성능 비용을 크게 상회한다고 생각합니다.

### SwiftNIO Future의 "동시성 라이브러리"로서의 사용 줄이기

SwiftNIO는 현재 Swift on Server 생태계를 위한 여러 동시성 타입을 제공합니다. 가장 주목할 만한 것은 비동기 결과에 널리 사용되는 `EventLoopFuture`와 `EventLoopPromise`입니다. SSWG는 과거에 서버 라이브러리 간의 쉬운 상호 운용을 위해 API 수준에서 이를 사용할 것을 권장했지만, Swift 6이 출시되면 이러한 API를 더 이상 사용하지 않거나 제거할 것을 권고합니다. Swift on Server 생태계는 언어가 제공하는 구조적 동시성 기능에 올인해야 합니다. 이러한 이유로 오늘 async/await API를 제공하는 것이 중요하며, 라이브러리 사용자에게 새 API를 도입할 시간을 주어야 합니다.

그러나 일부 NIO 타입은 Swift on Server 라이브러리의 공개 인터페이스에 남을 것입니다. 네트워킹 클라이언트와 서버는 계속해서 `EventLoopGroup`으로 초기화될 것으로 예상됩니다. 기본 전송 메커니즘(`NIOPosix` 및 `NIOTransportServices`)은 구현 세부 사항이 되어야 하며 라이브러리 사용자에게 노출되어서는 안 됩니다.

### SwiftNIO 3

변경될 수 있지만, SwiftNIO가 Swift 6.0 이후 몇 달 내에 3.0 릴리스를 할 가능성이 높으며, 그 시점에서 Swift는 "전체" `Sendable` 검사를 활성화했을 것입니다.

NIO가 갑자기 "더 async"해질 것으로 기대해서는 안 됩니다. NIO의 본질적인 설계 원칙은 이벤트 루프에서 작은 작업을 수행하고 비동기 작업에 Future를 사용하는 것입니다. NIO의 설계는 변경될 것으로 예상되지 않습니다. 채널 파이프라인은 Swift 동시성 의미의 "async"가 될 것으로 예상되지 않습니다. SwiftNIO는 본질적으로 I/O 시스템이며, 이는 Swift 동시성이 사용하는 협력적, 공유 스레드 풀에 도전을 제기하기 때문입니다. 이 스레드 풀은 어떤 작업에 의해서도 차단되어서는 안 됩니다. 그렇게 하면 풀이 고갈되어 다른 비동기 Task의 진행이 막힙니다.

그러나 I/O 시스템은 어느 시점에서 I/O 시스템 호출이나 epoll*wait와 같은 것에서 더 많은 I/O 이벤트를 기다리며 스레드를 차단해야 합니다. 이것이 NIO의 작동 방식입니다: 각 이벤트 루프 스레드는 궁극적으로 epoll_wait에서 차단됩니다. 협력적 스레드 풀 내에서는 이를 수행할 수 없습니다. 그렇게 하면 다른 비동기 Task의 풀이 고갈되므로 다른 스레드에서 수행해야 합니다. 따라서 SwiftNIO는 협력적 스레드 풀 *위에서\_ 사용되어서는 안 되며, 자체 스레드의 소유권과 완전한 제어를 가져야 합니다 — I/O 시스템이기 때문입니다.

모든 NIO 작업을 협력적 풀에서 수행하고 각 I/O 작업과 async/await 풀로의 디스패치 사이에 스레드 홉을 하는 것이 가능하지만, 고성능 I/O에는 허용되지 않습니다: *각 I/O 작업*에 대한 컨텍스트 스위치가 너무 비용이 높습니다. 결과적으로 SwiftNIO는 사용 편의성 때문에 Swift 동시성을 도입하려는 계획이 없습니다. 해당 컨텍스트에서 컨텍스트 스위치는 허용 가능한 트레이드오프가 아니기 때문입니다. 그러나 SwiftNIO는 언어 런타임에 "커스텀 실행자"가 도입되면 Swift 동시성과 협력할 수 있지만, 이에 대해 아직 완전히 제안되지 않았으므로 너무 많은 추측은 하지 않겠습니다.

NIO 팀은 그러나 이 기회를 활용하여 더 이상 사용되지 않는 API를 제거하고 일부 API를 개선할 것입니다. 변경 범위는 NIO1 → NIO2 버전 범프와 비슷해야 합니다. SwiftNIO 코드가 현재 경고 없이 컴파일된다면, NIO3에서도 수정 없이 계속 작동할 가능성이 높습니다.

NIO3 릴리스 이후 NIO2는 버그 수정만 받게 됩니다.

### 최종 사용자 코드 호환성 깨짐

Swift 6이 일부 코드를 깨뜨릴 것으로 예상됩니다. 앞서 언급한 대로 SwiftNIO 3도 Swift 6 출시 무렵에 릴리스될 예정입니다. 이를 감안하여, 라이브러리에서 Swift 6 및 NIO 3로의 버전 요구사항 업데이트와 함께 같은 시기에 주요 버전 릴리스를 맞추는 것이 좋을 수 있습니다.

Swift와 SwiftNIO 모두 "대량의 변경"을 계획하고 있지 않으므로, 큰 어려움 없이 도입이 가능해야 합니다.

### 라이브러리 사용자를 위한 가이드

Swift 6이 출시되면, Swift 5.5.n 언어 모드를 사용하더라도(실패한 Sendability 검사에 대해 하드 실패 대신 경고만 발생할 수 있음) 최신 Swift 6 툴체인을 사용하는 것을 권장합니다. 이렇게 하면 5.5 툴체인만 사용하는 것보다 더 나은 경고와 컴파일러 힌트를 얻을 수 있습니다.

[sendable-staging]: https://github.com/DougGregor/swift-evolution/blob/sendable-staging/proposals/nnnn-sendable-staging.md
[SE-0302]: https://github.com/swiftlang/swift-evolution/blob/main/proposals/0302-concurrent-value-and-concurrent-closures.md
[SE-0311]: https://github.com/swiftlang/swift-evolution/blob/main/proposals/0311-task-locals.md
