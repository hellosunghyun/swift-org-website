---
layout: new-layouts/post
date: 2018-09-26 10:00:00
title: Swift에서 Mirror의 동작 원리
author: mikeash
category: "Language"
---

Swift는 정적 타이핑에 많은 중점을 두지만, 타입에 대한 풍부한 메타데이터도 지원하여 코드가 런타임에 임의의 값을 검사하고 조작할 수 있게 합니다. 이는 `Mirror` API를 통해 Swift 프로그래머에게 제공됩니다. 정적 타입에 이렇게 많은 중점을 두는 언어에서 `Mirror` 같은 것이 어떻게 동작하는지 궁금할 수 있습니다. 한번 살펴보겠습니다!


## 면책 사항

여기에 나오는 모든 내용은 내부 구현 세부 사항입니다. 코드는 작성 시점 기준이며 변경될 수 있습니다. 메타데이터는 ABI 안정성이 달성되면 고정되고 신뢰할 수 있는 형식이 되지만, 현재로서는 변경될 수 있습니다. 일반적인 Swift 코드를 작성하는 경우 이 내용에 의존하지 마세요. `Mirror`가 제공하는 것보다 더 정교한 리플렉션을 원하는 코드를 작성한다면, 이것이 출발점이 될 수 있지만 ABI 안정성이 달성될 때까지 변경 사항을 계속 반영해야 합니다. `Mirror` 코드 자체를 작업하고 싶다면, 이 글이 전체 구조를 이해하는 데 도움이 되겠지만 내용이 변경될 수 있음을 염두에 두세요.


## 인터페이스

`Mirror(reflecting:)` 이니셜라이저는 임의의 값을 받습니다. 결과로 생성된 `Mirror` 인스턴스는 해당 값에 대한 정보, 주로 포함된 자식 요소들을 제공합니다. 자식은 값과 선택적 레이블로 구성됩니다. 자식 값에 `Mirror`를 사용하면 컴파일 타임에 타입을 전혀 몰라도 전체 객체 그래프를 순회할 수 있습니다.

`Mirror`는 `CustomReflectable` 프로토콜을 준수하여 타입이 커스텀 표현을 제공할 수 있게 합니다. 이는 내부 검사로 얻을 수 있는 것보다 더 나은 표현을 제시하고 싶은 타입에 유용합니다. 예를 들어, `Array`는 `CustomReflectable`을 준수하며 배열의 요소를 레이블 없는 자식으로 노출합니다. `Dictionary`는 키/값 쌍을 레이블이 있는 자식으로 노출합니다.

다른 모든 타입의 경우, `Mirror`는 값의 실제 내용을 기반으로 자식 목록을 생성하는 마법을 부립니다. 구조체와 클래스의 경우 저장 프로퍼티를 자식으로 제시합니다. 튜플의 경우 튜플 요소를 제시합니다. 열거형은 열거형 케이스와 연관 값(있는 경우)을 제시합니다.

이 마법은 어떻게 동작할까요? 알아보겠습니다!


## 구조

리플렉션 API는 부분적으로 Swift로, 부분적으로 C++로 구현되어 있습니다. Swift는 Swift다운 인터페이스를 구현하는 데 더 적합하고 많은 작업을 쉽게 만듭니다. Swift 런타임의 하위 레벨은 C++로 구현되어 있으며, Swift에서 이러한 C++ 클래스에 직접 접근하는 것은 불가능하므로 C 레이어가 둘을 연결합니다. Swift 쪽은 [`ReflectionMirror.swift`](https://github.com/apple/swift/blob/master/stdlib/public/core/ReflectionMirror.swift)에, C++ 쪽은 [`ReflectionMirror.mm`](https://github.com/apple/swift/blob/master/stdlib/public/runtime/ReflectionMirror.mm)에 구현되어 있습니다.

두 부분은 Swift에 노출된 소규모의 C++ 함수 세트를 통해 통신합니다. Swift의 내장 C 브리징을 사용하는 대신, 커스텀 심볼 이름을 지정하는 디렉티브와 함께 Swift에서 선언하고, 그 이름을 가진 C++ 함수가 Swift에서 직접 호출할 수 있도록 정교하게 만들어집니다. 이를 통해 브리징 메커니즘이 뒤에서 값에 무엇을 할지 걱정하지 않고 두 부분이 직접 통신할 수 있지만, Swift가 매개변수와 반환 값을 전달하는 정확한 방법에 대한 지식이 필요합니다. 이것이 필요한 런타임 코드를 작업하는 것이 아니라면 시도하지 마세요.

이에 대한 예로 `ReflectionMirror.swift`의 `_getChildCount` 함수를 살펴보세요:

~~~swift
@_silgen_name("swift_reflectionMirror_count")
internal func _getChildCount<T>(_: T, type: Any.Type) -> Int
~~~

`@_silgen_name` 속성은 Swift 컴파일러에 `_getChildCount`에 적용되는 일반적인 Swift 맹글링 대신 `swift_reflectionMirror_count`라는 심볼에 이 함수를 매핑하도록 알려줍니다. 앞의 밑줄은 이 속성이 표준 라이브러리에 예약되어 있음을 나타냅니다. C++ 쪽에서 함수는 다음과 같습니다:

~~~swift
SWIFT_CC(swift) SWIFT_RUNTIME_STDLIB_INTERFACE
intptr_t swift_reflectionMirror_count(OpaqueValue *value,
                                      const Metadata *type,
                                      const Metadata *T) {
~~~

`SWIFT_CC(swift)`는 컴파일러에 이 함수가 C/C++ 규약이 아닌 Swift 호출 규약을 사용한다고 알려줍니다. `SWIFT_RUNTIME_STDLIB_INTERFACE`는 이것을 Swift 쪽 인터페이스의 일부인 함수로 표시하며, `extern "C"`로 표시하는 효과가 있어 C++ 이름 맹글링을 피하고 Swift 쪽이 기대하는 심볼 이름을 가지게 합니다. C++ 매개변수는 Swift 선언을 기반으로 Swift가 이 함수를 호출하는 방식과 일치하도록 신중하게 배치됩니다. Swift 코드가 `_getChildCount`를 호출하면 C++ 함수가 호출되며, `value`에는 Swift 값에 대한 포인터가, `type`에는 타입 매개변수의 값이, `T`에는 제네릭 `<T>`에 해당하는 타입이 포함됩니다.

`Mirror`의 Swift와 C++ 부분 사이의 전체 인터페이스는 다음 함수들로 구성됩니다:

~~~swift
@_silgen_name("swift_reflectionMirror_normalizedType")
internal func _getNormalizedType<T>(_: T, type: Any.Type) -> Any.Type

@_silgen_name("swift_reflectionMirror_count")
internal func _getChildCount<T>(_: T, type: Any.Type) -> Int

internal typealias NameFreeFunc = @convention(c) (UnsafePointer<CChar>?) -> Void

@_silgen_name("swift_reflectionMirror_subscript")
internal func _getChild<T>(
  of: T,
  type: Any.Type,
  index: Int,
  outName: UnsafeMutablePointer<UnsafePointer<CChar>?>,
  outFreeFunc: UnsafeMutablePointer<NameFreeFunc?>
) -> Any

// Returns 'c' (class), 'e' (enum), 's' (struct), 't' (tuple), or '\0' (none)
@_silgen_name("swift_reflectionMirror_displayStyle")
internal func _getDisplayStyle<T>(_: T) -> CChar

@_silgen_name("swift_reflectionMirror_quickLookObject")
internal func _getQuickLookObject<T>(_: T) -> AnyObject?

@_silgen_name("_swift_stdlib_NSObject_isKindOfClass")
internal func _isImpl(_ object: AnyObject, kindOf: AnyObject) -> Bool
~~~


## 특이한 방식의 동적 디스패치

모든 타입에서 원하는 정보를 가져오는 단일 범용 방법은 없습니다. 튜플, 구조체, 클래스, 열거형 모두 자식 수 조회 같은 많은 작업에 서로 다른 코드가 필요합니다. Swift 클래스와 Objective-C 클래스에 대한 다른 처리 같은 추가적인 미묘한 차이도 있습니다.

이 모든 함수는 검사 중인 타입의 종류에 따라 서로 다른 구현으로 디스패치하는 코드가 필요합니다. 이는 메서드의 동적 디스패치와 매우 비슷하지만, 호출할 구현을 선택하는 것이 메서드가 사용되는 객체의 클래스를 확인하는 것보다 더 복잡합니다. 리플렉션 코드는 위 인터페이스의 C++ 버전을 포함하는 추상 기본 클래스와 다양한 경우를 다루는 여러 하위 클래스와 함께 C++ 동적 디스패치를 사용하여 문제를 단순화합니다. 단일 함수가 Swift 타입을 이러한 C++ 클래스 중 하나의 인스턴스에 매핑합니다. 그 인스턴스에서 메서드를 호출하면 적절한 구현으로 디스패치됩니다.

매핑 함수는 `call`이라고 하며 선언은 다음과 같습니다:

~~~cpp
template<typename F>
auto call(OpaqueValue *passedValue, const Metadata *T, const Metadata *passedType,
          const F &f) -> decltype(f(nullptr))
~~~

`passedValue`는 전달된 실제 Swift 값에 대한 포인터입니다. `T`는 해당 값의 정적 타입으로, Swift 쪽의 제네릭 매개변수 `<T>`에 해당합니다. `passedType`은 Swift 쪽에서 명시적으로 전달되어 실제 리플렉션 단계에 사용되는 타입입니다. (이 타입은 하위 클래스의 인스턴스에 대해 상위 클래스 `Mirror`를 사용할 때 객체의 실제 런타임 타입과 다릅니다.) 마지막으로, `f` 매개변수는 이 함수가 조회한 구현 객체에 대한 참조를 전달하며 호출됩니다. 사용자가 값을 쉽게 꺼낼 수 있도록 이 함수는 호출 시 `f`가 반환하는 것을 그대로 반환합니다.

`call`의 구현은 그다지 흥미롭지 않습니다. 대부분 특수 케이스를 처리하는 추가 코드가 있는 큰 `switch` 문입니다. 중요한 것은 결국 `ReflectionMirrorImpl`의 하위 클래스 인스턴스와 함께 `f`를 호출하고, 그 인스턴스에서 메서드를 호출하여 실제 작업을 수행한다는 것입니다.

모든 것이 거치는 인터페이스인 `ReflectionMirrorImpl`은 다음과 같습니다:

~~~cpp
struct ReflectionMirrorImpl {
  const Metadata *type;
  OpaqueValue *value;

  virtual char displayStyle() = 0;
  virtual intptr_t count() = 0;
  virtual AnyReturn subscript(intptr_t index, const char **outName,
                              void (**outFreeFunc)(const char *)) = 0;
  virtual const char *enumCaseName() { return nullptr; }

#if SWIFT_OBJC_INTEROP
  virtual id quickLookObject() { return nil; }
#endif

  virtual ~ReflectionMirrorImpl() {}
};
~~~

Swift와 C++ 컴포넌트 사이의 인터페이스 역할을 하는 함수들은 `call`을 사용하여 해당 메서드를 호출합니다. 예를 들어 `swift_reflectionMirror_count`는 다음과 같습니다:

~~~cpp
SWIFT_CC(swift) SWIFT_RUNTIME_STDLIB_INTERFACE
intptr_t swift_reflectionMirror_count(OpaqueValue *value,
                                      const Metadata *type,
                                      const Metadata *T) {
  return call(value, T, type, [](ReflectionMirrorImpl *impl) {
    return impl->count();
  });
}
~~~

## 튜플 리플렉션

아마도 실제 작업을 수행하면서도 가장 단순한 튜플 리플렉션부터 시작하겠습니다. 튜플임을 나타내기 위해 표시 스타일 `'t'`를 반환하는 것으로 시작합니다:

~~~cpp
struct TupleImpl : ReflectionMirrorImpl {
  char displayStyle() {
    return 't';
  }
~~~

이런 하드코딩된 상수를 사용하는 것은 일반적이지 않지만, C++에서 한 곳과 Swift에서 한 곳에서만 이 값을 참조하고 통신에 브리징을 사용하지 않는다는 점에서 합리적인 선택입니다.

다음은 `count` 메서드입니다. 이 시점에서 `type`이 단순한 `Metadata *`가 아니라 실제로 `TupleTypeMetadata *`임을 알고 있습니다. `TupleTypeMetadata`에는 튜플의 요소 수를 담는 `NumElements` 필드가 있으며, 이것으로 끝입니다:

~~~cpp
  intptr_t count() {
    auto *Tuple = static_cast<const TupleTypeMetadata *>(type);
    return Tuple->NumElements;
  }
~~~

`subscript` 메서드는 좀 더 많은 작업이 필요합니다. 같은 `static_cast`로 시작합니다:

~~~cpp
  AnyReturn subscript(intptr_t i, const char **outName,
                      void (**outFreeFunc)(const char *)) {
    auto *Tuple = static_cast<const TupleTypeMetadata *>(type);
~~~

다음으로 호출자가 이 튜플에 포함될 수 없는 인덱스를 요청하지 않도록 범위 검사를 합니다:

~~~cpp
    if (i < 0 || (size_t)i > Tuple->NumElements)
      swift::crash("Swift mirror subscript bounds check failure");
~~~

subscript는 두 가지 작업을 합니다: 값과 해당하는 이름을 가져옵니다. 구조체나 클래스의 경우 이름은 저장 프로퍼티의 이름입니다. 튜플의 경우 이름은 해당 요소의 튜플 레이블이거나, 레이블이 없으면 `.0` 같은 숫자 표시입니다.

레이블은 메타데이터의 `Labels` 필드에 공백으로 구분된 목록으로 저장됩니다. 이 코드는 해당 목록에서 `i`번째 문자열을 추적합니다:

~~~cpp
    // Determine whether there is a label.
    bool hasLabel = false;
    if (const char *labels = Tuple->Labels) {
      const char *space = strchr(labels, ' ');
      for (intptr_t j = 0; j != i && space; ++j) {
        labels = space + 1;
        space = strchr(labels, ' ');
      }

      // If we have a label, create it.
      if (labels && space && labels != space) {
        *outName = strndup(labels, space - labels);
        hasLabel = true;
      }
    }
~~~

레이블이 없으면 적절한 숫자 이름을 생성합니다:

~~~cpp
    if (!hasLabel) {
      // The name is the stringized element number '.0'.
      char *str;
      asprintf(&str, ".%" PRIdPTR, i);
      *outName = str;
    }
~~~

Swift와 C++의 교차점에서 작업하기 때문에 자동 메모리 관리 같은 편리한 것을 사용할 수 없습니다. Swift에는 ARC가 있고 C++에는 RAII가 있지만, 둘은 잘 어울리지 않습니다. `outFreeFunc`은 C++ 코드가 반환된 이름을 해제하는 데 사용할 함수를 호출자에게 제공할 수 있게 합니다. 레이블은 `free`로 해제해야 하므로, 이 코드는 `*outFreeFunc` 값을 그에 맞게 설정합니다:

~~~cpp
    *outFreeFunc = [](const char *str) { free(const_cast<char *>(str)); };
~~~

이것으로 이름 처리가 끝납니다. 놀랍게도 값을 가져오는 것이 더 간단합니다. `Tuple` 메타데이터에는 주어진 인덱스의 요소에 대한 정보를 반환하는 함수가 포함되어 있습니다:

~~~cpp
    auto &elt = Tuple->getElement(i);
~~~

`elt`에는 튜플 값에 적용하여 요소 값에 대한 포인터를 얻을 수 있는 오프셋이 포함되어 있습니다:

~~~cpp
    auto *bytes = reinterpret_cast<const char *>(value);
    auto *eltData = reinterpret_cast<const OpaqueValue *>(bytes + elt.Offset);
~~~

`elt`에는 요소의 타입도 포함되어 있습니다. 타입과 값에 대한 포인터로, 해당 값을 포함하는 새로운 `Any`를 구성할 수 있습니다. 타입에는 주어진 타입의 값을 포함하는 스토리지를 할당하고 초기화하기 위한 함수 포인터가 포함되어 있습니다. 이 코드는 이 함수들을 사용하여 값을 `Any`에 복사한 다음, 호출자에게 `Any`를 반환합니다:

~~~cpp
    Any result;

    result.Type = elt.Type;
    auto *opaqueValueAddr = result.Type->allocateBoxForExistentialIn(&result.Buffer);
    result.Type->vw_initializeWithCopy(opaqueValueAddr,
                                       const_cast<OpaqueValue *>(eltData));

    return AnyReturn(result);
  }
};
~~~

튜플에 대한 설명은 여기까지입니다.


## swift_getFieldAt

구조체, 클래스, 열거형에서 요소를 조회하는 것은 현재 상당히 복잡합니다. 이 복잡성의 대부분은 이러한 타입과 타입의 필드 정보를 포함하는 필드 디스크립터 사이에 직접적인 참조가 없기 때문입니다. `swift_getFieldAt`이라는 헬퍼 함수가 주어진 타입에 대해 적절한 필드 디스크립터를 검색합니다. 직접 참조를 추가하면 이 함수 전체가 사라져야 하지만, 그동안 런타임 코드가 언어의 메타데이터를 사용하여 타입 정보를 조회하는 방법에 대한 흥미로운 시각을 제공합니다.

함수 프로토타입은 다음과 같습니다:

~~~cpp
void swift::_swift_getFieldAt(
    const Metadata *base, unsigned index,
    std::function<void(llvm::StringRef name, FieldType fieldInfo)>
        callback) {
~~~

검사할 타입과 조회할 필드 인덱스를 받습니다. 또한 조회한 정보와 함께 호출될 콜백도 받습니다.

첫 번째 작업은 이 타입의 타입 컨텍스트 디스크립터를 가져오는 것으로, 나중에 사용될 타입에 대한 추가 정보를 포함합니다:

~~~cpp
  auto *baseDesc = base->getTypeContextDescriptor();
  if (!baseDesc)
    return;
~~~

작업은 두 부분으로 나뉩니다. 먼저 타입의 필드 디스크립터를 조회합니다. 필드 디스크립터는 타입의 필드에 대한 모든 정보를 포함합니다. 필드 디스크립터를 사용할 수 있게 되면, 이 함수는 디스크립터에서 필요한 정보를 조회할 수 있습니다.

디스크립터에서 정보를 조회하는 것은 `getFieldAt`이라는 헬퍼에 래핑되어 있으며, 다른 코드가 적절한 필드 디스크립터를 검색하는 여러 곳에서 호출합니다. 검색부터 시작하겠습니다. 맹글링된 타입 이름을 실제 타입 참조로 변환하는 데 사용되는 디맹글러를 가져오는 것으로 시작합니다:

~~~cpp
  auto dem = getDemanglerForRuntimeTypeResolution();
~~~
여러 검색을 빠르게 하기 위한 캐시도 있습니다:

~~~cpp
  auto &cache = FieldCache.get();
~~~

캐시에 이미 필드 디스크립터가 있으면, 그것으로 `getFieldAt`을 호출합니다:

~~~cpp
  if (auto Value = cache.FieldCache.find(base)) {
    getFieldAt(*Value->getDescription());
    return;
  }
~~~

검색 코드를 단순화하기 위해, `FieldDescriptor`를 받아 검색 대상인지 확인하는 헬퍼가 있습니다. 디스크립터가 일치하면 캐시에 넣고, `getFieldAt`을 호출하고, 호출자에게 성공을 반환합니다. 매칭은 복잡하지만, 본질적으로 맹글링된 이름을 비교하는 것입니다:

~~~cpp
  auto isRequestedDescriptor = [&](const FieldDescriptor &descriptor) {
    assert(descriptor.hasMangledTypeName());
    auto mangledName = descriptor.getMangledTypeName(0);

    if (!_contextDescriptorMatchesMangling(baseDesc,
                                           dem.demangleType(mangledName)))
      return false;

    cache.FieldCache.getOrInsert(base, &descriptor);
    getFieldAt(descriptor);
    return true;
  };
~~~

필드 디스크립터는 런타임에 등록하거나 빌드 타임에 바이너리에 포함할 수 있습니다. 이 두 루프는 일치하는 것을 찾기 위해 알려진 모든 필드 디스크립터를 검색합니다:

~~~cpp
  for (auto &section : cache.DynamicSections.snapshot()) {
    for (const auto *descriptor : section) {
      if (isRequestedDescriptor(*descriptor))
        return;
    }
  }

  for (const auto &section : cache.StaticSections.snapshot()) {
    for (auto &descriptor : section) {
      if (isRequestedDescriptor(descriptor))
        return;
    }
  }
~~~

일치하는 것을 찾지 못한 경우, 경고를 기록하고 무언가를 제공하기 위해 빈 튜플로 콜백을 호출합니다:

~~~cpp
  auto typeName = swift_getTypeName(base, /*qualified*/ true);
  warning(0, "SWIFT RUNTIME BUG: unable to find field metadata for type '%*s'\n",
             (int)typeName.length, typeName.data);
  callback("unknown",
           FieldType()
             .withType(TypeInfo(&METADATA_SYM(EMPTY_TUPLE_MANGLING), {}))
             .withIndirect(false)
             .withWeak(false));
}
~~~

이것으로 필드 디스크립터 검색이 완료됩니다. `getFieldAt` 헬퍼는 필드 디스크립터를 콜백에 전달되는 이름과 필드 타입으로 변환합니다. 필드 디스크립터에서 요청된 필드 레코드를 가져오는 것으로 시작합니다:

~~~cpp
  auto getFieldAt = [&](const FieldDescriptor &descriptor) {
    auto &field = descriptor.getFields()[index];
~~~

이름은 레코드에서 직접 접근할 수 있습니다:

~~~cpp
    auto name = field.getFieldName(0);
~~~

필드가 실제로 열거형 케이스인 경우 타입이 없을 수 있습니다. 이를 미리 확인하고 그에 따라 콜백을 호출합니다:

~~~cpp
    if (!field.hasMangledTypeName()) {
      callback(name, FieldType().withIndirect(field.isIndirectCase()));
      return;
    }
~~~

필드 레코드는 필드 타입을 맹글링된 이름으로 저장합니다. 콜백은 메타데이터에 대한 포인터를 기대하므로, 맹글링된 이름을 실제 타입으로 해석해야 합니다. `_getTypeByMangledName` 함수가 대부분의 작업을 처리하지만, 호출자가 타입에서 사용되는 모든 제네릭 인자를 해석해야 합니다. 이를 위해 타입이 중첩된 모든 제네릭 컨텍스트를 추출해야 합니다:

~~~cpp
    std::vector<const ContextDescriptor *> descriptorPath;
    {
      const auto *parent = reinterpret_cast<
                              const ContextDescriptor *>(baseDesc);
      while (parent) {
        if (parent->isGeneric())
          descriptorPath.push_back(parent);

        parent = parent->Parent.get();
      }
    }
~~~

이제 맹글링된 이름을 가져오고, 제네릭 인자를 해석하는 람다를 전달하여 타입을 가져옵니다:

~~~cpp
    auto typeName = field.getMangledTypeName(0);

    auto typeInfo = _getTypeByMangledName(
        typeName,
        [&](unsigned depth, unsigned index) -> const Metadata * {
~~~

요청된 깊이가 디스크립터 경로의 크기를 초과하면 실패합니다:

~~~cpp
          if (depth >= descriptorPath.size())
            return nullptr;
~~~

그렇지 않으면, 필드를 포함하는 타입에서 제네릭 인자를 가져옵니다. 이를 위해 인덱스와 깊이를 단일 평탄 인덱스로 변환해야 하는데, 이는 디스크립터 경로를 올라가면서 주어진 깊이에 도달할 때까지 각 단계의 제네릭 매개변수 수를 더하여 수행합니다:

~~~cpp
          unsigned currentDepth = 0;
          unsigned flatIndex = index;
          const ContextDescriptor *currentContext = descriptorPath.back();

          for (const auto *context : llvm::reverse(descriptorPath)) {
            if (currentDepth >= depth)
              break;

            flatIndex += context->getNumGenericParams();
            currentContext = context;
            ++currentDepth;
          }
~~~

인덱스가 주어진 깊이에서 사용 가능한 제네릭 매개변수를 초과하면 실패합니다:

~~~cpp
          if (index >= currentContext->getNumGenericParams())
            return nullptr;
~~~

그렇지 않으면 기반 타입에서 적절한 제네릭 인자를 가져옵니다:

~~~cpp
          return base->getGenericArgs()[flatIndex];
        });
~~~

이전과 마찬가지로, 타입을 찾을 수 없으면 빈 튜플을 사용합니다:

~~~cpp
    if (typeInfo == nullptr) {
      typeInfo = TypeInfo(&METADATA_SYM(EMPTY_TUPLE_MANGLING), {});
      warning(0, "SWIFT RUNTIME BUG: unable to demangle type of field '%*s'. "
                 "mangled type name is '%*s'\n",
                 (int)name.size(), name.data(),
                 (int)typeName.size(), typeName.data());
    }
~~~

그런 다음 찾은 것으로 콜백을 호출합니다:

~~~cpp
    callback(name, FieldType()
                       .withType(typeInfo)
                       .withIndirect(field.isIndirectCase())
                       .withWeak(typeInfo.isWeak()));

  };
~~~

이것이 `swift_getFieldAt`입니다. 이 헬퍼를 사용할 수 있으므로, 다른 리플렉션 구현을 살펴보겠습니다.

## 구조체

구조체에 대한 구현은 비슷하지만 좀 더 복잡합니다. 리플렉션을 전혀 지원하지 않는 구조체 타입이 있고, 구조체에서 이름과 오프셋을 조회하는 데 더 많은 노력이 필요하며, 구조체는 리플렉션 코드가 추출할 수 있어야 하는 약한 참조를 포함할 수 있습니다.

먼저 구조체가 리플렉션될 수 있는지 확인하는 헬퍼 메서드가 있습니다. 이는 구조체 메타데이터를 통해 접근할 수 있는 플래그에 저장됩니다. 튜플의 위 코드와 마찬가지로, 이 시점에서 `type`이 실제로 `StructMetadata *`임을 알고 있으므로 자유롭게 캐스팅할 수 있습니다:

~~~cpp
struct StructImpl : ReflectionMirrorImpl {
  bool isReflectable() {
    const auto *Struct = static_cast<const StructMetadata *>(type);
    const auto &Description = Struct->getDescription();
    return Description->getTypeContextDescriptorFlags().isReflectable();
  }
~~~

구조체의 표시 스타일은 `'s'`입니다:

~~~cpp
  char displayStyle() {
    return 's';
  }
~~~

자식 수는 메타데이터가 보고하는 필드 수이며, 이 타입이 실제로 리플렉션될 수 없으면 `0`입니다:

~~~cpp
  intptr_t count() {
    if (!isReflectable()) {
      return 0;
    }

    auto *Struct = static_cast<const StructMetadata *>(type);
    return Struct->getDescription()->NumFields;
  }
~~~

이전과 마찬가지로, `subscript` 메서드가 복잡한 부분입니다. 비슷하게 시작하여 범위 검사와 오프셋 조회를 합니다:

~~~cpp
  AnyReturn subscript(intptr_t i, const char **outName,
                      void (**outFreeFunc)(const char *)) {
    auto *Struct = static_cast<const StructMetadata *>(type);

    if (i < 0 || (size_t)i > Struct->getDescription()->NumFields)
      swift::crash("Swift mirror subscript bounds check failure");

    // Load the offset from its respective vector.
    auto fieldOffset = Struct->getFieldOffsets()[i];
~~~

구조체 필드의 타입 정보를 가져오는 것은 좀 더 복잡합니다. 이 작업은 `_swift_getFieldAt` 헬퍼 함수에 위임됩니다:

~~~cpp
    Any result;

    _swift_getFieldAt(type, i, [&](llvm::StringRef name, FieldType fieldInfo) {
~~~

필드 정보를 얻으면 튜플 코드와 비슷하게 진행됩니다. 이름을 채우고 필드 스토리지에 대한 포인터를 계산합니다:

~~~cpp
      *outName = name.data();
      *outFreeFunc = nullptr;

      auto *bytes = reinterpret_cast<char*>(value);
      auto *fieldData = reinterpret_cast<OpaqueValue *>(bytes + fieldOffset);
~~~

약한 참조를 처리하기 위해 필드의 값을 `Any` 반환 값에 복사하는 추가 단계가 있습니다. `loadSpecialReferenceStorage` 함수가 이를 처리합니다. 값을 로드하지 않으면 값은 일반 스토리지를 가지며, 값을 정상적으로 반환 값에 복사할 수 있습니다:

~~~cpp
      bool didLoad = loadSpecialReferenceStorage(fieldData, fieldInfo, &result);
      if (!didLoad) {
        result.Type = fieldInfo.getType();
        auto *opaqueValueAddr = result.Type->allocateBoxForExistentialIn(&result.Buffer);
        result.Type->vw_initializeWithCopy(opaqueValueAddr,
                                           const_cast<OpaqueValue *>(fieldData));
      }
    });

    return AnyReturn(result);
  }
};
~~~

이것으로 구조체에 대한 설명이 끝납니다.


## 클래스

클래스는 구조체와 비슷하며, `ClassImpl`의 코드도 거의 동일합니다. Objective-C 상호 운용성으로 인한 두 가지 주목할 만한 차이가 있습니다. 하나는 Objective-C의 `debugQuickLookObject` 메서드를 호출하는 `quickLookObject` 구현이 있다는 것입니다:

~~~cpp
#if SWIFT_OBJC_INTEROP
id quickLookObject() {
  id object = [*reinterpret_cast<const id *>(value) retain];
  if ([object respondsToSelector:@selector(debugQuickLookObject)]) {
    id quickLookObject = [object debugQuickLookObject];
    [quickLookObject retain];
    [object release];
    return quickLookObject;
  }

  return object;
}
#endif
~~~

다른 하나는 클래스에 Objective-C 상위 클래스가 있는 경우 Objective-C 런타임에서 필드 오프셋을 가져와야 한다는 것입니다:

~~~cpp
  uintptr_t fieldOffset;
  if (usesNativeSwiftReferenceCounting(Clas)) {
    fieldOffset = Clas->getFieldOffsets()[i];
  } else {
#if SWIFT_OBJC_INTEROP
    Ivar *ivars = class_copyIvarList((Class)Clas, nullptr);
    fieldOffset = ivar_getOffset(ivars[i]);
    free(ivars);
#else
    swift::crash("Object appears to be Objective-C, but no runtime.");
#endif
  }
~~~


## 열거형

열거형은 약간 다릅니다. `Mirror`는 열거형 인스턴스를 최대 하나의 자식을 가진 것으로 간주하며, 열거형 케이스 이름이 레이블이고 연관 값이 값입니다. 연관 값이 없는 케이스에는 자식이 없습니다. 예를 들어:

~~~cpp
enum Foo {
  case bar
  case baz(Int)
  case quux(String, String)
}
~~~

`Foo` 값에 mirror를 사용하면 `Foo.bar`에는 자식이 없고, `Foo.baz`에는 `Int` 값을 가진 하나의 자식이, `Foo.quux`에는 `(String, String)` 값을 가진 하나의 자식이 표시됩니다. 클래스나 구조체의 값은 항상 같은 필드를 포함하여 같은 자식 레이블과 타입을 가지지만, 같은 타입의 다른 열거형 케이스는 그렇지 않습니다. 연관 값은 `indirect`일 수도 있어 특별한 처리가 필요합니다.

`enum` 값을 리플렉션하는 데 네 가지 핵심 정보가 필요합니다: 케이스 이름, 태그(값이 저장하는 열거형 케이스의 숫자 표현), 페이로드 타입, 페이로드가 indirect인지 여부. `getInfo` 메서드가 이 모든 값을 가져옵니다:

~~~cpp
const char *getInfo(unsigned *tagPtr = nullptr,
                    const Metadata **payloadTypePtr = nullptr,
                    bool *indirectPtr = nullptr) {
~~~

태그는 메타데이터를 직접 쿼리하여 가져옵니다:

~~~cpp
  unsigned tag = type->vw_getEnumTag(value);
~~~

나머지 정보는 `_swift_getFieldAt`을 사용하여 가져옵니다. 태그를 "필드 인덱스"로 받아 적절한 정보를 제공합니다:

~~~cpp
  const Metadata *payloadType = nullptr;
  bool indirect = false;

  const char *caseName = nullptr;
  _swift_getFieldAt(type, tag, [&](llvm::StringRef name, FieldType info) {
    caseName = name.data();
    payloadType = info.getType();
    indirect = info.isIndirect();
  });
~~~

이 모든 값은 호출자에게 반환됩니다:

~~~cpp
  if (tagPtr)
    *tagPtr = tag;
  if (payloadTypePtr)
    *payloadTypePtr = payloadType;
  if (indirectPtr)
    *indirectPtr = indirect;

  return caseName;
}
~~~

(궁금할 수 있습니다: 왜 케이스 이름은 직접 반환되고 나머지 세 개는 포인터를 통해 반환될까요? 왜 태그나 페이로드 타입을 반환하지 않을까요? 답은: 잘 모르겠지만, 그때는 좋은 생각 같았습니다.)

`count` 메서드는 `getInfo`를 사용하여 페이로드 타입을 가져온 다음, 페이로드 타입이 `null`인지 아닌지에 따라 `0` 또는 `1`을 반환합니다:

~~~cpp
intptr_t count() {
  if (!isReflectable()) {
    return 0;
  }

  const Metadata *payloadType;
  getInfo(nullptr, &payloadType, nullptr);
  return (payloadType != nullptr) ? 1 : 0;
}
~~~

`subscript` 메서드는 값에 대한 모든 정보를 가져오는 것으로 시작합니다:

~~~cpp
AnyReturn subscript(intptr_t i, const char **outName,
                    void (**outFreeFunc)(const char *)) {
  unsigned tag;
  const Metadata *payloadType;
  bool indirect;

  auto *caseName = getInfo(&tag, &payloadType, &indirect);
~~~

실제로 값을 복사하는 것은 좀 더 많은 작업이 필요합니다. indirect 값을 처리하기 위해 전체 프로세스가 추가적인 박스를 거칩니다:

~~~cpp
  const Metadata *boxType = (indirect ? &METADATA_SYM(Bo).base : payloadType);
  BoxPair pair = swift_allocBox(boxType);
~~~

열거형 추출 방식의 특성상 값을 깨끗하게 복사할 방법이 없습니다. 사용 가능한 유일한 연산은 페이로드 값을 *파괴적으로* 추출하는 것입니다. 복사본을 만들고 원본을 그대로 두려면, 파괴적으로 추출한 다음 다시 넣어야 합니다:

~~~cpp
  type->vw_destructiveProjectEnumData(const_cast<OpaqueValue *>(value));
  boxType->vw_initializeWithCopy(pair.buffer, const_cast<OpaqueValue *>(value));
  type->vw_destructiveInjectEnumTag(const_cast<OpaqueValue *>(value), tag);

  value = pair.buffer;
~~~

indirect인 경우, 실제 데이터를 박스에서 꺼내야 합니다:

~~~cpp
  if (indirect) {
    const HeapObject *owner = *reinterpret_cast<HeapObject * const *>(value);
    value = swift_projectBox(const_cast<HeapObject *>(owner));
  }
~~~
모든 것이 준비되었습니다. 자식의 레이블은 케이스 이름으로 설정됩니다:

~~~cpp
  *outName = caseName;
  *outFreeFunc = nullptr;
~~~

이제 익숙한 패턴을 사용하여 페이로드를 `Any`로 반환합니다:

~~~cpp
  Any result;

  result.Type = payloadType;
  auto *opaqueValueAddr = result.Type->allocateBoxForExistentialIn(&result.Buffer);
  result.Type->vw_initializeWithCopy(opaqueValueAddr,
                                     const_cast<OpaqueValue *>(value));

  swift_release(pair.object);
  return AnyReturn(result);
}
~~~

## 기타 종류

이 파일에는 거의 아무것도 하지 않는 세 가지 구현이 더 있습니다. `ObjCClassImpl`은 Objective-C 클래스를 처리합니다. Objective-C는 ivar의 내용에 너무 많은 자유를 허용하기 때문에 이들에 대해 자식을 반환하려고 시도조차 하지 않습니다. Objective-C 클래스는 댕글링 포인터를 영원히 유지하면서 구현에 해당 값을 건드리지 말라고 알리는 별도의 로직을 가지는 것 같은 일이 허용됩니다. 이러한 값을 `Mirror`의 자식으로 반환하려고 시도하면 Swift의 메모리 안전 보장을 위반합니다. 해당 값이 그런 일을 하고 있는지 신뢰할 수 있게 판별할 방법이 없으므로, 이 코드는 이를 완전히 피합니다.

`MetatypeImpl`은 메타타입을 처리합니다. `Mirror(reflecting: String.self)` 같이 실제 타입에 `Mirror`를 사용하면 이것이 사용됩니다. 여기서 유용한 정보를 제공할 수도 있겠지만, 현재로서는 시도조차 하지 않고 아무것도 반환하지 않습니다. 마찬가지로, `OpaqueImpl`은 opaque 타입을 처리하며 아무것도 반환하지 않습니다.


## Swift 인터페이스

Swift 쪽에서 `Mirror`는 C++로 구현된 인터페이스 함수를 호출하여 필요한 정보를 가져온 다음, 더 친숙한 형태로 제시합니다. 이는 `Mirror`의 이니셜라이저에서 수행됩니다:

~~~swift
internal init(internalReflecting subject: Any,
            subjectType: Any.Type? = nil,
            customAncestor: Mirror? = nil)
{
~~~

`subjectType`은 `subject` 값을 리플렉션하는 데 사용될 타입입니다. 일반적으로 값의 런타임 타입이지만, 호출자가 `superclassMirror`를 사용하여 클래스 계층을 올라가면 상위 클래스가 됩니다. 호출자가 `subjectType`을 전달하지 않으면, 이 코드는 C++ 코드에 `subject`의 타입을 가져오도록 요청합니다:

~~~swift
  let subjectType = subjectType ?? _getNormalizedType(subject, type: type(of: subject))
~~~

그런 다음 자식 수를 가져오고, 각 자식을 지연 방식으로 가져오는 컬렉션을 만들어 `children`을 구성합니다:

~~~swift
  let childCount = _getChildCount(subject, type: subjectType)
  let children = (0 ..< childCount).lazy.map({
    getChild(of: subject, type: subjectType, index: $0)
  })
  self.children = Children(children)
~~~

`getChild` 함수는 레이블 이름을 포함하는 C 문자열을 Swift `String`으로 변환하는 C++ `_getChild` 함수의 작은 래퍼입니다.

`Mirror`에는 클래스 계층에서 상위 클래스의 프로퍼티를 검사하는 `Mirror`를 반환하는 `superclassMirror` 프로퍼티가 있습니다. 내부적으로, 요청 시 상위 클래스 `Mirror`를 구성할 수 있는 클로저를 저장하는 `_makeSuperclassMirror` 프로퍼티가 있습니다. 이 클로저는 `subjectType`의 상위 클래스를 가져오는 것으로 시작합니다. 비클래스 타입과 상위 클래스가 없는 클래스는 상위 클래스 mirror를 가질 수 없으므로 `nil`을 받습니다:

~~~swift
  self._makeSuperclassMirror = {
    guard let subjectClass = subjectType as? AnyClass,
          let superclass = _getSuperclass(subjectClass) else {
      return nil
    }
~~~

호출자는 커스텀 조상 표현을 지정할 수 있으며, 이는 상위 클래스 mirror로 직접 반환될 수 있는 `Mirror` 인스턴스입니다:

~~~swift
    if let customAncestor = customAncestor {
      if superclass == customAncestor.subjectType {
        return customAncestor
      }
      if customAncestor._defaultDescendantRepresentation == .suppressed {
        return customAncestor
      }
    }
~~~

그렇지 않으면, 같은 값에 대해 `superclass`를 `subjectType`으로 사용하는 새로운 `Mirror`를 반환합니다:

~~~swift
    return Mirror(internalReflecting: subject,
                  subjectType: superclass,
                  customAncestor: customAncestor)
  }
~~~

마지막으로, 표시 스타일을 가져와 디코딩하고 `Mirror`의 나머지 프로퍼티를 설정합니다:

~~~swift
    let rawDisplayStyle = _getDisplayStyle(subject)
    switch UnicodeScalar(Int(rawDisplayStyle)) {
    case "c": self.displayStyle = .class
    case "e": self.displayStyle = .enum
    case "s": self.displayStyle = .struct
    case "t": self.displayStyle = .tuple
    case "\0": self.displayStyle = nil
    default: preconditionFailure("Unknown raw display style '\(rawDisplayStyle)'")
    }

    self.subjectType = subjectType
    self._defaultDescendantRepresentation = .generated
  }
~~~


## 결론

Swift의 풍부한 타입 메타데이터는 대부분 내부에서 프로토콜 적합성 조회와 제네릭 타입 해석 같은 것을 지원합니다. 일부는 `Mirror` 타입을 통해 사용자에게 노출되어 런타임에 임의의 값을 검사할 수 있게 합니다. Swift의 정적 타입 특성을 고려하면 처음에는 이상하고 신비하게 보일 수 있지만, 사실 이미 사용 가능한 정보를 직접적으로 활용하는 것에 불과합니다. 이 구현 탐방이 그 신비를 걷어내고 `Mirror`를 사용할 때 무슨 일이 일어나는지에 대한 통찰을 제공하기를 바랍니다.