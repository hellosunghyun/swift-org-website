## Xcode Playground 지원

Swift 개발자는 다양한 방법으로 언어에 접근할 수 있습니다. 기존의 커맨드라인 컴파일러와 대화형 REPL 외에도, 많은 개발자가 가장 먼저 경험한 것 중 하나는 Xcode의 Playground 도입이었습니다. Swift 3.0과 Xcode 8 이전에는 Xcode에 포함된 Swift 버전에서만 가능했습니다. Xcode Playground Support 프로젝트를 통해 Xcode 8 Playground 경험과 통합하는 데 필요한 모든 것이 포함된 Swift 툴체인을 빌드할 수 있습니다. Playground Support는 해당 스냅샷에 포함됩니다. 스냅샷을 다운로드하여 설치하고 툴체인을 선택하면, Xcode Playground에서 최신 Swift 기능으로 작업할 수 있습니다.

이 프로젝트는 두 개의 프레임워크를 빌드합니다:

- **PlaygroundSupport.** 이 프레임워크는 Playground 코드가 Xcode와 통신하기 위해 명시적으로 참조할 수 있는 API를 정의합니다. 예를 들어, 애니메이션이나 상호 작용을 위해 라이브로 표시할 특정 뷰를 지정하는 Playground나, 정의된 기준이 충족되면 자동으로 페이지 간 이동하는 Playground에서 주로 사용됩니다.

- **PlaygroundLogger.** 이 프로젝트는 줄별로 관심 있는 값을 기록하고 Xcode에 전달하는 데 암묵적으로 사용됩니다. Playground 코드에 호출이 자동으로 삽입되므로 명시적인 참조가 필요하지 않습니다.
