## 표준 라이브러리 설계

Swift 표준 라이브러리는 기본 데이터 타입(예: `Int`, `Double`), 컬렉션(예: `Array`, `Dictionary`)과 이를 설명하는 프로토콜 및 이에 대해 동작하는 알고리즘, 문자와 문자열, 저수준 기본 요소(예: `UnsafeMutablePointer`) 등 다양한 데이터 타입, 프로토콜, 함수를 포함합니다. 표준 라이브러리의 구현은 [Swift 저장소][swift-repo]의 `stdlib/public` 하위 디렉터리에 있으며, 다음과 같이 세분화됩니다:

- **표준 라이브러리 코어**: 모든 데이터 타입, 프로토콜, 함수 등의 정의를 포함하는 표준 라이브러리의 핵심([stdlib/public/core](https://github.com/swiftlang/swift/tree/main/stdlib/public/core)에 구현)입니다.

- **런타임**: 컴파일러와 코어 표준 라이브러리 사이에 위치하는 언어 지원 런타임([stdlib/public/runtime](https://github.com/swiftlang/swift/tree/main/stdlib/public/runtime)에 구현)입니다. 캐스팅(예: `as!` 및 `as?` 연산자), 타입 메타데이터(제네릭과 리플렉션 지원), 메모리 관리(객체 할당, 참조 카운팅 등) 같은 언어의 동적 기능 구현을 담당합니다. 상위 레벨 라이브러리와 달리 런타임은 주로 C++로, 상호 운용성이 필요한 경우 Objective-C로 작성됩니다.

- **SDK 오버레이**: Apple 플랫폼 전용으로, SDK 오버레이([stdlib/public/Platform](https://github.com/swiftlang/swift/tree/main/stdlib/public/Platform)에 구현)는 기존 Objective-C 프레임워크의 Swift 매핑을 개선하기 위한 Swift 전용 추가 사항과 수정을 제공합니다. 특히 `Foundation` 오버레이는 Objective-C 코드와의 상호 운용성을 위한 추가 지원을 제공합니다.

Swift 표준 라이브러리는 Swift로 작성되었지만, 다른 Swift 코드가 빌드되는 기반이 되는 핵심 데이터 타입을 구현하는 스택의 가장 낮은 수준의 Swift 코드이기 때문에 일반 Swift 코드와 약간 다릅니다. 차이점은 다음과 같습니다:

- **컴파일러 빌트인 접근**: 일반적으로 표준 라이브러리만 접근할 수 있는 `Builtin` 모듈은 SIL 명령을 직접 생성하는 등의 컴파일러 빌트인 함수와 "원시" 포인터, 기본 LLVM 정수 타입 등 Swift 프로그래밍의 기초가 되는 데이터 타입을 구현하는 데 필요한 데이터 타입을 제공합니다.

- **가시성은 보통 관례로 관리**: 표준 라이브러리의 컴파일 및 최적화 방식으로 인해, 표준 라이브러리 선언은 일반적으로 원하는 것보다 더 높은 가시성을 가져야 하는 경우가 많습니다. 예를 들어 `private` 수정자는 사용되지 않습니다. 더 중요한 것은, 공개 인터페이스로 의도하지 않았지만 `public`으로 만들어야 하는 경우가 많다는 점입니다. 이런 경우 공개 API가 사실은 비공개임을 나타내기 위해 밑줄로 시작하는 접두사를 사용해야 합니다. 표준 라이브러리의 접근 제어 정책은 [docs/AccessControlInStdlib.rst](https://github.com/swiftlang/swift/blob/main/docs/AccessControlInStdlib.rst)에 문서화되어 있습니다.

- **반복적인 코드는 gyb를 사용**: [gyb](https://github.com/swiftlang/swift/blob/main/utils/gyb.py)는 표준 라이브러리에서 자주 사용되는 템플릿에서 반복적인 코드를 생성하는 간단한 도구입니다. 예를 들어, 하나의 소스에서 다양한 크기의 정수 타입(`Int8`, `Int16`, `Int32`, `Int64` 등)의 정의를 만드는 데 사용됩니다.

- **테스트는 컴파일러와 밀접하게 연결**: 표준 라이브러리와 컴파일러는 함께 발전하며 긴밀하게 결합되어 있습니다. 핵심 데이터 타입(예: `Array` 또는 `Int`)의 변경은 컴파일러 측 변경이 필요할 수 있으며, 그 반대도 마찬가지이므로, 표준 라이브러리 테스트 스위트는 컴파일러와 동일한 디렉터리 구조인 [test/stdlib](https://github.com/swiftlang/swift/tree/main/test/stdlib) 및 [validation-test/stdlib](https://github.com/swiftlang/swift/tree/main/validation-test/stdlib)에 저장됩니다.

[swift-repo]: https://github.com/swiftlang/swift 'Swift 저장소'
