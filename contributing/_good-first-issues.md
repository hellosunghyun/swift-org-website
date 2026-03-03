## Good First Issue

Good first issue는 Swift 프로젝트에 처음 기여하는 사람, 심지어 Swift 컴파일러와 같은 서브프로젝트의 패턴과 개념에 익숙하지 않은 사람도 접근할 수 있도록 설계된 버그, 아이디어, 작업입니다.
Good first issue는 해당 라벨로 표시되며, `github.com/apple/<repository>/contribute`에 방문하면 가장 쉽게 찾을 수 있습니다. 예를 들어 Swift 메인 저장소의 경우
[github.com/apple/swiftlang/contribute](https://github.com/swiftlang/swift/contribute)를 확인하세요.
이러한 이슈는 우선순위가 낮고 범위가 적당하며, 과도한 리팩토링, 연구, 디버깅이 필요하지 않도록 설계되어 있습니다. 오히려 새로운 기여자가 Swift의 특정 부분에 참여하고, 더 많이 배우며, 실질적인 기여를 할 수 있도록 장려하는 것이 목적입니다.

[커밋 권한](#code-merger)이 있고 특정 영역에 대한 지식이 있는 사람이라면 누구나 good first issue를 구체화하거나 새로 만드는 것을 환영하고 권장합니다.

{% comment %}
// TODO: This is content I'd like to migrate into Jira behind a "starter" label of some sort. For now:

- Swift Intermediate Language (SIL) round-tripping: make sure that the SIL parser can parse what the SIL printer prints. This is a great project for getting a feel for SIL and how it's used, and making it round-trippable has huge benefits for anyone working on the Swift compiler.
- Warning control: [Clang](http://clang.llvm.org) has a great scheme for placing warnings into specific warning groups, allowing one to control (from the command line) which warnings are emitted by the compiler or are treated as errors. Swift needs that!
  {% endcomment %}
