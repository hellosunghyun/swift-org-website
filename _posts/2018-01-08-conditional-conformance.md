---
layout: new-layouts/post
published: true
date: 2018-01-08 12:00:00
title: Swift 4.1의 조건부 적합성
author: airspeedswift
category: "Language"
---

Swift 4.1 컴파일러가 [제네릭 로드맵][GenericsManifesto]의 다음 단계 개선 사항인 [조건부 적합성][SE-0143]을 제공합니다.

이 글에서는 많은 기대를 받아온 이 기능이 Swift 표준 라이브러리에 어떻게 적용되었는지, 그리고 여러분과 여러분의 코드에 어떤 영향을 미치는지 살펴보겠습니다.

## Equatable 컨테이너

조건부 적합성의 가장 눈에 띄는 이점은 `Array`나 `Optional`처럼 다른 타입을 저장하는 타입이 `Equatable` 프로토콜을 준수할 수 있게 된 것입니다. 이 프로토콜은 타입의 두 인스턴스 간에 `==`를 사용할 수 있음을 보장합니다. 이 프로토콜 준수가 왜 유용한지 살펴보겠습니다.

equatable 요소로 이루어진 두 배열에는 항상 `==`를 사용할 수 있었습니다:

~~~swift
[1,2,3] == [1,2,3]     // true
[1,2,3] == [4,5]       // false
~~~

또는 equatable 타입을 감싸는 두 옵셔널에도:

~~~swift
// The failable initializer from a String returns an Int?
Int("1") == Int("1")                        // true
Int("1") == Int("2")                        // false
Int("1") == Int("swift")                    // false, Int("swift") is nil
~~~

이는 `Array`에 대한 다음과 같은 `==` 연산자 오버로드를 통해 가능했습니다:

~~~swift
extension Array where Element: Equatable {
    public static func ==(lhs: [Element], rhs: [Element]) -> Bool {
        return lhs.elementsEqual(rhs)
    }
}
~~~

하지만 `==`를 구현했다고 해서 `Array`나 `Optional`이 `Equatable`을 준수하는 것은 아니었습니다. 이러한 타입은 equatable이 아닌 타입을 저장할 수도 있으므로, equatable 타입을 저장할 때만 equatable이라는 것을 표현할 수 있어야 했습니다.

이는 이러한 `==` 연산자에 큰 제한이 있었음을 의미합니다: 두 레벨 깊이에서는 사용할 수 없었습니다. Swift 4.0에서 이런 코드를 시도했다면:

~~~swift
// convert a [String] to [Int?]
let a = ["1","2","x"].map(Int.init)

a == [1,2,nil]    // expecting 'true'
~~~

컴파일러 오류가 발생했을 것입니다:

> Binary operator '==' cannot be applied to two '[Int?]' operands.

이는 위에서 보았듯이 `Array`의 `==` 구현이 배열의 요소가 equatable이어야 하는데, `Optional`이 equatable이 아니었기 때문입니다.

조건부 적합성으로 이 문제를 해결할 수 있습니다. 기반 타입이 equatable인 경우, 이미 정의된 `==` 연산자를 사용하여 이러한 타입이 `Equatable`을 준수한다고 작성할 수 있습니다:

~~~swift
extension Array: Equatable where Element: Equatable {
    // implementation of == for Array
}

extension Optional: Equatable where Wrapped: Equatable {
    // implementation of == for Optional
}
~~~

`Equatable` 준수는 `==` 외에도 다른 이점을 가져다줍니다. equatable 요소를 가지면 컬렉션에 검색과 같은 작업을 위한 헬퍼 함수를 사용할 수 있습니다:

~~~swift
a.contains(nil)                 // true
[[1,2],[3,4],[]].index(of: [])  // 2
~~~

조건부 적합성을 사용하여, Swift 4.1의 `Optional`, `Array`, `Dictionary`는 이제 값이나 요소가 해당 프로토콜을 준수할 때마다 `Equatable`과 `Hashable`을 준수합니다.

이 접근 방식은 `Codable`에도 적용됩니다. codable이 아닌 타입의 배열을 인코딩하려고 하면, 이전에 발생하던 런타임 트랩 대신 컴파일 타임 오류가 발생합니다.

## 컬렉션 프로토콜

조건부 적합성은 코드 중복을 피하면서 타입의 기능을 점진적으로 구축하는 데에도 이점이 있습니다. 조건부 적합성을 사용하여 Swift 표준 라이브러리에서 가능해진 변경 사항을 탐구하기 위해, `Collection`에 새로운 기능인 지연 분할(lazy splitting)을 추가하는 예제를 사용하겠습니다. 컬렉션에서 분할된 슬라이스를 제공하는 새로운 타입을 만든 다음, 기반 컬렉션이 양방향일 때 조건부 적합성으로 양방향 기능을 추가하는 방법을 살펴보겠습니다.

### 즉시 실행 vs 지연 분할

Swift의 `Sequence` 프로토콜에는 시퀀스를 부분 시퀀스의 `Array`로 분할하는 `split` 메서드가 있습니다:

~~~swift
let numbers = "15,x,25,2"
let splits = numbers.split(separator: ",")
// splits == ["15","x","25","2"]
var sum = 0
for i in splits {
    sum += Int(i) ?? 0
}
// sum == 42
~~~

이 `split` 메서드를 "즉시 실행(eager)"이라고 부르는데, 호출하는 즉시 시퀀스를 부분 시퀀스로 분할하여 배열에 넣기 때문입니다.

하지만 처음 몇 개의 부분 시퀀스만 필요하다면 어떨까요? 거대한 텍스트 파일이 있고 미리보기로 처음 몇 줄만 가져오고 싶다고 합시다. 처음 몇 줄만 사용하기 위해 전체 파일을 처리하는 것은 바람직하지 않습니다.

이런 종류의 문제는 Swift에서 기본적으로 즉시 실행되는 `map`이나 `filter` 같은 연산에도 적용됩니다. 이를 피하기 위해 표준 라이브러리에는 "지연(lazy)" 시퀀스와 컬렉션이 있습니다. `lazy` 프로퍼티를 통해 접근할 수 있습니다. 이러한 지연 시퀀스와 컬렉션은 즉시 실행되지 않는 `map` 같은 연산 구현을 제공합니다. 대신 요소에 접근할 때 매핑이나 필터링을 그때그때 수행합니다. 예를 들어:

~~~swift
// a huge collection
let giant = 0..<Int.max
// lazily map it: no work is done yet
let mapped = giant.lazy.map { $0 * 2 }
// sum the first few elements
let sum = mapped.prefix(10).reduce(0, +)
// sum == 90
~~~

`mapped` 컬렉션이 생성될 때는 매핑이 수행되지 않습니다. 사실 `giant`의 모든 요소에 매핑 연산을 수행하면 트랩이 발생합니다: 값을 두 배로 만드는 것이 `Int`에 맞지 않는 중간 지점에서 오버플로우가 발생하기 때문입니다. 하지만 지연 `map`에서는 요소에 접근할 때만 매핑이 수행됩니다. 따라서 이 예제에서는 `reduce` 연산이 합계를 구할 때 처음 열 개의 값만 계산됩니다.

### 지연 분할 래퍼

표준 라이브러리에는 지연 분할 연산이 없습니다. 아래는 이것이 어떻게 동작할 수 있는지에 대한 스케치입니다. Swift에 기여하는 데 관심이 있다면, 이것은 훌륭한 [첫 이슈][Issue]이자 [에볼루션 제안][EvolutionProcess]이 될 수 있습니다.

먼저 모든 기반 컬렉션을 보유할 수 있는 간단한 제네릭 래퍼 구조체와, 분할할 요소를 식별하는 클로저를 만듭니다:

~~~swift
struct LazySplitCollection<Base: Collection> {
    let base: Base
    let isSeparator: (Base.Element) -> Bool
}
~~~

(이 글에서 코드를 간단하게 유지하기 위해 접근 제어 같은 것은 무시하겠습니다)

다음으로 `Collection` 프로토콜을 준수합니다. 컬렉션이 되려면 네 가지만 제공하면 됩니다: `startIndex`와 `endIndex`, 주어진 인덱스의 요소를 반환하는 `subscript`, 인덱스를 하나 앞으로 진행하는 `index(after:)` 메서드입니다.

이 컬렉션의 요소는 기반 컬렉션의 부분 시퀀스입니다(`"one,two,three"`에서 부분 문자열 `"one"`). 컬렉션의 부분 시퀀스는 부모 컬렉션과 동일한 인덱스 타입을 사용하므로, 기반 컬렉션의 인덱스를 우리의 인덱스로 재사용할 수 있습니다. 인덱스는 기반의 다음 부분 시퀀스의 시작 또는 끝이 됩니다.

~~~swift
extension LazySplitCollection: Collection {
    typealias Element = Base.SubSequence
    typealias Index = Base.Index

    var startIndex: Index { return base.startIndex }
    var endIndex: Index { return base.endIndex }

    subscript(i: Index) -> Element {
        let separator = base[i...].index(where: isSeparator)
        return base[i..<(separator ?? endIndex)]
    }

    func index(after i: Index) -> Index {
        let separator = base[i...].index(where: isSeparator)
        return separator.map(base.index(after:)) ?? endIndex
    }
}
~~~

다음 구분자를 찾고 그 사이의 시퀀스를 반환하는 작업은 `subscript`와 `index(after:)` 메서드에서 수행됩니다. 두 메서드 모두 주어진 인덱스부터 기반 컬렉션에서 다음 구분자를 검색합니다. 구분자가 없으면 `index(where:)`가 찾을 수 없음을 나타내는 `nil`을 반환하므로, 그 경우 `?? endIndex`를 사용하여 끝 인덱스로 대체합니다. 약간 까다로운 부분은 `index(after:)` 구현에서 구분자를 건너뛰는 것인데, [optional map][Optional.map]을 사용합니다.

### lazy 확장하기

이제 이 래퍼가 있으니, 모든 지연 컬렉션 타입을 확장하여 지연 분할 메서드에서 사용할 수 있도록 하려 합니다. 모든 지연 컬렉션은 `LazyCollectionProtocol`을 준수하므로, 이것을 우리의 메서드로 확장합니다:

~~~swift
extension LazyCollectionProtocol {
    func split(
        whereSeparator matches: @escaping (Element) -> Bool
    ) -> LazySplitCollection<Elements> {
        return LazySplitCollection(base: elements, isSeparator: matches)
    }
}
~~~

이런 메서드에서는 요소가 equatable일 때 클로저 대신 값을 받는 버전도 제공하는 것이 관례입니다:

~~~swift
extension LazyCollectionProtocol where Element: Equatable {
    func split(separator: Element) -> LazySplitCollection<Elements> {
        return LazySplitCollection(base: elements) { $0 == separator }
    }
}
~~~

이것으로 지연 서브시스템에 지연 분할 메서드를 추가했습니다:

~~~swift
let one = "one,two,three".lazy.split(separator: ",").first
// one == "one"
~~~

또한 사용자가 기대하듯이 이후의 연산도 지연되도록 지연 래퍼를 `LazyCollectionProtocol`로 표시합니다:

~~~swift
extension LazySplitCollection: LazyCollectionProtocol { }
~~~

### 조건부 양방향

이제 구분된 컬렉션에서 처음 몇 개의 요소를 효율적으로 분할할 수 있습니다. 마지막 몇 개는 어떨까요? `BidirectionalCollection`은 끝에서 인덱스를 뒤로 이동하는 `index(before:)` 메서드를 추가합니다. 이를 통해 양방향 컬렉션은 `last` 프로퍼티 같은 것을 지원할 수 있습니다.

분할하는 컬렉션이 양방향이라면, 분할 래퍼도 양방향으로 만들 수 있어야 합니다. Swift 4.0에서는 이 방법이 꽤 번거로웠습니다. `Base: BidirectionalCollection`을 요구하고 `BidirectionalCollection`을 구현하는 완전히 새로운 타입 `LazySplitBidirectionalCollection`을 추가한 다음, `where Base: BidirectionalCollection`인 `split` 메서드를 오버로드해야 했습니다.

이제 조건부 적합성으로 훨씬 간단한 해결책이 있습니다: 기반이 `BidirectionalCollection`을 준수할 때 `LazySplitCollection`도 `BidirectionalCollection`을 준수하게 만들면 됩니다.

~~~swift
extension LazySplitCollection: BidirectionalCollection
where Base: BidirectionalCollection {
    func index(before i: Index) -> Index {
        let reversed = base[..<base.index(before: i)].reversed()
        let separator = reversed.index(where: isSeparator)
        return separator?.base ?? startIndex
    }
}
~~~

여기서 양방향 컬렉션의 순서를 뒤집는 또 다른 지연 래퍼인 `reversed()`를 사용했습니다. 이를 통해 다음 구분자를 역방향으로 검색한 다음, 뒤집힌 컬렉션 인덱스의 `.base` 프로퍼티를 사용하여 기반 컬렉션의 인덱스로 돌아갈 수 있습니다.

이 하나의 새로운 메서드로, 지연 컬렉션에 `.last` 프로퍼티나 `reversed()` 메서드 같은 양방향 컬렉션의 기능에 접근할 수 있게 했습니다:

~~~swift
let backwards = "one,two,three"
                .lazy.split(separator: ",")
                .reversed().joined(separator: ",")
// backwards == "three,two,one"
~~~

이러한 점진적 조건부 적합성은 여러 독립적인 적합성을 결합해야 할 때 특히 빛을 발합니다. 기반이 mutable일 때 지연 분할자가 `MutableCollection`을 준수하도록 하고 싶다고 합시다. 이 두 적합성은 독립적입니다---mutable 컬렉션이 양방향일 필요는 없고 그 반대도 마찬가지입니다---따라서 두 가지의 가능한 모든 조합에 대해 특수화된 타입을 만들어야 했을 것입니다.

하지만 조건부 적합성을 사용하면 두 번째 조건부 적합성을 추가하기만 하면 됩니다.

이 기능은 표준 라이브러리의 `Slice` 타입에 꼭 필요한 것이었습니다. 이 타입은 모든 컬렉션 타입에 기본 슬라이싱 기능을 제공합니다. 지연 분할자를 슬라이싱하면 사용되는 것을 볼 수 있습니다:

~~~swift
// dropFirst() creates a slice without the first element of a collection
let slice = "a,b,c".lazy.split(separator: ",").dropFirst()
print(type(of: slice))
// prints: Slice<LazySplitCollection<String>>
~~~

Swift 4에서는 최악의 경우 `MutableRangeReplaceableRandomAccessSlice`까지 십여 개의 서로 다른 구현이 필요했습니다. 이제 조건부 적합성을 사용하면 4개의 서로 다른 조건부 적합성을 가진 하나의 `Slice` 타입으로 충분합니다. 이 변경만으로도 표준 라이브러리의 바이너리 크기가 5% 감소했습니다.

### 추가 실험

즉시 실행 `split`에 익숙하다면 우리 구현에 빈 부분 시퀀스 병합 같은 일부 기능이 빠져 있음을 알 수 있습니다. 래퍼에 다음 구분자의 위치를 캐싱하는 자체 커스텀 인덱스를 부여하는 것과 같은 성능 최적화도 가능합니다.

처음부터 자신만의 지연 래퍼를 작성해 보고 싶다면, 한 번에 길이 n의 슬라이스를 제공하는 "청킹" 래퍼도 고려해 볼 수 있습니다. 이 경우는 흥미로운데, 기반이 랜덤 액세스라면 `BidirectionalCollection`으로 만들 수 있지만, 기반이 양방향인 경우에는 마지막 요소의 길이를 상수 시간에 계산할 수 있어야 하므로 그렇게 할 수 없기 때문입니다.

조건부 적합성은 현재 Swift 4.1 개발 툴체인에서 사용할 수 있으므로, [최신 스냅샷을 다운로드][Download]하여 사용해 보세요!

[GenericsManifesto]: https://github.com/apple/swift/blob/master/docs/GenericsManifesto.md
[SE-0143]: https://github.com/swiftlang/swift-evolution/blob/master/proposals/0143-conditional-conformances.md
[Optional.map]: https://developer.apple.com/documentation/swift/optional/#topics
[Issue]: https://github.com/apple/swift/issues/49240
[EvolutionProcess]: https://www.swift.org/swift-evolution
[Download]: /download/#snapshots
