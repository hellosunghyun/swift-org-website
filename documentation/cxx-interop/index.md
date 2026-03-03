---
layout: page
title: Swift와 C++ 혼합 사용
official_url: https://swift.org/documentation/cxx-interop/
redirect_from:
  - /documentation/cxx-interop.html
---

## 목차

{:.no_toc}

- TOC
  {:toc}

## 소개

C++ 상호 운용성은 Swift 5.9에서 도입된 새로운 기능입니다.
다양한 C++ API를 Swift에서 직접 호출할 수 있으며, 일부 Swift API를 C++에서 사용할 수도 있습니다.

이 문서는 Swift와 C++를 혼합하여 사용하는 방법을 설명하는 레퍼런스 가이드입니다.
C++ API가 Swift로 어떻게 가져와지는지 설명하고, 다양한 C++ API를 Swift에서 사용하는 예제를 제공합니다. 또한 Swift API가 C++에 어떻게 노출되는지 설명하고, 노출된 Swift API를 C++에서 사용하는 예제도 제공합니다.

---

<div class="info" markdown="1">
C++ 상호 운용성은 Swift에서 활발히 발전하고 있는 기능입니다.
현재 언어 기능의 일부에 대한 상호 운용을 지원합니다.
[상태 페이지](status)에서 현재 지원되는 상호 운용 기능의
개요를 확인할 수 있으며, [기존 제약 사항](status#constraints-and-limitations) 목록도 함께 제공됩니다.

향후 Swift 릴리스에서는 Swift와 C++의 상호 운용 방식이 변경될 수 있습니다.
이는 Swift와 C++ 혼합 코드베이스에서 C++ 상호 운용성을 실제로 도입하면서 Swift 커뮤니티가 수집한 피드백을 반영하기 위함입니다.
피드백은 [Swift 포럼](https://forums.swift.org/c/development/c-interoperability/)에 남기거나
[GitHub 이슈](https://github.com/swiftlang/swift/issues/new/choose)를 통해 제출해 주세요.
C++ 상호 운용성의 설계나 기능에 대한 향후 변경 사항은
기존 코드베이스의 코드를 [기본적으로](#source-stability-guarantees-for-mixed-language-codebases) 깨뜨리지 않습니다.

</div>

## 개요

이 섹션에서는 Swift와 C++를 혼합하여 사용하는 방법에 대한 전체적인 개요를 제공합니다. 먼저 Swift에서 [C++ 상호 운용성을 활성화](#enabling-c-interoperability)하는 것부터 시작할 수 있습니다. 그다음 Swift가 [C++ 헤더를 가져오는 방식](#importing-c-into-swift)과 가져온 C++ 타입 및 함수가 [Swift 컴파일러에서 어떻게 표현되는지](#working-with-imported-c-apis) 이해해야 합니다.
이후에는 가져온 C++ API를 Swift에서 [어떻게 사용하는지](#using-c-types-and-functions-in-swift) 설명하는 후속 섹션을 살펴보세요.
또한 Swift API가 C++ 코드베이스의 나머지 부분에 [어떻게 노출될 수 있는지](#exposing-swift-apis-to-c)도 확인해 보세요.
C++에서 Swift API를 사용하는 데 관심이 있다면, 노출된 Swift API를 C++에서 [어떻게 사용하는지](#using-swift-types-and-functions-from-c) 설명하는 후속 섹션을 반드시 살펴보시기 바랍니다.

### C++ 상호 운용성 활성화

Swift 코드는 기본적으로 C 및 Objective-C API와 상호 운용됩니다.
C++ API를 Swift에서 사용하거나 Swift API를 C++에 노출하려면 C++ 상호 운용성을 활성화해야 합니다.

다음 가이드에서는 특정 빌드 시스템이나 IDE에서 C++ 상호 운용성을 활성화하는 방법을 설명합니다:

- [Swift 패키지에서 C++ API를 Swift로 사용하는 방법 읽기](project-build-setup#mixing-swift-and-c-using-swift-package-manager)
- [Xcode 프로젝트에서 Swift와 C++를 혼합하는 방법 읽기](project-build-setup#mixing-swift-and-c-using-xcode)

다른 빌드 시스템에서는 Swift 컴파일러에 필요한 플래그를 전달하여 C++ 상호 운용성을 활성화할 수 있습니다:

- [Swift 컴파일러를 직접 호출할 때 C++ 상호 운용성을 활성화하는 방법 읽기](project-build-setup#mixing-swift-and-c-using-other-build-systems)

### C++를 Swift로 가져오기

헤더 파일은 C++ 라이브러리의 공개 인터페이스를 기술하는 데 일반적으로 사용됩니다. 헤더 파일에는 타입과 템플릿 정의, 그리고 함수와 메서드 선언이 포함되며, 함수 본문은 보통 C++ 컴파일러가 컴파일하는 구현 파일에 배치됩니다.

Swift 컴파일러에는 [Clang](https://clang.llvm.org/) 컴파일러가 내장되어 있습니다.
덕분에 Swift는 [Clang 모듈](https://clang.llvm.org/docs/Modules.html)을 사용하여 C++ 헤더 파일을 가져올 수 있습니다. Clang 모듈은 `#include` 지시문으로 헤더 파일의 내용을 직접 포함하는 전처리기 기반 모델에 비해 더 견고하고 효율적인 C++ 헤더의 시맨틱 모델을 제공합니다.

> Swift는 현재 C++20 언어 표준에서 도입된
> [C++ 모듈](https://en.cppreference.com/w/cpp/language/modules)은
> 가져올 수 없습니다.

### Clang 모듈 생성

Swift가 Clang 모듈을 가져오려면, C++ 헤더 모음이 Clang 모듈에 어떻게 매핑되는지 기술하는 `module.modulemap` 파일을 찾아야 합니다.

일부 IDE와 빌드 시스템은 C++ 빌드 타겟에 대한 모듈 맵 파일을 자동으로 생성할 수 있습니다.
Swift Package Manager는 C++ 타겟에서 [우산 헤더를 발견하면](project-build-setup#importing-headers-from-a-c-package-target) 모듈 맵 파일을 자동으로 생성합니다. Xcode는 프레임워크 타겟에 대해 모듈 맵 파일을 자동으로 생성하며, 해당 모듈 맵은 프레임워크의 공개 헤더를 참조합니다.
그 외의 경우에는 모듈 맵을 수동으로 만들어야 할 수 있습니다.

모듈 맵을 수동으로 만드는 권장 방법은 Swift에서 사용하고자 하는 특정 C++ 타겟의 모든 헤더 파일을 나열하는 것입니다.
예를 들어, C++ 라이브러리 `forestLib`에 대한 모듈 맵을 만들고 싶다고 가정해 봅시다. 이 라이브러리에는 `forest.h`와 `tree.h` 두 개의 헤더 파일이 있습니다.
이 경우 권장 접근 방식에 따라 두 개의 `header` 지시문을 가진 모듈 맵을 만들 수 있습니다:

```shell
module forestLib {
    header "forest.h"
    header "tree.h"

    export *
}
```

`export *` 지시문은 모듈 맵에 추가하는 것이 권장되는 또 다른 항목입니다.
이 지시문은 `forestLib` 모듈로 가져온 Clang 모듈의 타입이 Swift에서도 볼 수 있도록 보장합니다.

모듈 맵 파일은 참조하는 헤더 파일 바로 옆에 배치해야 합니다.
예를 들어, `forestLib` 라이브러리에서 모듈 맵은
`include` 디렉토리에 들어갑니다:

```shell
forestLib
├── include
│   ├── forest.h
│   ├── tree.h
│   └── module.modulemap [NEW]
├── forest.cpp
└── tree.cpp
```

이제 `forestLib`에 모듈 맵이 있으므로, C++ 상호 운용성이 활성화되면 Swift에서 이를 가져올 수 있습니다. Swift가 `forestLib` 모듈을 찾으려면, 빌드 시스템이 Swift 컴파일러를 호출할 때 `forestLib/include`를 가리키는 import 경로 플래그(`-I`)를 전달해야 합니다.

모듈 맵 파일의 문법과 의미에 대한 자세한 내용은 Clang의
[모듈 맵 언어 문서](https://clang.llvm.org/docs/Modules.html#module-map-language)를 참조하세요.

### 가져온 C++ API 사용하기

Clang 모듈이 가져와지면, Swift 컴파일러는 가져온 C++ 타입과 함수를 Swift 선언으로 표현합니다. 이를 통해 Swift 코드에서 C++ 타입과 함수를 마치 Swift 타입과 함수처럼 사용할 수 있습니다.

예를 들어, Swift는 `forestLib` 라이브러리의 다음 C++ 열거형과 C++ 클래스를 표현할 수 있습니다:

```c++
enum class TreeKind {
  Oak,
  Redwood,
  Willow
};

class Tree {
public:
  Tree(TreeKind kind);
private:
  TreeKind kind;
};
```

Swift 컴파일러 내부에서 `TreeKind`를 표현하는 데 Swift 열거형이 사용됩니다:

```swift
enum TreeKind : Int32 {
  case Oak = 0
  case Redwood = 1
  case Willow = 2
}
```

Swift 컴파일러 내부에서 `Tree`를 표현하는 데 Swift 구조체가 사용됩니다:

```
struct Tree {
  init(_ kind: TreeKind)
}
```

이 구조체는 다른 Swift 구조체와 마찬가지로 Swift에서 직접 사용할 수 있습니다:

```swift
import forestLib

let tree = Tree(.Oak)
```

Swift는 어떠한 간접 참조나 래핑 없이 C++ 타입을 사용하고 C++ 함수를 직접 호출합니다.
위 예제에서 Swift는 `Tree` 클래스의 C++ 생성자를 직접 호출하고, 결과 객체를 `tree` 변수에 직접 저장합니다.

이 가이드의 후속 섹션에서 가져온 C++ API를 Swift에서 [어떻게 사용하는지](#using-c-types-and-functions-in-swift)에 대한 자세한 내용을 제공합니다.

### Swift API를 C++에 노출하기

C++ API를 가져와서 사용하는 것 외에도, Swift 컴파일러는 Swift 모듈의 Swift API를 C++에 노출하는 것도 가능합니다. 이를 통해 기존 C++ 코드베이스에 Swift를 점진적으로 통합할 수 있습니다.

Swift API는 Swift 모듈을 빌드할 때 빌드 시스템이 생성하는 헤더 파일을 포함하여 접근할 수 있습니다.
일부 빌드 시스템은 헤더를 자동으로 생성합니다.
Xcode는 프레임워크나 App 타겟에 대한 헤더 파일을 자동으로 생성할 수 있습니다.
다른 빌드 구성에서는
[프로젝트 및 빌드 설정 페이지](project-build-setup#generating-c-header-with-exposed-swift-apis)에 설명된 단계를 따라 헤더를 수동으로 생성할 수 있습니다.
Swift 함수는 C++ 타입을 매개변수로 받을 수 있습니다. 이러한 Swift API를 C++에서 사용할 때는 생성된 상호 운용 헤더를 포함하기 전에 Swift 함수 시그니처에 있는 C++ 타입의 헤더를 먼저 포함해야 합니다.

생성된 헤더는 C++ 타입과 함수를 사용하여 Swift 타입과 함수를 표현합니다. C++ 상호 운용성이 활성화되면, Swift는 Swift 모듈의 지원되는 모든 public 타입과 함수에 대해 C++ 바인딩을 생성합니다. 예를 들어, 다음 Swift 함수를 C++에서 호출할 수 있습니다:

```swift
// Swift module 'forestRenderer'
import forestLib

public func renderTreeToAscii(_ tree: Tree) -> String {
  ...
}
```

`renderTreeToAscii`의 구현을 직접 호출하는 인라인 C++ 함수가 Swift 컴파일러가 `forestRenderer` 모듈에 대해 생성한 헤더에 포함됩니다. C++ 파일에서 생성된 헤더를 포함하면 C++ 코드에서 이를 호출할 수 있습니다. Swift API가 C++에 정의된 타입인 `Tree`를 참조하므로, 생성된 헤더보다 먼저 `Tree.hpp`를 포함해야 합니다:

```c++
#include "Tree.hpp"
#include "forestRenderer-Swift.h"
#include <string>
#include <iostream>

void printTreeArt(const Tree &tree) {
  std::cout << (std::string)forestRenderer::renderTreeToAscii(tree);
}
```

[C++ 상호 운용성 상태 페이지](status#supported-swift-apis)에서 어떤 Swift 언어 구성 요소와 표준 라이브러리 타입이 C++에 노출될 수 있는지 설명합니다. 일부 지원되지 않는 Swift API는 생성된 헤더에서 비어 있는 unavailable C++ 선언에 매핑되므로, C++에 노출되지 않는 것을 사용하려고 하면 C++ 코드에서 오류가 발생합니다.

### 혼합 언어 코드베이스에 대한 소스 안정성 보장

Swift가 C++와 상호 운용하는 방식은 아직 발전 중입니다. 향후 Swift 릴리스의 일부 변경 사항은 이미 C++ 상호 운용성을 도입한 Swift와 C++ 혼합 코드베이스에서 소스 변경을 요구할 수 있습니다. 하지만 Swift는 새 버전의 Swift 툴체인을 도입할 때 새롭거나 발전된 C++ 상호 운용성 기능을 강제로 도입하도록 하지 않습니다. 이를 가능하게 하기 위해, 향후 Swift 릴리스는 기본 Swift 언어의 여러 호환성 버전을 지원하는 것처럼 C++ 상호 운용성의 여러 호환성 버전을 제공할 것입니다. 즉, 현재 호환성 버전의 C++ 상호 운용성을 사용하는 프로젝트는 후속 릴리스의 변경 사항으로부터 보호되며, 자체 속도에 맞춰 새로운 호환성 버전으로 이동할 수 있습니다.

## Swift에서 C++ 타입과 함수 사용하기

다양한 C++ 타입과 함수를 Swift에서 직접 사용할 수 있습니다.
이 섹션에서는 지원되는 타입과 함수를 Swift에서 사용하는 기본 방법을 다룹니다.

### C++ 함수 호출하기

가져온 모듈의 C++ 함수는 Swift의 익숙한 함수 호출 구문으로 호출할 수 있습니다. 예를 들어, 다음 C++ 함수를 Swift에서 사용할 수 있습니다:

```c++
void printWelcomeMessage(const std::string &name);
```

Swift 코드에서 이 함수를 일반 Swift 함수처럼 호출할 수 있습니다:

```swift
printWelcomeMessage("Thomas")
```

### C++ 구조체와 클래스는 기본적으로 값 타입

Swift는 기본적으로 C++ 구조체와 클래스를 Swift `struct` 타입으로 매핑합니다.
Swift는 이를 [값 타입](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures#Structures-and-Enumerations-Are-Value-Types)으로 간주합니다. 즉, Swift 코드에서 전달될 때 항상 복사됩니다.

Swift는 값을 복사하거나 스코프를 벗어날 때 값을 해제해야 할 경우 C++ 구조체 또는 클래스 타입의 특수 멤버를 사용합니다. C++ 타입에 복사 생성자가 있으면, Swift에서 해당 타입의 값이 복사될 때 이를 사용합니다. C++ 타입에 소멸자가 있으면, Swift에서 해당 타입의 Swift 값이 파괴될 때 소멸자를 호출합니다.

복사 생성자가 삭제된 C++ 구조체와 클래스는 복사 불가능한 Swift 타입(`~Copyable`)으로 표현됩니다. C++ 타입에 유효한 복사 생성자가 있더라도 `SWIFT_NONCOPYABLE` 매크로를 붙여 Swift에서 복사 불가능하게 만들 수 있습니다.

일부 C++ 타입은 C++에서 항상 포인터나 참조를 통해 전달됩니다. 따라서 이를 Swift에서 값 타입으로 매핑하는 것이 적합하지 않을 수 있습니다. 이러한 타입은 C++에서 어노테이션을 추가하여 Swift 컴파일러가 [Swift에서 참조 타입으로 매핑](#mapping-c-types-to-swift-reference-types)하도록 지시할 수 있습니다.

### Swift에서 C++ 타입 생성하기

C++ 구조체와 클래스 내부의 public 생성자 중
복사 생성자나 이동 생성자가 아닌 것은
Swift에서 이니셜라이저가 됩니다.

예를 들어, C++ `Color` 클래스의 세 가지 생성자 모두 Swift에서 사용할 수 있습니다:

```c++
class Color {
public:
  Color();
  Color(float red, float blue, float green);
  Color(float value);

  ...
  float red, blue, green;
};
```

위에 표시된 `Color` 생성자는 Swift에서 이니셜라이저가 됩니다.
Swift 코드에서 이를 호출하여 `Color` 타입의 값을 생성할 수 있습니다:

```swift
let theEmptiness = Color()
let oceanBlue = Color(0.0, 0.0, 1.0)
let seattleGray = Color(0.7)
```

### C++ 타입의 데이터 멤버 접근하기

C++ 구조체와 클래스의 public 데이터 멤버는 Swift에서 프로퍼티가 됩니다. 예를 들어, 위에 표시된 `Color` 클래스의 데이터 멤버는 다른 Swift 프로퍼티와 마찬가지로 접근할 수 있습니다:

```swift
let color: Color = getRandomColor()
print("Today I'm feeling \(color.red) red but also \(color.blue) blue")
```

### C++ 멤버 함수 호출하기

C++ 구조체와 클래스 내부의 멤버 함수는 Swift에서 메서드가 됩니다.

#### 상수 멤버 함수는 `nonmutating`

상수 멤버 함수는 `nonmutating` Swift 메서드가 되고, `const` 한정자가 없는 멤버 함수는 `mutating` Swift 메서드가 됩니다.
예를 들어, C++ `Color` 클래스의 다음 멤버 함수는 Swift에서 `mutating` 메서드로 간주됩니다:

```c++
void Color::invert() { ... }
```

가변 `Color` 값에서 `invert`를 호출할 수 있습니다:

```swift
var red = Color(1.0, 0.0, 0.0)
red.invert() // red becomes yellow.
```

상수 `Color` 값에서는 `invert`를 호출할 수 없습니다.

반면, 다음 상수 멤버 함수는 Swift에서 `mutating` 메서드가 아닙니다:

```c++
Color Color::inverted() const { ... }
```

따라서 상수 `Color` 값에서 `inverted`를 호출할 수 있습니다:

```swift
let darkGray = Color(0.2, 0.2, 0.2)
let veryLightGray = darkGray.inverted()
```

#### 상수 멤버 함수는 객체를 변경해서는 안 됨

Swift 컴파일러는 상수 멤버 함수가 `this`가 가리키는 인스턴스를 변경하지 않는다고 가정합니다. C++ 멤버 함수가 이 가정을 위반하면 Swift 코드가 `this`가 가리키는 인스턴스의 변경을 감지하지 못하고 나머지 Swift 코드 실행에서 원래 값을 사용하게 될 수 있습니다.

C++는 상수 멤버 함수에서 `mutable` 필드의 변경을 허용합니다.
이러한 필드가 있는 구조체나 클래스의 상수 멤버 함수는 Swift에서 여전히 `nonmutating` 메서드가 됩니다. Swift는 어떤 상수 함수가 객체를 변경하고 어떤 것이 변경하지 않는지 알 수 없으므로, API 사용성을 위해 Swift는 이러한 함수가 객체를 변경하지 않는다고 가정합니다. `SWIFT_MUTATING` 매크로로 명시적으로 어노테이션하지 않는 한, Swift에서 `mutable` 필드를 변경하는 상수 멤버 함수 호출은 피해야 합니다.

`SWIFT_MUTATING` 매크로를 사용하면 실제로 객체를 변경하는 상수 멤버 함수에 명시적으로 어노테이션할 수 있습니다. 이렇게 어노테이션된 함수는 Swift에서 `mutating` 메서드가 됩니다.

#### 참조를 반환하는 멤버 함수는 기본적으로 안전하지 않음

참조, 포인터, 또는 참조나 포인터를 포함하는 특정 구조체/클래스를 반환하는 멤버 함수는 함수를 호출하는 데 사용된 객체인 `this` 내부를 가리키는 참조를 반환하는 경우가 많습니다.
이러한 멤버 함수는 Swift에서 안전하지 않은 것으로 간주됩니다.
반환된 참조가 소유 객체와 연관되어 있지 않아 참조가 아직 사용 중인데 소유 객체가 파괴될 수 있기 때문입니다. Swift는 이러한 멤버 함수의 안전하지 않음을 강조하기 위해 자동으로 이름을 변경합니다.
Swift 이름에 두 개의 밑줄 접두사와 `Unsafe` 접미사가 추가됩니다. 예를 들어, 다음 멤버 함수는 Swift에서 `__getRootTreeUnsafe` 메서드가 됩니다:

```c++
class Forest {
public:
  const Tree &getRootTree() const { return rootTree; }

  ...
private:
  Tree rootTree;
};
```

어떤 함수가 안전하지 않은지 결정하는 규칙과 Swift에서 이러한 메서드를 안전하게 호출하기 위한 권장 가이드라인은 [Swift에서 C++ 참조 및 뷰 타입을 안전하게 다루는 방법](#working-with-c-references-and-view-types-in-swift)을 설명하는 후속 섹션에 문서화되어 있습니다.

#### 오버로드된 멤버 함수

C++는 `const` 한정자를 기반으로 멤버 함수를 오버로드할 수 있습니다.
예를 들어, `Forest` 클래스는 constness와 반환 타입만 다른 두 개의 `getRootTree` 멤버를 가질 수 있습니다:

```c++
class Forest {
public:
  const Tree &getRootTree() const { return rootTree; }
  Tree &getRootTree() { return rootTree; }

  ...
private:
  Tree rootTree;
};
```

두 `getRootTree` 멤버 함수는 Swift에서 메서드가 됩니다. Swift는 타입에 이미 같은 Swift 이름의 `nonmutating` 메서드가 있는 것을 발견하면, 같은 이름과 인자를 가진 두 개의 모호한 메서드를 피하기 위해 `mutating` 메서드의 이름을 변경합니다. 이름 변경 시 `mutating` 메서드 이름에 `Mutating` 접미사가 추가됩니다.
이 이름 변경은 메서드의 안전성을 고려하기 전에 수행됩니다.
위 예제에서 두 `getRootTree` 멤버 함수는 `Forest` 객체 내부를 가리키는 참조를 반환하므로 Swift에서 `__getRootTreeUnsafe`와 `__getRootTreeMutatingUnsafe` 메서드가 됩니다.

#### 가상 멤버 함수

C++ 값 타입의 가상 메서드는 Swift에서 호출할 수 없습니다. 이는 포인터나 참조에서만 가상 메서드를 호출할 수 있는 C++와 유사합니다.

#### 정적 멤버 함수

C++ 정적 멤버 함수는 Swift에서 `static` 메서드가 됩니다.

### Swift에서 상속된 멤버 접근하기

C++ 클래스나 구조체는 Swift에서 독립적인 타입이 됩니다. 기본 C++ 클래스와의 관계는 Swift에서 유지되지 않습니다.
Swift는 C++ 타입의 기본 클래스에서 상속된 멤버에 대한 접근을 최대한 제공하려고 합니다. C++ 기본 클래스의 public 멤버 함수와 데이터 멤버는 마치 해당 클래스 자체에 정의된 것처럼 Swift에서 메서드와 프로퍼티가 됩니다.

예를 들어, 다음 두 C++ 클래스는 두 개의 별개의 Swift 구조체가 됩니다:

```c++
class Plant {
public:
  void water(float amount) { moisture += amount; }
private:
  float moisture = 0.0;
};

class Fern: public Plant {
public:
  void trim();
};
```

`Fern` Swift 구조체에는 `Plant` C++ 클래스의 `water` 멤버 함수를 호출하는 `water`라는 추가 메서드가 생깁니다:

```swift
struct Plant {
  mutating func water(_ amount: Float)
}

struct Fern {
  init()
  mutating func water(_ amount: Float) // Calls `Plant::water`
  mutating func trim()
}
```

상속된 기본 타입의 멤버가 C++ 구조체나 클래스를 나타내는 Swift 타입에 언제 도입되는지 결정하는 정확한 규칙은 Swift 5.9에서 아직 확정되지 않았습니다. 다음 [GitHub 이슈](https://github.com/swiftlang/swift/issues/66323)에서 Swift 5.9에서의 확정 과정을 추적하고 있습니다.

### C++ 열거형 사용하기

범위 지정 C++ 열거형은 raw 값을 가진 Swift 열거형이 됩니다.
모든 케이스도 Swift 케이스로 매핑됩니다. 예를 들어, 다음 C++ 열거형을 Swift에서 사용할 수 있습니다:

```c++
enum class TreeKind {
  Oak,
  Redwood,
  Willow
};
```

이는 Swift에서 다음 열거형으로 표현됩니다:

```swift
enum TreeKind : Int32 {
  case Oak = 0
  case Redwood = 1
  case Willow = 2
}
```

Swift에서 다른 `enum`과 마찬가지로 사용할 수 있습니다:

```swift
func isConiferous(treeKind: TreeKind) -> Bool {
  switch treeKind {
    case .Redwood: return true
    default: return false
  }
}
```

범위 미지정 C++ 열거형은 Swift 구조체가 됩니다. 예를 들어, 다음 범위 미지정 `enum`은 Swift 구조체가 됩니다:

```c++
enum MushroomKind {
  Oyster,
  Portobello,
  Button
}
```

범위 미지정 C++ 열거형의 케이스는 Swift 구조체 외부의 변수가 됩니다:

```swift
struct MushroomKind : Equatable, RawRepresentable {
    public init(_ rawValue: UInt32)
    public init(rawValue: UInt32)
    public var rawValue: UInt32
}
var Oyster: MushroomKind { get }
var Portobello: MushroomKind { get }
var Button: MushroomKind { get }
```

### C++ 타입 별칭 사용하기

C++ `using` 또는 `typedef` 선언은 Swift에서 `typealias`가 됩니다.
예를 들어, 다음 `using` 선언은 Swift에서 `CustomString` 타입이 됩니다:

```c++
using CustomString = std::string;
```

### 클래스 템플릿 사용하기

클래스 또는 구조체 템플릿의 인스턴스화된 특수화는 Swift에서 별개의 타입으로 매핑됩니다. 예를 들어, 다음 인스턴스화되지 않은 C++ 클래스 템플릿은 그 자체로 Swift에서 사용할 수 없습니다:

```c++
template<class T, class U>
class Fraction {
public:
  T numerator;
  U denominator;

  Fraction(const T &, const U &);
};
```

하지만 클래스 템플릿의 인스턴스화된 특수화는 Swift에서 사용할 수 있습니다.
Swift로 매핑될 때 일반 C++ 구조체나 클래스처럼 취급됩니다. 예를 들어, `Fraction<int, float>` 템플릿 특수화는 Swift 구조체가 됩니다:

```swift
struct Fraction<CInt, Float> {
  var numerator: CInt
  var denominator: Float

  init(_: CInt, _: Float)
}
```

`Fraction<int, float>`과 같은 특수화를 반환하는 함수를 Swift에서 사용할 수 있습니다:

```c++
Fraction<int, float> getMagicNumber();
```

이 함수를 Swift에서 다른 Swift 함수처럼 호출할 수 있습니다:

```
let magicNum = getMagicNumber()
print(magicNum.numerator, magicNum.denominator)
```

C++ 타입 별칭은 클래스 템플릿의 특정 특수화를 참조할 수 있습니다. 예를 들어, Swift에서 `Fraction<int, float>`을 생성하려면 먼저 해당 템플릿 특수화를 참조하는 C++ 타입 별칭을 만들어야 합니다:

```c++
// Bring `Fraction<int, float>` type to Swift with a C++ `using` declaration.
using MagicFraction = Fraction<int, float>;
```

그러면 Swift에서 이 타입 별칭을 직접 사용할 수 있습니다:

```swift
let oneEights = MagicFraction(1, 8.0)
print(oneEights.numerator)
```

[이 문서의 후속 섹션](#conforming-class-template-to-swift-protocol)에서는 Swift 제네릭과 프로토콜 익스텐션을 사용하여 클래스 템플릿의 모든 특수화에서 동작하는 제네릭 Swift 코드를 작성하는 방법을 설명합니다.

## C++에서 Swift로의 매핑 커스터마이징

C++ 타입과 함수가 Swift에 매핑되는 방식의 기본값은 특정 C++ 함수나 타입에 제공된 커스터마이징 매크로 중 하나로 어노테이션하여 변경할 수 있습니다. 예를 들어, `SWIFT_NAME` 매크로를 사용하여 특정 C++ 함수에 다른 Swift 이름을 제공할 수 있습니다.

`<swift/bridging>` 헤더는 C++ 함수와 타입에 어노테이션하는 데 사용할 수 있는 커스터마이징 매크로를 정의합니다. 이 헤더는 Swift 툴체인과 함께 제공됩니다.

> Apple 및 Linux 플랫폼에서는 시스템의 C++ 컴파일러와
> Swift 컴파일러가 이 헤더를 자동으로 찾아야 합니다.
> Windows와 같은 다른 플랫폼에서는 이 헤더를 찾을 수 있도록
> C++ 및 Swift 컴파일러 호출에 추가 헤더 검색 경로 플래그(`-I`)를
> 추가해야 할 수 있습니다.

이 섹션에서는 `<swift/bridging>` 헤더의 커스터마이징 매크로 중 두 가지만 설명합니다. 다른 커스터마이징 매크로와 그 동작은 이 문서의 후속 섹션에 문서화되어 있습니다.
모든 커스터마이징 매크로의 [전체 목록](#list-of-customization-macros-in-swiftbridging)은 부록에서 제공됩니다.

### Swift에서 C++ API 이름 변경하기

`SWIFT_NAME` 매크로는 Swift에서 C++ 타입과 함수에 다른 이름을 제공합니다. `SWIFT_NAME` 매크로 안에 Swift 타입 이름을 지정하여 C++ 타입의 이름을 변경할 수 있습니다. 예를 들어, 다음 C++ 클래스는 Swift에서 `CxxLibraryError` 구조체로 이름이 변경됩니다:

```c++
class Error {
  ...
} SWIFT_NAME("CxxLibraryError");
```

함수의 이름을 변경할 때는 `SWIFT_NAME` 매크로 안에 Swift 함수 이름(인자 레이블 포함)을 지정해야 합니다.
예를 들어, 다음 C++ 함수는 Swift에서 `send`로 이름이 변경됩니다:

```c++
#include <swift/bridging>

void sendCopy(const std::string &) SWIFT_NAME(send(_:));
```

Swift에서 이 함수를 호출할 때는 새 이름을 사용해야 합니다:

```swift
send("Hello, this is Swift!")
```

### getter와 setter를 연산 프로퍼티로 매핑하기

`SWIFT_COMPUTED_PROPERTY` 매크로는 C++ getter 및 setter 멤버 함수를 Swift의 연산 프로퍼티로 매핑합니다. 예를 들어, 다음 getter와 setter 쌍은 Swift에서 단일 `treeKind` 연산 프로퍼티로 매핑됩니다:

```c++
#include <swift/bridging>

class Tree {
public:
  TreeKind getKind() const SWIFT_COMPUTED_PROPERTY;
  void setKind(TreeKind kind) SWIFT_COMPUTED_PROPERTY;

  ...
};
```

setter가 있으므로 Swift에서 이 프로퍼티를 변경할 수 있습니다:

```swift
func makeNotAConiferousTree(tree: inout Tree) {
  tree.kind = tree.kind == .Redwood ? .Oak : tree.kind
}
```

이 변환이 Swift에서 성공하려면 getter와 setter 모두 동일한 기본 C++ 타입에서 동작해야 합니다.

getter만 연산 프로퍼티로 매핑하는 것도 가능하며, 이 변환이 동작하는 데 setter가 필수는 아닙니다.

## Swift에서 C++ 타입 확장하기

Swift [익스텐션](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions)을 사용하여 Swift에서 C++ 타입에 새로운 기능을 추가할 수 있습니다. 기존 C++ 타입에 Swift 프로토콜 준수성을 추가하는 것도 가능합니다.

> 익스텐션은 C++ 타입에 새로운 기능을 추가할 수 있지만,
> C++ 타입의 기존 기능을 재정의할 수는 없습니다.

### C++ 타입을 Swift 프로토콜에 준수시키기

Swift 프로토콜 준수성은 C++ 타입이 정의된 후에 소급적으로 추가할 수 있습니다. 이러한 준수성을 통해 Swift에서 다음과 같은 사용이 가능해집니다:

- [프로토콜로 제약된](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics#Type-Constraints) 제네릭 Swift 함수와 타입이 준수하는 C++ 값과 함께 동작할 수 있습니다.
- [프로토콜 타입](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols#Protocols-as-Types)이 준수하는 C++ 값을 나타낼 수 있습니다.

예를 들어, Swift 익스텐션으로 C++ 클래스 `Tree`에 `Hashable` 준수성을 추가할 수 있습니다:

```swift
extension Tree: Hashable {
  static func == (lhs: Tree, rhs: Tree) -> Bool {
    return lhs.kind == rhs.kind
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.kind.rawValue)
  }
}
```

이 준수성을 통해 `Tree`를 Swift 딕셔너리의 키로 사용할 수 있습니다:

```swift
let treeEmoji: Dictionary<Tree, String> = [
  Tree(.Oak): "🌳",
  Tree(.Redwood): "🌲"
]
```

### 클래스 템플릿을 Swift 프로토콜에 준수시키기

Swift 익스텐션으로 Swift에서 특정 클래스 템플릿 특수화에 프로토콜 준수성을 추가할 수 있습니다. 예를 들어, 다음 클래스 템플릿의 인스턴스화된 특수화를 Swift에서 사용할 수 있습니다:

```c++
template<class T>
class SerializedValue {
public:
  T deserialize() const;

  ...
};

using SerializedInt = SerializedValue<int>;
using SerializedFloat = SerializedValue<float>;

SerializedInt getSerializedInt();
SerializedFloat getSerializedFloat();
```

이러한 템플릿 특수화는 Swift `extension`을 사용하여 프로토콜을 준수할 수 있습니다:

```swift
// Swift module 'Serialization'
protocol Deserializable {
  associatedtype ValueType

  func deserialize() -> ValueType
}

// `SerializedInt` specialization now conforms to `Deserializable`
extension SerializedInt: Deserializable {}
```

위 예제에서 `SerializedInt`는 `Deserializable` 프로토콜을 준수합니다.
하지만 `SerializedFloat`과 같은 클래스 템플릿의 다른 특수화는 `Deserializable`을 준수하지 않습니다.

`<swift/bridging>` 헤더의 `SWIFT_CONFORMS_TO_PROTOCOL` 커스터마이징 매크로를 사용하여 클래스 템플릿의 모든 특수화를 Swift 프로토콜에 자동으로 준수시킬 수 있습니다. 예를 들어, `SerializedValue` 클래스 템플릿의 정의에 `SWIFT_CONFORMS_TO_PROTOCOL` 어노테이션을 추가할 수 있습니다:

```c++
template<class T>
class SerializedValue {
public:
  using ValueType = T;
  T deserialize() const;

  ...
} SWIFT_CONFORMS_TO_PROTOCOL(Serialization.Deserializable);
```

`SWIFT_CONFORMS_TO_PROTOCOL` 어노테이션은 `SerializedInt`와 `SerializedFloat` 같은 모든 특수화가 Swift에서 자동으로 `Deserializable`을 준수하도록 합니다. 이를 통해 프로토콜 익스텐션을 사용하여 Swift에서 클래스 템플릿의 모든 특수화에 기능을 추가할 수 있습니다:

```swift
extension Deserializable {
  // All specializations of the `SerializedValue` template now have
  // `deserializedDescription` property in Swift.
  var deserializedDescription: String {
    "serialized value \(deserialize().description)"
  }
}
```

또한 추가적인 명시적 준수성 없이도 제약된 제네릭 코드에서 모든 특수화를 사용할 수 있습니다:

```swift
func printDeserialized<T: Deserializable>(_ item: T) {
  print("obtained: \(item.deserializedDescription)")
}

// Both `SerializedInt` and `SerializedFloat` specializations automatically
// conform to `Deserializable`
printDeserialized(getSerializedInt())
printDeserialized(getSerializedFloat())
```

## C++ 컨테이너 다루기

[`std::vector`](https://en.cppreference.com/w/cpp/container/vector) 클래스 템플릿과 같은 C++ 컨테이너 타입은 일반적으로 C++에서 이터레이터 기반 API를 제공합니다.
C++ 이터레이터를 Swift에서 사용하는 것은 [안전하지 않습니다](#do-not-use-c-iterators-in-swift). 이터레이터가 소유 컨테이너와 연관되어 있지 않아 이터레이터가 아직 사용 중인데 컨테이너가 파괴될 수 있기 때문입니다.
C++ 이터레이터에 의존하는 대신, Swift는 일부 C++ 컨테이너 타입을 다음을 가능하게 하는 프로토콜에 자동으로 준수시킵니다:

- 표준 Swift API를 사용하여 Swift에서 기본 컨테이너에 안전하게 접근합니다.
- C++ 컨테이너를 Swift 컬렉션 타입으로 변환하는 방법을 제공합니다.

이러한 프로토콜과 준수 규칙은 아래에 설명되어 있습니다.
이러한 프로토콜을 준수하는 C++ 컨테이너를 사용하는 권장 접근 방식은
[후속 섹션](#recommended-approach-for-using-c-containers)에 요약되어 있습니다.

### 일부 C++ 컨테이너는 Swift 컬렉션

Swift는 `std::vector`처럼 요소에 대한 랜덤 접근을 제공하는 C++ 컨테이너를 Swift의 `RandomAccessCollection` 프로토콜에 자동으로 준수시킵니다. 예를 들어, 다음 함수가 반환하는 `std::vector` 컨테이너는 Swift에 의해 자동으로 `RandomAccessCollection` 프로토콜을 준수합니다:

```c++
std::vector<Tree> getEnchantedTrees();
```

`RandomAccessCollection` 준수를 통해 `for-in` 루프와 같은 익숙한 제어 흐름 구문을 사용하여 Swift에서 컨테이너의 요소를 안전하게 순회할 수 있습니다. `map`과 `filter` 같은 컬렉션 메서드도 사용할 수 있습니다:

```swift
let trees = getEnchantedTrees()

// Traverse through the elements of a C++ vector.
for tree in trees {
  print(tree.kind)
}

// Filter the C++ vector and make a Swift Array that contains only
// the oak trees.
let oakTrees = getEnchantedTrees().filter { $0.kind == .Oak }
```

Swift의 count 프로퍼티는 컬렉션의 요소 수를 반환합니다.
Swift의 서브스크립트 연산자를 사용하여 컬렉션의 특정 요소에 접근할 수도 있습니다.
이를 통해 C++ 컨테이너의 개별 요소를 변경할 수 있습니다:

```swift
var trees = getEnchantedTrees()
for i in 0..<trees.count {
  trees[i].kind = .Oak
}
```

`RandomAccessCollection`을 준수하는 C++ 컨테이너는 `Array`와 같은 Swift 컬렉션 타입으로 쉽게 변환할 수 있습니다:

```swift
let treesArray = Array<Tree>(getEnchantedTrees())
```

Swift는 C++ 컨테이너 타입을 Swift 컬렉션 타입으로 자동 변환하지 **않습니다**. `std::vector`와 같은 C++ 컨테이너 타입에서 `Array`와 같은 Swift 컬렉션 타입으로의 변환은 Swift에서 명시적으로 수행해야 합니다.

#### 자동 컬렉션 준수의 성능 제약

Swift는 현재 `RandomAccessCollection`을 준수하는 C++ 컨테이너를 사용할 때 명시적인 성능 보장을 제공하지 않습니다. Swift는 다음 경우에 컨테이너의 깊은 복사를 수행할 가능성이 높습니다:

- 컨테이너가 `for-in` 루프에서 사용될 때.
- 컨테이너가 Swift의 `Sequence` 프로토콜에서 구현을 가져오는 `filter`와 `reduce` 같은 메서드와 함께 사용될 때.

이 제약은 [상태 페이지](status#performance-constraints)에서 추적되고 있습니다.
이 제약을 우회하기 위한 여러 전략이 [아래에 제시되어 있습니다](#using-c-containers-in-performance-sensitive-swift-code).

#### 랜덤 접근 C++ 컬렉션의 준수 규칙

C++ 컨테이너 타입이 Swift에서 `RandomAccessCollection`을 자동으로 준수하려면 다음 조건을 만족해야 합니다:

- C++ 컨테이너 타입에 `begin`과 `end` 멤버 함수가 있어야 합니다. 두 함수 모두 상수여야 하며 동일한 이터레이터 타입을 반환해야 합니다.
- C++ 이터레이터 타입이 [`RandomAccessIterator`](https://en.cppreference.com/w/cpp/named_req/RandomAccessIterator) C++ 요구 사항을 만족해야 합니다. C++에서 `operator +=`로 전진시킬 수 있어야 하고 `operator []`로 서브스크립트할 수 있어야 합니다.
- C++ 이터레이터 타입이 `operator ==`로 비교 가능해야 합니다.

이 조건이 만족되면, Swift는 기본 C++ 컨테이너 타입을 나타내는 Swift 구조체를 `CxxRandomAccessCollection` 프로토콜에 준수시키며, 이를 통해 `RandomAccessCollection` 준수성이 추가됩니다.

### C++ 컨테이너를 Swift 컬렉션으로 변환 가능

요소에 대한 랜덤 접근을 제공하지 않는 순차적 C++ 컨테이너 타입은 Swift에서 `CxxConvertibleToCollection` 프로토콜에 자동으로 준수됩니다.
예를 들어, 다음 함수가 반환하는 `std::set` 컨테이너는 Swift에 의해 자동으로 `CxxConvertibleToCollection` 프로토콜을 준수합니다:

```c++
std::set<int> getWinningNumers();
```

`CxxConvertibleToCollection` 준수를 통해 C++ 컨테이너를 `Array`나 `Set` 같은 Swift 컬렉션 타입으로 쉽게 변환할 수 있습니다. 예를 들어, `getWinningNumers`가 반환하는 `std::set`은 Swift `Array`와 Swift `Set` 모두로 변환할 수 있습니다:

```swift
let winners = getWinningNumers()
for number in Array(winners) {
  print(number)
}
let setOfWinners = Set(winners)
```

`CxxRandomAccessCollection` 프로토콜을 자동으로 준수하는 C++ 컨테이너는 `CxxConvertibleToCollection` 프로토콜도 자동으로 준수합니다.

#### `CxxConvertibleToCollection` 프로토콜의 준수 규칙

C++ 컨테이너 타입이 Swift에서 `CxxConvertibleToCollection`을 자동으로 준수하려면 다음 조건을 만족해야 합니다:

- C++ 컨테이너 타입에 `begin`과 `end` 멤버 함수가 있어야 합니다. 두 함수 모두 상수여야 하며 동일한 이터레이터 타입을 반환해야 합니다.
- C++ 이터레이터 타입이 [`InputIterator`](https://en.cppreference.com/w/cpp/named_req/InputIterator) C++ 요구 사항을 만족해야 합니다. C++에서 `operator ++`로 증가시킬 수 있어야 하고 `operator *`로 역참조할 수 있어야 합니다.
- C++ 이터레이터 타입이 `operator ==`로 비교 가능해야 합니다.

### Swift에서 연관 컨테이너 C++ 타입 사용하기

`std::map`과 같은 연관 C++ 컨테이너 타입은 검색 키를 사용하여 저장된 요소에 효율적으로 접근합니다.
이러한 검색을 수행하는 `find` 멤버 함수는 Swift에서 안전하지 않습니다. `find`를 사용하는 대신, Swift는 C++ 표준 라이브러리의 연관 컨테이너를 `CxxDictionary` 프로토콜에 자동으로 준수시킵니다. 이 준수를 통해 Swift에서 연관 C++ 컨테이너를 다룰 때 서브스크립트 연산자를 사용할 수 있습니다. 예를 들어, 다음 함수가 반환하는 `std::unordered_map`은 Swift에 의해 자동으로 `CxxDictionary` 프로토콜을 준수합니다:

```c++
std::unordered_map<std::string, std::string>
getAirportCodeToCityMappings();
```

반환된 `std::unordered_map` 값은 Swift에서 딕셔너리처럼 사용할 수 있으며, 서브스크립트가 컨테이너에 저장된 값을 반환하거나 해당 값이 없으면 `nil`을 반환합니다:

```swift
let mapping = getAirportCodeToCityMappings();
if let dubCity = mapping["DUB"] {
   print(dubCity)
}
```

제공된 서브스크립트는 구현 내부에서 컨테이너의 `find` 메서드를 안전하게 호출합니다.

연관 C++ 컨테이너는 Swift에서 요소를 수동으로 순회해야 할 때 `Array`와 같은 Swift 순차적 컬렉션 타입으로 변환할 수 있습니다.

Swift는 사용자 정의 연관 C++ 컨테이너를 `CxxDictionary`에 자동으로 준수시키지 않습니다. 수동으로 작성한 Swift `extension`을 사용하여 사용자 정의 연관 컨테이너 타입에 `CxxDictionary` 준수성을 소급적으로 추가할 수 있습니다.

### C++ 컨테이너 사용 시 권장 접근 방식

다음은 Swift에서 C++ 컨테이너를 사용하는 현재 권장 접근 방식을 요약한 것입니다:

- `RandomAccessCollection`을 준수하는 C++ 컨테이너를 순회하려면 `for-in` 루프를 사용합니다.
- `RandomAccessCollection`을 준수하는 C++ 컨테이너를 다룰 때 `map`이나 `filter` 같은 컬렉션 API를 사용합니다.
- `RandomAccessCollection`을 준수하는 C++ 컨테이너의 특정 요소에 접근하려면 서브스크립트 연산자를 사용합니다.
- 다른 순차적 컨테이너의 요소를 순회하거나 `map`이나 `filter` 같은 컬렉션 API를 사용하려면 Swift 컬렉션으로 변환합니다.
- 연관 C++ 컨테이너에서 값을 찾을 때 `CxxDictionary` 프로토콜의 서브스크립트 연산자를 사용합니다.

#### 성능에 민감한 Swift 코드에서 C++ 컨테이너 사용하기

Swift의 현재 `for-in` 루프는 요소를 순회할 때 C++ 컨테이너의 깊은 복사를 수행합니다. `CxxConvertibleToCollection` 프로토콜이 제공하는 `forEach` 메서드를 사용하면 이 복사를 피할 수 있습니다. 예를 들어, `getEnchantedTrees`가 반환하는 `std::vector<Tree>` 컨테이너를 Swift에서 `forEach` 메서드로 순회할 수 있습니다:

```swift
let trees = getEnchantedTrees()
// Swift should not copy the `trees` std::vector here.
trees.forEach { tree in
  print(tree.kind)
}
```

### Swift에서 C++ 컨테이너를 다루는 모범 사례

#### Swift에서 C++ 이터레이터 사용 금지

이 섹션 시작 부분에서 설명했듯이, Swift에서 C++ 이터레이터를 사용하는 것은 안전하지 않습니다. C++ 이터레이터를 잘못 사용하기 쉽습니다. 예를 들어:

- C++ 컨테이너가 파괴된 후에 이터레이터를 사용하기 쉽습니다.
- 컨테이너의 마지막 요소를 지나 전진한 이터레이터를 역참조하기 쉽습니다.

C++ 이터레이터 API에 의존하는 대신 C++ 컨테이너를 다룰 때 `CxxRandomAccessCollection`, `CxxConvertibleToCollection`, `CxxDictionary` 같은 프로토콜을 사용해야 합니다.

C++ 이터레이터를 반환하는 C++ 컨테이너 타입 내부의 멤버 함수는 [참조를 반환하는 멤버 함수](#member-functions-returning-references-are-unsafe-by-default)와 마찬가지로 Swift에서 안전하지 않은 것으로 표시됩니다.
이터레이터를 받거나 반환하는 최상위 함수 같은 다른 C++ API는 여전히 Swift에서 직접 사용할 수 있습니다.
Swift에서 이러한 함수의 사용은 피해야 합니다.

#### Swift 함수 호출 시 C++ 컨테이너 빌리기

C++ 컨테이너 타입은 Swift에서 값 타입이 됩니다. 즉, Swift에서 복사가 이루어질 때마다 Swift는 컨테이너의 복사 생성자를 호출하여 모든 요소를 복사합니다. 예를 들어, `CxxVectorOfInt` 타입으로 표현된 `std::vector<int>`가 다음 Swift 함수에 전달될 때마다 Swift는 모든 요소를 새 `vector`로 복사합니다:

```swift
func takesVectorType(_ : CxxVectorOfInt) {
  ...
}

let vector = createCxxVectorOfInt()
takesVectorType(vector) // 'vector' is copied here.
```

향후 Swift 릴리스에서 제공될 Swift의 [매개변수 소유권 수식자](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0377-parameter-ownership-modifiers.md)를 사용하면 불변 값을 함수에 전달할 때 복사를 피할 수 있습니다. 가변 값은 Swift 함수에 `inout`으로 전달하여 C++ 컨테이너의 깊은 복사를 피할 수 있습니다:

```swift
func mutatesVectorType(_ : inout CxxVectorOfInt) {
  ...
}

var vector = createCxxVectorOfInt()
takesVectorType(&vector) // 'vector' is not copied!
```

## C++ 타입을 Swift 참조 타입으로 매핑하기

Swift 컴파일러는 일부 C++ 타입에 어노테이션을 추가하여 Swift에서 참조 타입(또는 `class` 타입)으로 가져올 수 있도록 합니다. C++ 타입을 참조 타입으로 가져와야 하는지는 복잡한 문제이며, 이를 판단하는 두 가지 주요 기준이 있습니다.

첫 번째 기준은 객체의 정체성이 타입의 “값”의 일부인지 여부입니다. 두 객체의 주소를 비교하는 것이 단순히 같은 위치에 저장되어 있는지 확인하는 것인지, 아니면 더 의미 있는 측면에서 “같은 객체”를 나타내는지 결정하는 것인지에 대한 것입니다.

두 번째 기준은 C++ 클래스의 객체가 항상 참조로 전달되는지 여부입니다. 객체가 주로 원시 포인터(`*`), C++ 참조(`&` 또는 `&&`), 스마트 포인터(`std::unique_ptr`이나 `std::shared_ptr` 등)와 같은 포인터나 참조 타입을 사용하여 전달되는지? 원시 포인터나 참조로 전달될 때, 해당 메모리가 안정적이고 계속 유효할 것으로 기대되는지, 아니면 값을 독립적으로 유지해야 하는 경우 수신자가 객체를 복사해야 하는지? 객체가 일반적으로 할당되어 안정적인 주소에 머무른다면, 그 주소가 의미적으로 객체의 “값”의 일부가 아니더라도 해당 클래스는 관용적으로 참조 타입일 수 있습니다. 이는 때로 프로그래머의 판단에 달려 있습니다.

첫 번째이자 가장 중요한 기준은 종종 코드만 보고 컴파일러가 자동으로 판단할 수 없습니다. Swift 컴파일러가 C++ 타입을 Swift 참조 타입으로 매핑하도록 하려면, `<swift/bridging>` 헤더의 다음 커스터마이징 매크로 중 하나로 C++ 타입에 어노테이션해야 합니다:

- [`SWIFT_IMMORTAL_REFERENCE`](#immortal-reference-types)
- [`SWIFT_SHARED_REFERENCE`](#shared-reference-types)
- [`SWIFT_UNSAFE_REFERENCE`](#unsafe-reference-types)

### 불멸 참조 타입

**불멸** 참조 타입은 프로그램에 의해 개별적으로 관리되도록 설계되지 않았습니다. 이 타입의 객체는 할당된 후 사용을 추적하지 않고 의도적으로 누수됩니다. 때로 이 객체들이 진정으로 불멸인 것은 아닙니다. 예를 들어 아레나 할당되어 아레나 내의 다른 객체에서만 참조될 것으로 예상될 수 있습니다. 그럼에도 불구하고 개별적으로 관리될 것으로 기대되지 않습니다.

Swift가 불멸 참조 타입으로 할 수 있는 유일한 합리적인 작업은 비관리 클래스로 가져오는 것입니다. 객체가 진정으로 불멸인 경우 이는 완벽하게 괜찮습니다. 객체가 아레나 할당된 경우 이는 안전하지 않지만, C++ API의 선택을 감안하면 본질적으로 불가피한 수준의 비안전성입니다.

C++ 타입이 불멸 참조 타입임을 지정하려면 `SWIFT_IMMORTAL_REFERENCE` 속성을 적용합니다. 다음은 C++ 타입 `LoggerSingleton`에 `SWIFT_IMMORTAL_REFERENCE`를 적용한 예제입니다:
```c++
class LoggerSingleton {
public:
    LoggerSingleton(const LoggerSingleton &) = delete; // non-copyable

    static LoggerSingleton &getInstance();
    void log(int x);
} SWIFT_IMMORTAL_REFERENCE;
```

이제 `LoggerSingleton`이 Swift에서 참조 타입으로 가져와졌으므로, 프로그래머는 다음과 같이 사용할 수 있습니다:
```swift
let logger = LoggerSingleton.getInstance()
logger.log(123)
```

### 공유 참조 타입

**공유** 참조 타입은 C++에서 포인터나 참조로 전달되는 참조 카운팅 타입입니다. 일반적으로 다음 중 하나를 사용합니다:

- 객체에 침습적으로 저장된 참조 카운트를 증가 및 감소시키는 사용자 정의 retain 및 release 연산.
- 또는 객체 외부에 참조 카운트를 저장할 수 있는 `std::shared_ptr`과 같은 비침습적 공유 포인터 타입.

현재 Swift는 객체에 침습적으로 저장된 참조 카운트와 함께 사용자 정의 retain 및 release 연산을 사용하는 C++ 클래스 또는 구조체를 Swift 참조 타입(Swift `class`처럼 동작)으로 매핑할 수 있습니다. 참조 카운팅을 위해 `std::shared_ptr`에 의존하는 다른 타입은 여전히 Swift에서 값 타입으로 사용할 수 있습니다.

C++ 타입이 공유 참조 타입임을 지정하려면 `SWIFT_SHARED_REFERENCE` 커스터마이징 매크로를 사용합니다. 이 매크로는 retain과 release 함수 두 개의 인자를 받습니다. 이 함수들은 정확히 하나의 인자를 받고 void를 반환하는 전역 함수여야 합니다. 인자는 C++ 타입에 대한 포인터여야 합니다(기본 타입이 아님). Swift는 Swift 클래스를 retain 및 release하는 곳에서 이러한 사용자 정의 retain 및 release 함수를 호출합니다. 다음은 C++ 타입 `SharedObject`에 `SWIFT_SHARED_REFERENCE`를 적용한 예제입니다:

```c++
class SharedObject : IntrusiveReferenceCounted<SharedObject> {
public:
    SharedObject(const SharedObject &) = delete; // non-copyable
    SharedObject();
    static SharedObject* _Nonnull create() SWIFT_RETURNS_RETAINED;
    void doSomething();
} SWIFT_SHARED_REFERENCE(retainSharedObject, releaseSharedObject);

void retainSharedObject(SharedObject *);
void releaseSharedObject(SharedObject *);
```

위 예제에서 `SWIFT_RETURNS_RETAINED` 어노테이션은 반환된 값이 `+1` 소유권으로 전달됨을 지정합니다.
자세한 내용은 [C++에서 Swift로 공유 참조 타입을 반환할 때의 호출 규약](#calling-conventions-when-returning-shared-reference-types-from-c-to-swift)을 참조하세요.

이제 `SharedObject`가 Swift에서 참조 타입으로 가져와졌으므로, 프로그래머는 다음과 같이 사용할 수 있습니다:
```swift
let object1 = SharedObject.create()
let object2 = SharedObject() // The C++ constructor is imported as a Swift initializer
object1.doSomething()
object2.doSomething()
// `object` will be released here.
```

#### Swift에서 공유 참조 타입의 객체 생성하기

위 예제에서 보여주듯이, Swift 6.2부터 `SWIFT_SHARED_REFERENCE` 타입의 이니셜라이저를 호출하여 인스턴스를 생성할 수 있습니다.
Swift 컴파일러는 C++ 공유 참조 타입을 생성할 때 기본 `new` 연산자를 사용합니다.

`SWIFT_NAME("init(…)")` 어노테이션 매크로를 사용하여 사용자 정의 C++ 정적 팩토리 함수를 Swift 이니셜라이저로 가져올 수도 있습니다. 밑줄 플레이스홀더의 수가 팩토리 함수의 매개변수 수와 일치해야 합니다.
예를 들어:

```cpp
struct SharedObject {
  static SharedObject* make(int id) SWIFT_NAME("init(_:)");

  void doSomething();
} SWIFT_SHARED_REFERENCE(retainSharedObject, releaseSharedObject);
```

이 경우 Swift는 정적 `make` 함수를 Swift 이니셜라이저로 가져옵니다:

```swift
let object = SharedObject(42)
```

C++ 생성자와 `SWIFT_NAME`으로 사용자 어노테이션한 정적 팩토리가 동일한 매개변수 시그니처를 가진 경우, Swift는 이니셜라이저 호출을 해결할 때 정적 팩토리를 우선합니다.
이는 사용자 정의 할당자를 사용하거나 직접 생성을 완전히 비활성화하고 팩토리만 노출하려는 경우에 특히 유용합니다.

#### 파생 타입에서의 공유 참조 동작 추론

C++ 타입이 `SWIFT_SHARED_REFERENCE` 기본 타입을 상속하면, Swift 컴파일러는 파생 타입에 대해 `SWIFT_SHARED_REFERENCE` 어노테이션을 자동으로 추론합니다.
파생 타입도 참조 타입으로 가져와지며, 기본 클래스와 동일한 `retain` 및 `release` 함수를 사용합니다.
이 추론은 상속 체인(다중 또는 간접 상속 포함)의 모든 어노테이션된 기본 타입이 동일한 `retain` 및 `release` 함수를 가진 경우에 동작합니다.
여러 기본 타입에 충돌하는 `retain` 또는 `release` 함수가 있으면, 파생 타입은 Swift 값 타입으로 가져와지며 컴파일러가 경고를 내보냅니다.


이 추론은 현재 `SWIFT_SHARED_REFERENCE`에만 적용됩니다.
`SWIFT_IMMORTAL_REFERENCE`나 `SWIFT_UNSAFE_REFERENCE`로 어노테이션된 타입에는 적용되지 않습니다.

#### C++에서 Swift로 공유 참조 타입을 반환할 때의 호출 규약

C++ 함수와 메서드가 `SWIFT_SHARED_REFERENCE` 타입을 반환할 때는 반환된 값의 소유권을 지정해야 합니다.
이를 위해 함수와 메서드에 `SWIFT_RETURNS_RETAINED`와 `SWIFT_RETURNS_UNRETAINED` 어노테이션을 사용해야 합니다.
이 어노테이션은 Swift 컴파일러에게 타입이 `+1`(retained) 또는 `+0`(unretained)으로 반환되는지 알려줍니다.

```c++
// Returns +1 ownership.
SharedObject* _Nonnull makeOwnedObject() SWIFT_RETURNS_RETAINED;

// Returns +0 ownership.
SharedObject* _Nonnull getUnOwnedObject() SWIFT_RETURNS_UNRETAINED;
```

이 어노테이션은 경계에서 적절한 `retain`/`release` 연산이 삽입되도록 하는 데 필요합니다:

```swift
let owned = makeOwnedObject()
owned.doSomething()
// `owned` is already at +1, so no further retain is needed here

let unOwned = getUnOwnedObject()
// Swift inserts a retain operation on `unowned` here to bring it to +1.
unOwned.doSomething()
```

Swift 컴파일러는 `SWIFT_SHARED_REFERENCE` 타입을 반환하는 Swift 함수의 소유권 규약을 자동으로 추론합니다.
Swift에서 `SWIFT_SHARED_REFERENCE` 타입을 반환하는 Swift 함수를 C++에서 호출하는 방법은 [Swift에서 C++ 공유 참조 타입 다시 노출하기](#exposing-c-shared-reference-types-back-from-swift)를 참조하세요.

#### Swift에서 C++로 공유 참조 타입을 전달할 때의 호출 규약

C++ 공유 참조 타입이 Swift에서 C++ API에 인자로 전달되면, Swift 컴파일러는 전달된 값이 살아있음을 보장합니다.
Swift는 또한 값의 소유권을 유지합니다.
즉, 인자는 `+0`으로 전달되며 소유권 이전이 없습니다.
C++ 함수는 값의 소유권을 가졌다고 가정해서는 안 되며, 소유권을 가져야 하는 경우 필요한 retain 연산을 수행해야 합니다.
C++ 함수는 매개변수가 가리키는 값이 함수 호출 중 및 종료 시 살아있도록 보장할 책임이 있습니다.


```swift
var obj = SharedObject.create()
receiveSharedObject(obj) // Swift guarantees that obj is alive and it is passed at +0
```

```c++
void receiveSharedObject(SharedObject *sobj) {
  ...
  // Swift assumes that sobj is a valid, non-null object at the end of this function
}
```

인자가 아래와 같이 inout(non-const 참조)인 경우:

```c++
void takeSharedObjectAsInout(SharedObject *& x) { ... }
```

이는 Swift에서 다음과 같이 가져와집니다:

```swift
func takeSharedObjectAsInout(_ x: inout SharedObject) { ... }
```

C++ 함수는 인자의 값을 새 값으로 덮어쓸 수 있습니다.
하지만 C++ 함수는 이전 값을 release하고, 함수가 반환될 때 Swift 호출자가 새 값의 소유권을 갖도록 새 값이 적절히 retain되었는지 보장해야 합니다.
이러한 규칙을 준수하는 것은 Swift와 C++ 사이에서 `SWIFT_SHARED_REFERENCE`를 안전하고 올바르게 전달하는 데 필요합니다.
이 규칙은 참조 카운팅을 사용하는 공유 객체를 관리하기 위한 일반적으로 권장되는 규약이기도 합니다.

#### 상속과 가상 멤버 함수

값 타입과 마찬가지로, 파생 참조 타입의 인스턴스를 기본 참조 타입으로 캐스팅하거나 그 반대로 캐스팅하는 것은 아직 Swift에서 지원되지 않습니다.

참조 타입에 가상 메서드가 있으면 Swift에서 해당 메서드를 호출할 수 있습니다.
이는 순수 가상 메서드도 포함합니다.

#### Swift에서 C++ 공유 참조 타입 다시 노출하기

C++는 C++ 공유 참조 타입을 받거나 반환하는 Swift API를 호출할 수 있습니다. 이 타입의 객체는 항상 C++ 측에서 생성되지만, 참조는 Swift와 C++ 사이에서 앞뒤로 전달될 수 있습니다. 이 섹션에서는 이러한 참조를 언어 경계를 넘어 전달할 때 참조 카운트를 증가 및 감소시키는 규약을 설명합니다. 다음 Swift API를 살펴보겠습니다:

```swift
public func takeSharedObject(_ x : SharedObject) { ... }

public func returnSharedObject() -> SharedObject { ... }
```

`takeSharedObject` 함수의 경우, 컴파일러는 owned/guaranteed 호출 규약의 의미를 만족시키기 위해 `x`에 대한 retain 및 release 호출을 필요에 따라 자동으로 삽입합니다. C++ 호출자는 호출 기간 동안 `x`가 살아있음을 보장해야 합니다.
`returnSharedObject`와 같이 공유 참조 타입을 반환하는 함수는 소유권을 호출자에게 이전합니다.
이 함수의 C++ 호출자는 객체를 release할 책임이 있습니다.

### 안전하지 않은 참조 타입

`SWIFT_UNSAFE_REFERENCE` 어노테이션 매크로는 `SWIFT_IMMORTAL_REFERENCE` 어노테이션 매크로와 동일한 효과를 가집니다. 하지만 다른 의미를 전달합니다: 해당 타입은 프로그램의 전체 기간 동안 살아있는 것이 아니라 안전하지 않게 사용되도록 의도되었습니다.

## Swift에서 C++ 표준 라이브러리 사용하기

이 섹션에서는 C++ 표준 라이브러리를 가져오는 방법과 Swift에서 제공하는 타입을 사용하는 방법을 설명합니다.

### C++ 표준 라이브러리 가져오기

Swift는 `CxxStdlib` 모듈을 가져와 플랫폼의 C++ 표준 라이브러리를 가져올 수 있습니다.
`std` 네임스페이스는 Swift에서 `std` 열거형이 됩니다. `std` 네임스페이스 내부의 함수와 타입은 `std` Swift 열거형의 중첩 타입과 정적 함수가 됩니다.

상태 페이지에는 Swift가 지원하는 플랫폼에서 어떤 C++ 표준 라이브러리가 지원되는지 설명하는 [지원되는 C++ 표준 라이브러리 목록](status#c-standard-library-support)이 있습니다.

### `std::string` 사용하기

`std::string` C++ 타입은 Swift에서 구조체가 됩니다. `ExpressibleByStringLiteral` 프로토콜을 준수하므로 Swift에서 문자열 리터럴을 사용하여 직접 초기화할 수 있습니다:

```swift
import CxxStdlib

let s: std.string = "Hello C++ world!"
```

Swift `String`은 C++ `std::string`으로 쉽게 변환할 수 있습니다:

```swift
let swiftString = "This is " + "a Swift string"
let cxxString = std.string(swiftString)
```

반대 방향으로도 동일한 변환이 가능합니다. C++ `std::string`에서 Swift `String`으로:

```swift
let cxxString = std.string("This is a C++ string")
let swiftString = String(cxxString)
```

Swift는 C++ `std::string` 타입을 Swift의 `String` 타입으로 자동 변환하지 않습니다.

## Swift에서 C++ 참조와 뷰 타입 다루기

<div class="info" markdown="1">
Swift 6.2에서는 C/C++ 포인터와 `std::span` 같은 특정 뷰 타입을 Swift에서 안전하게 사용할 수 있는 새로운 [안전한 상호 운용](https://www.swift.org/documentation/cxx-interop/safe-interop) 모드가 도입되었습니다. 안전한 상호 운용 모드를 활성화하면 더 강력한 안전 보장을 제공하므로 권장합니다. 다음 섹션에서 설명하는 기능은 안전한 상호 운용 기능이 적용되지 않거나 너무 제한적인 경우(예: C++ 참조를 반환하는 API)에 여전히 사용할 수 있습니다.
</div>

[앞서](#member-functions-returning-references-are-unsafe-by-default) 설명했듯이, 참조, 포인터, 또는 참조나 포인터를 포함하는 특정 구조체/클래스를 반환하는 멤버 함수는 Swift에서 안전하지 않은 것으로 간주됩니다.
이러한 멤버 함수는 종종 `this` 객체 내부나 `this` 객체가 소유한 메모리를 다시 가리키는 참조나 뷰 타입을 반환합니다. 이 경우, 반환된 참조나 뷰가 가리키는 객체의 수명은 소유 객체(`this` 객체)의 수명에 **의존**한다고 합니다.
C++는 현재 어떤 멤버 함수가 의존적인 참조나 뷰를 반환하고 어떤 멤버 함수가 완전히 독립적인 참조나 뷰를 반환하는지 지정하지 않습니다.
따라서 Swift는 멤버 함수가 반환하는 모든 참조나 뷰 타입이 `this` 객체에 의존한다고 가정합니다.

의존적인 참조와 뷰 타입은 Swift에서 안전하지 않습니다. 참조나 뷰가 소유 객체와 연관되어 있지 않아 참조가 아직 사용 중인데 소유 객체가 파괴될 수 있기 때문입니다. 이러한 비안전성과 모든 참조와 뷰가 의존적이라는 가정 때문에, Swift는 이러한 멤버 함수의 이름을 변경하여 비안전성을 강조하고 Swift에서의 사용을 지양하도록 합니다.

이 섹션에서는 Swift가 어떤 멤버 함수가 의존적인 참조나 뷰 타입을 반환하는지 결정하는 데 사용하는 정확한 규칙을 설명하고, Swift에서 이러한 멤버 함수를 안전하게 호출하는 Swift 래퍼를 작성하는 방법을 제안합니다. 또한 Swift가 안전하지 않다고 생각하는 일부 멤버 함수를 안전한 것으로 취급하도록 C++ 코드에 적용할 수 있는 두 가지 새로운 커스터마이징 매크로도 소개합니다.

### Swift가 참조 또는 뷰 타입으로 간주하는 C++ 타입

Swift는 다음 타입 중 하나를 반환하는 C++ 멤버 함수가 Swift에서 안전하지 않다고 가정합니다:

- C++ 참조
- 원시 포인터
- 사용자 정의 복사 생성자가 없는 C++ 클래스 또는 구조체로, 이 목록에 있는 타입의 필드를 재귀적으로 포함하는 것.

예를 들어, 다음 두 C++ 구조체는 Swift의 관점에서 뷰 타입입니다:

```c++
struct PairIntRefs {
  int &firstValue;
  const int &secondImmutableValue;

  PairIntRefs(int &, const int &);
};

// Also a view type, since its `refs` field is a view type.
struct BagOfValues {
  PairIntRefs refs;
  int x;

  BagOfValues(PairIntRefs, int);
};
```

위에 설명된 규칙은 Swift가 의존적인 참조나 뷰 타입을 반환할 가능성이 높은 멤버 함수를 감지하는 데 사용하는 **휴리스틱**을 정의합니다.
이 휴리스틱은 의존적인 참조나 뷰를 반환하는 모든 C++ 멤버 함수가 Swift에 의해 감지됨을 보장하지 않으므로, 의존적인 참조나 뷰를 반환하는 일부 멤버 함수가 Swift에서 안전한 것으로 보일 수 있습니다.

### 의존적 수명의 참조에 안전하게 접근하기

의존적 수명의 참조나 뷰 타입을 반환하는 멤버 함수를 호출하는 권장 접근 방식은 참조된 객체의 복사본을 반환하는 Swift API로 래핑하는 것입니다.

예를 들어, `getRootTree` 멤버가 참조를 반환하는 `Forest` 클래스를 살펴보겠습니다:

```c++
class Forest {
public:
  const Tree &getRootTree() const { return rootTree; }
  Tree &getRootTree() { return rootTree; }

  ...
private:
  Tree rootTree;
};
```

[앞서](#overloaded-member-functions) 설명했듯이, 이 두 멤버 함수는 Swift에서 `__getRootTreeUnsafe`와 `__getRootTreeMutatingUnsafe` 메서드가 됩니다. 이러한 메서드는 코드에서 직접 호출하도록 의도된 것이 아닙니다. 대신 의존적 참조를 노출하지 않고 원하는 목적을 달성하는 래퍼를 작성하여 Swift 코드베이스 전체에서 사용해야 합니다. 예를 들어, Swift에서 기본 `rootTree` 값을 검사하려면 Swift에서 `Forest` 클래스를 확장하고 `Tree` 값을 반환하는 `rootTree` 연산 프로퍼티를 추가하는 래퍼를 만들 수 있습니다:

```swift
import forestLib

extension Forest {
  private borrowing func getRootTreeCopy() -> Tree {
    return __getRootTreeUnsafe().pointee
  }

  var rootTree: Tree {
    getRootTreeCopy()
  }
}
```

위에서 사용된 `borrowing` 소유권 수식자는 Swift 5.9에서 [새로 추가된](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0377-parameter-ownership-modifiers.md) 것입니다. Swift 5.9의 일부 개발 버전에서는 `Forest`와 같은 복사 가능한 C++ 타입에 `borrowing`을 사용하지 못할 수 있습니다. 이런 경우, Swift 5.9 릴리스 전에 대신 `mutating` 메서드 호출 체인을 사용하여 `getRootTree`가 반환하는 `Tree`를 안전하게 복사할 수 있습니다:

```swift
import forestLib

extension Forest {
  private mutating func getRootTreeCopy() -> Tree {
    return __getRootTreeUnsafeMutating().pointee
  }

  var rootTree: Tree {
    var mutCopy = self
    return mutCopy.getRootTreeCopy()
  }
}
```

### 독립적 수명의 참조와 뷰를 반환하는 메서드 사용하기

참조나 뷰 타입을 반환하는 일부 C++ 멤버 함수는 `this` 객체와 독립적인 수명의 참조를 반환할 수 있습니다. Swift는 여전히 이러한 멤버 함수를 안전하지 않다고 가정합니다. 이를 변경하려면 C++ 코드에 어노테이션을 추가하여 Swift에 다음 중 하나를 지시할 수 있습니다:
- 특정 C++ 멤버 함수가 완전히 독립적인 참조나 뷰를 반환한다고 가정합니다. 이러한 멤버 함수는 안전한 것으로 가정됩니다.
- 특정 C++ 클래스나 구조체가 **자기 완결적**이라고 가정합니다. 이러한 자기 완결적 타입을 반환하는 모든 멤버 함수는 안전한 것으로 가정됩니다.

#### 독립적 참조나 뷰를 반환하는 메서드 어노테이션하기

`<swift/bridging>` 헤더의 `SWIFT_RETURNS_INDEPENDENT_VALUE` 커스터마이징 매크로를 C++ 멤버 함수에 추가하여 의존적인 참조나 뷰를 반환하지 않음을 Swift에 알릴 수 있습니다. 이러한 멤버 함수는 Swift에서 안전한 것으로 가정됩니다.

예를 들어, `NatureLibrary` C++ 클래스의 `getName` 멤버 함수는 `SWIFT_RETURNS_INDEPENDENT_VALUE`의 좋은 후보입니다. 정의를 보면 `NatureLibrary` 객체 자체에 저장되지 않은 상수 정적 문자열 리터럴에 대한 포인터를 반환한다는 것을 알 수 있습니다:

```c++
class NatureLibrary {
public:
  const char *getName() const SWIFT_RETURNS_INDEPENDENT_VALUE {
    return "NatureLibrary";
  }
};
```

#### C++ 구조체나 클래스를 자기 완결적으로 어노테이션하기

`<swift/bridging>` 헤더의 `SWIFT_SELF_CONTAINED` 커스터마이징 매크로를 C++ 구조체나 클래스에 추가하여 뷰 타입이 아님을 Swift에 알릴 수 있습니다. 이러한 자기 완결적 타입을 반환하는 모든 멤버 함수는 Swift에서 안전한 것으로 가정됩니다.

## C++에서 Swift API 접근하기

Swift 컴파일러는 Swift 모듈에 정의된 Swift 타입과 함수를 나타내는 C++ 타입과 함수가 포함된 헤더 파일을 생성할 수 있습니다.
이 헤더 파일을 C++ 코드에서 포함하면 C++에서 Swift 타입을 사용하고 Swift 함수를 호출할 수 있습니다.

Swift는 생성된 헤더 파일을 생성할 때 Swift 모듈에 정의된 모든 public 타입과 함수를 C++에 노출 대상으로 간주합니다.
하지만 아직 모든 public 타입과 함수를 C++로 표현할 수 있는 것은 아닙니다.
어떤 Swift 타입과 함수가 현재 생성된 헤더에서 C++에 노출되는지 결정하는 정확한 규칙은 [다음 상태 페이지 섹션](status#supported-swift-apis)에 설명되어 있습니다.

## C++에서 Swift 타입과 함수 사용하기

다양한 Swift 타입과 함수가 C++에 노출됩니다.
이 섹션에서는 노출된 Swift 타입과 함수를 C++에서 사용하는 기본 방법을 다룹니다.

### Swift 함수 호출하기

C++에 노출된 최상위 Swift 함수는 생성된 헤더에서 `inline` C++ 함수가 됩니다. C++ 함수는 Swift 모듈을 나타내는 C++ `namespace`에 배치됩니다. 이러한 C++ 함수의 본문은 어떠한 간접 참조 없이 C++에서 네이티브 Swift 함수를 직접 호출합니다.

예를 들어, 다음 Swift 함수는 생성된 헤더에서 C++에 노출됩니다:

```swift
// Swift module 'Greeter'

public func printWelcomeMessage(_ name: String) {
  print("Welcome \(name)")
}
```

C++ 코드에서 생성된 헤더를 포함한 후 `printWelcomeMessage`를 호출할 수 있습니다:

```c++
#include <Greeter-Swift.h>

void cPlusPlusCallsSwift() {
  Greeter::printWelcomeMessage("Theo");
}
```

### C++에서 Swift 구조체 사용하기

C++에 노출된 Swift 구조체는 생성된 헤더에서 final C++ 클래스가 됩니다. 최상위 구조체는 Swift 모듈을 나타내는 C++ `namespace`에 배치됩니다. 노출된 이니셜라이저, 메서드, 프로퍼티는 C++ 클래스의 멤버가 됩니다.

Swift 구조체를 나타내는 C++ 클래스는 복사 가능합니다. 복사 생성자는 기본 Swift 값을 새 값으로 복사합니다. C++ 클래스의 소멸자는 기본 Swift 값을 파괴합니다.

현재 Swift 구조체를 나타내는 C++ 클래스는 C++에서 `std::move`로 이동할 수 없습니다.

#### C++에서 Swift 구조체 생성하기

Swift 구조체의 노출된 이니셜라이저는 C++ 클래스에서 정적 `init` 멤버 함수가 됩니다. C++ 코드에서 이러한 함수 중 하나를 호출하여 C++에서 구조체의 인스턴스를 생성할 수 있습니다.

예를 들어, Swift는 아래에 표시된 `MountainPeak` 구조체를 생성된 헤더에서 노출합니다:

```swift
// Swift module 'Landscape'

public struct MountainPeak {
  let name: String
  let height: Float

  public init(name: String, height: Float) {
    self.name = name
    self.height = height
  }
}
```

`MountainPeak` C++ 클래스의 `init` 정적 멤버 함수를 사용하여 C++에서 `MountainPeak` 인스턴스를 생성할 수 있습니다:

```c++
#include <Landscape-Swift.h>
using namespace Landscape;

void createMountainRange() {
  auto tallestMountain = MountainPeak::init("Everest", 8848.9);
}
```

### C++에서 Swift 클래스 사용하기

C++에 노출된 Swift 클래스는 생성된 헤더에서 C++ 클래스가 됩니다. 최상위 클래스는 Swift 모듈을 나타내는 C++ `namespace`에 배치됩니다. 노출된 이니셜라이저, 메서드, 프로퍼티는 C++ 클래스의 멤버가 됩니다.

Swift 클래스를 나타내는 C++ 클래스는 복사 및 이동이 가능합니다.
복사 생성자, 이동 생성자, 소멸자는 Swift의 [자동 참조 카운팅](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting)(ARC) 모델의 규칙을 따르며, 이를 통해 프로그램이 더 이상 참조되지 않는 Swift 클래스 인스턴스를 해제할 수 있습니다.

예를 들어, Swift는 아래에 표시된 `MountainRange` 클래스를 생성된 헤더에서 노출합니다:

```swift
// Swift module 'Landscape'

public class MountainRange {
  let peaks: [MountainPeak]

  public init(peaks: [MountainPeak]) {
    self.peaks = peaks
  }
}

public func createSierras() -> MountainRange {
  ...
}

public func render(mountainRange: MountainRange) {
  ...
}
```

`MountainRange` 인스턴스는 C++에서 안전하게 전달할 수 있습니다. ARC가 더 이상 사용되지 않으면 이를 해제합니다:

```c++
#include <Landscape-Swift.h>
using namespace Landscape;

void renderSierras() {
  MountainRange range = createSierras();
  render(range);
  // The `MountainRange` instance that `range` points to is freed by ARC when
  // this C++ function returns.
}
```

Swift 클래스의 상속 계층은 노출된 Swift 클래스를 나타내는 C++ 클래스로 형성된 C++ 상속 계층을 사용하여 표현됩니다.

### C++에서 Swift 열거형 사용하기

C++에 노출된 Swift 열거형은 생성된 헤더에서 C++ 클래스가 됩니다. 최상위 열거형은 Swift 모듈을 나타내는 C++ `namespace`에 배치됩니다. 노출된 이니셜라이저, 메서드, 프로퍼티는 C++ 클래스의 멤버가 됩니다.

Swift 열거형을 나타내는 C++ 클래스는 복사 가능합니다. 복사 생성자는 기본 Swift 값을 새 값으로 복사합니다. C++ 클래스의 소멸자는 기본 Swift 값을 파괴합니다. 현재 Swift 열거형을 나타내는 C++ 클래스는 C++에서 `std::move`로 이동할 수 없습니다.

열거형 케이스는 열거형을 나타내는 C++ 클래스에서 `static inline` 상수 C++ 데이터 멤버가 됩니다. 이 멤버를 통해:
- C++에서 특정 케이스 값으로 설정된 Swift 열거형을 생성할 수 있습니다.
- C++에서 `switch` 문을 사용하여 Swift 열거형을 분기할 수 있습니다.

예를 들어, 다음 Swift 열거형이 생성된 헤더에서 노출됩니다:

```swift
// Swift module 'Landscape'

public enum VolcanoStatus {
  case dormant
  case active
}
```

C++에서 열거형 케이스를 나타내는 멤버 중 하나에 `operator()`를 사용하여 `VolcanoStatus` 인스턴스를 생성할 수 있습니다.
C++의 `switch` 문 내 `case` 조건에서도 이러한 멤버를 참조할 수 있습니다:

```c++
#include <Landscape-Swift.h>
using namespace Landscape;

VolcanoStatus invertVolcanoStatus(VolcanoStatus status) {
  switch (status) {
  case VolcanoStatus::dormant:
    return VolcanoStatus::active(); // Returns `VolcanoStatus.active` case.
  case VolcanoStatus::active:
    return VolcanoStatus::dormant(); // Returns `VolcanoStatus.dormant` case.
  }
}
```

C++ `unknownDefault` 멤버를 사용하면 탄력적(resilient) Swift 열거형에 대해 전체를 포괄하는 C++ `switch`를 작성할 수 있습니다. 이러한 열거형은 향후 C++ 코드가 알지 못하는 더 많은 케이스를 가질 수 있기 때문입니다.

#### 연관 값이 있는 열거형 사용하기

Swift는 열거형의 특정 케이스에 값 집합을 연관시킬 수 있습니다. 케이스에 하나의 연관 값이 있거나 연관 값이 없는 열거형은 C++에 노출됩니다. 생성된 헤더에서 C++ 클래스가 됩니다. 이 C++ 클래스의 인터페이스는 연관 값이 없는 Swift 열거형에 대해 생성된 클래스의 인터페이스와 매우 유사합니다. 이 클래스에는 열거형이 어떤 케이스로 설정되어 있는지 확인한 후 연관 값을 추출할 수 있는 추가 getter 멤버 함수도 포함됩니다.

예를 들어, 다음과 같은 연관 값이 있는 Swift 열거형이 생성된 헤더에서 노출됩니다:

```swift
// Swift module 'Landscape'

public enum LandmarkIdentifier {
  case name(String)
  case id(Int)
}
```

`LandmarkIdentifier`의 케이스 중 하나에 연관된 값은 C++에서 적절한 getter 메서드를 호출하여 추출할 수 있습니다:

```c++
#include <Landscape-Swift.h>
#include <iostream>
using namespace Landscape;

void printLandmarkIdentifier(LandmarkIdentifier identifier) {
  switch (status) {
  case LandmarkIdentifier::name:
    std::cout << (std::string)identifier.getName();
    break;
  case LandmarkIdentifier::id:
    std::cout << "unnamed landmark #" << identifier.getId();
    break;
  }
}
```

C++에서 새 `LandmarkIdentifier` 인스턴스를 생성할 수도 있습니다:

```c++
auto newLandmarkId = LandmarkIdentifier::id(1234);
```

### Swift 메서드 호출하기

Swift 메서드는 C++에서 멤버 함수가 됩니다.

Swift 구조체와 열거형에는 `mutating`과 `nonmutating` 메서드가 있습니다.
`nonmutating` 메서드는 C++에서 상수 멤버 함수가 됩니다.

### C++에서 Swift 프로퍼티 접근하기

저장 프로퍼티와 연산 프로퍼티 모두 C++에서 getter와 setter 멤버 함수가 됩니다. getter는 Swift 프로퍼티의 값을 반환하는 상수 멤버 함수입니다. 가변 프로퍼티는 C++에 setter도 있습니다. setter는 멤버 함수이며 Swift 값 타입의 불변 인스턴스에서 호출해서는 안 됩니다.

예를 들어, 다음 Swift 구조체가 생성된 헤더에서 C++에 노출됩니다:

```swift
public struct LandmarkLocation {
  public var latitude: Float
  public var longitude: Float
}
```

C++ 코드에서 `getLatitude`와 `getLongitude` 멤버 함수를 호출하여 저장 프로퍼티 값에 접근할 수 있습니다.

## C++에서 Swift 표준 라이브러리 타입 사용하기

여러 Swift 표준 라이브러리 타입을 C++에서 사용할 수 있습니다. 이 섹션에서는 [지원되는 Swift 표준 라이브러리 타입](status#supported-swift-standard-library-types)을 C++에서 사용하는 방법을 설명합니다.

### C++에서 Swift `String` 사용하기

Swift의 `String` 타입은 C++에 노출됩니다. C++에서 문자열 리터럴을 사용하여 직접 초기화할 수 있습니다:

```c++
#include <SwiftLibrary-Swift.h>

void createSwiftString() {
  swift::String test = "Hello Swift world!";
}
```

C++ `std::string`은 Swift `String`으로 쉽게 변환할 수 있습니다:

```c++
void callSwiftAPI(const std::string &stringValue) {
  SwiftLibrary::functionTakesString(swift::String(stringValue));
}
```

반대 방향으로도 동일한 변환이 가능합니다. Swift `String`에서 C++ `std::string`으로:

```c++
std::string getStringFromSwift() {
  return (std::string)SwiftLibrary::giveMeASwiftString();
}
```

`String`의 C++ 표현은 다음을 포함한 여러 String 메서드와 프로퍼티에 대한 접근을 제공합니다:

- `isEmpty`
- `getCount`
- `lowercased`와 `uppercased`
- `hasPrefix`와 `hasSuffix`
- `append`

여기에 나열되지 않은 다른 여러 메서드와 프로퍼티도 사용할 수 있습니다.

Objective-C++ 언어 모드에서 Objective-C `NSString *`은 Swift `String`으로 또는 그 반대로 변환할 수 있습니다.

### C++에서 Swift `Array` 사용하기

Swift의 `Array` 타입은 C++에 노출됩니다. C++에서는 `swift::Array` 클래스 템플릿으로 표현됩니다. Swift 타입을 나타내는 C++ 타입으로 인스턴스화해야 합니다. 네이티브 C++ 타입으로도 인스턴스화할 수 있는데, Swift에서 해당 타입의 Swift `Array`가 사용되고 public Swift API를 통해 C++에 다시 노출될 때입니다.

Swift `Array`는 C++에서 `for` 루프로 순회할 수 있습니다. 예를 들어, `StringsAndNumbers` Swift 모듈 인터페이스를 살펴보겠습니다:

```swift
// Swift module 'StringsAndNumbers'

public func findTheStrings() -> [String]
public func processRandomNumbers(_ numbers: [Float])
```

C++ `for` 루프로 `findTheStrings`가 반환하는 `Array`를 순회할 수 있습니다:

```c++
#include <StringsAndNumbers-Swift.h>

void printTheFoundStrings() {
  auto stringsArray = StringsAndNumbers::findTheStrings();
  for (const auto &swiftString: stringsArray) {
    std::cout << (std::string)swiftString << ", ";
  }
}
```

C++에서 빈 `Array`를 생성하고 변경한 후 Swift에 전달할 수 있습니다.
예를 들어, C++ 코드에서 부동 소수점 숫자를 포함하는 `Array`를 만들어 `processRandomNumbers`에 전달할 수 있습니다:

```c++
#include <StringsAndNumbers-Swift.h>

void processSomeTrulyUniqueRandomNumbers() {
  auto array = swift::Array<float>::init();
  array.append(1.0f);
  array.append(42.0f);
  StringsAndNumbers::processRandomNumbers(array);
}
```

C++에서 `operator []`를 사용하여 배열의 개별 요소에 접근할 수 있습니다.
하지만 `operator []`로 배열 요소를 변경할 수는 없습니다. C++는 아직 Swift `Array`의 개별 요소 변경을 지원하지 않습니다.

`Array`의 C++ 표현은 다음을 포함한 여러 Array 메서드와 프로퍼티에 대한 접근을 제공합니다:

- `getCount`
- `getCapacity`
- `append`
- `insertAt`
- `removeAt`

여기에 나열되지 않은 다른 여러 메서드와 프로퍼티도 사용할 수 있습니다.

### C++에서 Swift `Optional` 사용하기

Swift의 `Optional` 타입은 C++에 노출됩니다. C++에서는 `swift::Optional` 클래스 템플릿으로 표현됩니다. Swift 타입을 나타내는 C++ 타입으로 인스턴스화해야 합니다. 네이티브 C++ 타입으로도 인스턴스화할 수 있는데, Swift에서 해당 타입의 Swift `Array`가 사용되고 public Swift API를 통해 C++에 다시 노출될 때입니다.

Swift `Optional`에 저장된 값은 `get` 멤버 함수를 사용하여 추출할 수 있습니다. 예를 들어, `OptionalValues` Swift 모듈 인터페이스를 살펴보겠습니다:

```swift
// Swift module 'OptionalValues'

public func maybeMakeString() -> String?
public func callMeOnThePhoneMaybe(_ number: UInt64?)
```

C++ `get` 멤버 함수를 사용하여 `maybeMakeString`이 반환하는 `String` 값을 추출할 수 있습니다:

```c++
#include <OptionalValues-Swift.h>

void printAStringOrNone() {
  auto maybeString = OptionalValues::maybeMakeString();
  if (maybeString) {
    std::cout << (std::string)maybeString.get() << "\n";
  } else {
    std::cout << "Got no value from Swift :( \n";
  }
}
```

`Optional`은 C++에서 `bool`로 암시적 변환이 가능합니다. 위 예제처럼 `if` 조건에서 값이 있는지 확인할 수 있습니다.

Swift `Optional`은 `some` 또는 `none` 케이스 생성자를 사용하여 C++에서도 생성할 수 있습니다:

```c++
#include <OptionalValues-Swift.h>

void callMeOnThePhone() {
  OptionalValues::callMeOnThePhoneMaybe(
    swift::Optional<uint64_t>::some(1234567890));
}
```

## 부록

이 섹션에는 위 문서에서 설명한 특정 주제에 대한 추가 표와 참고 자료가 포함되어 있습니다.

### `<swift/bridging>`의 커스터마이징 매크로 목록

| 매크로 | 문서 |
| --- | --- |
| `SWIFT_NAME` | [Swift에서 C++ API 이름 변경하기](#renaming-c-apis-in-swift) |
| `SWIFT_COMPUTED_PROPERTY` | [getter와 setter를 연산 프로퍼티로 매핑하기](#mapping-getters-and-setters-to-computed-properties) |
| `SWIFT_CONFORMS_TO_PROTOCOL` | [클래스 템플릿을 Swift 프로토콜에 준수시키기](#conforming-class-template-to-swift-protocol) |
| `SWIFT_IMMORTAL_REFERENCE` | [불멸 참조 타입](#immortal-reference-types) |
| `SWIFT_SHARED_REFERENCE` | [공유 참조 타입](#shared-reference-types) |
| `SWIFT_UNSAFE_REFERENCE` | [안전하지 않은 참조 타입](#unsafe-reference-types) |
| `SWIFT_RETURNS_INDEPENDENT_VALUE` | [독립적 참조나 뷰를 반환하는 메서드 어노테이션하기](#annotating-methods-returning-independent-references-or-views) |
| `SWIFT_MUTATING` | [상수 멤버 함수는 객체를 변경해서는 안 됨](#constant-member-functions-must-not-mutate-the-object) |
| `SWIFT_NONCOPYABLE` | [C++ 구조체와 클래스는 기본적으로 값 타입](#c-structures-and-classes-are-value-types-by-default) |
| `SWIFT_SELF_CONTAINED` | [C++ 구조체나 클래스를 자기 완결적으로 어노테이션하기](#annotating-c-structures-or-classes-as-self-contained) |

## 문서 수정 이력

이 섹션은 이 레퍼런스 가이드에 대한 최근 변경 사항을 나열합니다.

**2025-04-07**

- C++ 참조 타입의 가상 메서드를 이제 Swift에서 사용할 수 있습니다.
- `std::unique_ptr`이 이제 Swift에서 지원됩니다.

**2024-08-12**

- `<swift/bridging>`의 여러 커스터마이징 매크로를 목록에 추가했습니다.

**2024-06-11**

- 복사 불가능한 C++ 타입을 이제 Swift에서 사용할 수 있습니다.

**2024-03-26**

- Swift에서의 C++ 템플릿 연산자 지원 상태를 업데이트했습니다.

**2023-06-05**

- Swift와 C++를 혼합하는 방법을 설명하는 가이드의 초기 버전을 게시했습니다.
