## 컴파일러 아키텍처

전체적으로 Swift 컴파일러는 주로 Swift 소스 코드를 효율적이고 실행 가능한 머신 코드로 변환하는 역할을 합니다. 그러나 Swift 컴파일러 프론트엔드는 구문 강조, 코드 완성 등 IDE 통합을 포함한 여러 다른 도구도 지원합니다. 이 문서는 Swift 컴파일러의 주요 구성 요소에 대한 상위 수준 설명을 제공합니다:

- **파싱(Parsing)**: 파서는 통합된 수작업 렉서를 가진 간단한 재귀 하향 파서([lib/Parse](https://github.com/swiftlang/swift/tree/main/lib/Parse)에 구현)입니다. 파서는 시맨틱이나 타입 정보 없이 추상 구문 트리(AST)를 생성하며, 입력 소스의 문법 문제에 대한 경고나 오류를 발생시킵니다.

- **시맨틱 분석(Semantic analysis)**: 시맨틱 분석([lib/Sema](https://github.com/swiftlang/swift/tree/main/lib/Sema)에 구현)은 파싱된 AST를 받아 올바른 형태의 완전한 타입 체크 AST로 변환하며, 소스 코드의 시맨틱 문제에 대한 경고나 오류를 발생시킵니다. 시맨틱 분석에는 타입 추론이 포함되며, 성공하면 결과 타입 체크된 AST에서 코드를 생성해도 안전함을 나타냅니다.

- **Clang 임포터(Clang importer)**: Clang 임포터([lib/ClangImporter](https://github.com/swiftlang/swift/tree/main/lib/ClangImporter)에 구현)는 [Clang 모듈](http://clang.llvm.org/docs/Modules.html)을 가져오고, C 또는 Objective-C API를 해당하는 Swift API로 매핑합니다. 결과 임포트된 AST는 시맨틱 분석에서 참조할 수 있습니다.

- **SIL 생성(SIL generation)**: Swift Intermediate Language(SIL)는 Swift 코드의 추가 분석과 최적화에 적합한 고수준 Swift 전용 중간 언어입니다. SIL 생성 단계([lib/SILGen](https://github.com/swiftlang/swift/tree/main/lib/SILGen)에 구현)는 타입 체크된 AST를 소위 "원시(raw)" SIL로 내립니다. SIL 설계는 [docs/SIL/SIL.md](https://github.com/swiftlang/swift/blob/main/docs/SIL/SIL.md)에 설명되어 있습니다.

- **SIL 보장 변환(SIL guaranteed transformations)**: SIL 보장 변환([lib/SILOptimizer/Mandatory](https://github.com/swiftlang/swift/tree/main/lib/SILOptimizer/Mandatory)에 구현)은 프로그램의 정확성에 영향을 미치는 추가 데이터 흐름 진단(예: 초기화되지 않은 변수 사용)을 수행합니다. 이 변환의 최종 결과는 "정규(canonical)" SIL입니다.

- **SIL 최적화(SIL optimizations)**: SIL 최적화([lib/SILOptimizer/Analysis](https://github.com/swiftlang/swift/tree/main/lib/SILOptimizer/Analysis), [lib/SILOptimizer/ARC](https://github.com/swiftlang/swift/tree/main/lib/SILOptimizer/ARC), [lib/SILOptimizer/LoopTransforms](https://github.com/swiftlang/swift/tree/main/lib/SILOptimizer/LoopTransforms), [lib/SILOptimizer/Transforms](https://github.com/swiftlang/swift/tree/main/lib/SILOptimizer/Transforms)에 구현)는 프로그램에 대해 자동 참조 카운팅 최적화, 디가상화(devirtualization), 제네릭 특수화 등 추가적인 고수준 Swift 전용 최적화를 수행합니다.

- **LLVM IR 생성(LLVM IR generation)**: IR 생성([lib/IRGen](https://github.com/swiftlang/swift/tree/main/lib/IRGen)에 구현)은 SIL을 [LLVM IR](http://llvm.org/docs/LangRef.html)로 내리며, 이 시점에서 [LLVM](http://llvm.org)이 계속 최적화하고 머신 코드를 생성할 수 있습니다.
