## 플랫폼 지원

Swift를 오픈으로 개발하면서 가장 흥미로운 점 중 하나는 이제 다양한 플랫폼, 기기, 사용 사례에 자유롭게 이식할 수 있다는 것입니다.

우리의 목표는 실제 구현 메커니즘이 플랫폼마다 다를 수 있더라도, 모든 플랫폼에서 Swift의 소스 호환성을 제공하는 것입니다. 가장 대표적인 예로, Apple 플랫폼은 UIKit이나 AppKit 같은 Apple 플랫폼 프레임워크에 접근하는 데 필요한 Objective-C 런타임을 포함합니다. Linux 같은 다른 플랫폼에서는 Objective-C 런타임이 필요하지 않으므로 포함되어 있지 않습니다.

[Swift 코어 라이브러리 프로젝트](/documentation/core-libraries/)는
Objective-C 런타임에 의존하지 않는 Foundation 같은
기본 Apple 프레임워크의 이식 가능한 구현을 제공하여
Swift의 크로스 플랫폼 역량을 확장하는 것을 목표로 합니다.
코어 라이브러리는 아직 초기 개발 단계에 있지만,
궁극적으로는 모든 플랫폼에서 Swift 코드의 소스 호환성을
향상시킬 것입니다.

### Apple 플랫폼

오픈소스 Swift는 Mac에서 iOS, macOS, watchOS, tvOS 등
모든 Apple 플랫폼을 대상으로 사용할 수 있습니다. 또한 오픈소스
Swift의 바이너리 빌드는 Xcode 빌드 시스템의 완전한 지원,
에디터의 코드 자동 완성, 통합 디버깅을 포함하여
Xcode 개발자 도구와 통합되므로, 누구나 익숙한 Cocoa 및 Cocoa Touch
개발 환경에서 최신 Swift 개발 사항을 실험해 볼 수 있습니다.

### Linux

오픈소스 Swift는 Linux에서 Swift 라이브러리와
애플리케이션을 빌드하는 데 사용할 수 있습니다. 오픈소스 바이너리 빌드에는 Swift 컴파일러와 표준 라이브러리, Swift REPL과 디버거(LLDB), [코어 라이브러리](/documentation/core-libraries/)가 포함되어 있어 바로 Swift 개발을 시작할 수 있습니다.

### Windows

오픈소스 Swift는 Windows에서 Swift 라이브러리와 애플리케이션을 빌드하는 데 사용할 수 있습니다. 오픈소스 바이너리 빌드에는 C/C++/Swift 툴체인, 표준 라이브러리, 디버거(LLDB), [코어 라이브러리](/documentation/core-libraries/)가 포함되어 있어 바로 Swift 개발을 시작할 수 있습니다. SourceKit-LSP가 릴리스에 포함되어 있어 개발자가 원하는 IDE에서 빠르게 생산성을 높일 수 있습니다.

### 새로운 플랫폼

Swift를 새로운 곳에 함께 가져갈 날이 기대됩니다. 우리가 사랑하는 이 언어가 소프트웨어를 더 안전하고, 더 빠르고, 더 유지보수하기 쉽게 만들 수 있다고 진심으로 믿습니다. Swift를 더 많은 컴퓨팅 플랫폼에 가져가는 데 여러분의 도움을 기다립니다.
