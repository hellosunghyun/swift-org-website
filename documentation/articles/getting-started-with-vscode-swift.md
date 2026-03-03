---
layout: page
date: 2024-05-28 12:00:00
title: Swift 개발을 위한 VS Code 설정
author: [matthewbastien, plemarquand]
---

[Visual Studio Code](https://code.visualstudio.com/)(VS Code)는 확장을 통해 다양한 프로그래밍 언어를 지원하는 범용 에디터입니다. Swift 확장은 에디터에 Swift 언어 전용 기능을 추가하여 모든 플랫폼에서 Swift 애플리케이션을 원활하게 개발할 수 있는 환경을 제공합니다.

Swift 확장에 포함된 기능:

- 구문 강조 및 코드 완성
- 정의로 이동, 모든 참조 찾기 등의 코드 탐색 기능
- 리팩토링 및 빠른 수정
- Swift Package Manager를 활용한 패키지 관리 및 작업
- 풍부한 디버깅 지원
- XCTest 또는 Swift Testing 프레임워크를 사용한 테스트

Swift 확장이 지원하는 프로젝트 유형:

- Swift Package Manager 프로젝트 (예: `Package.swift` 사용)
- `compile_commands.json`을 생성할 수 있는 프로젝트 (예: CMake 사용)

## 확장 설치

1. 먼저 Swift를 설치합니다. 시스템에 Swift가 아직 설치되어 있지 않다면 [Swift.org 시작하기 가이드](/getting-started/)를 참고하세요.
2. [Visual Studio Code](https://code.visualstudio.com/Download)를 다운로드하고 설치합니다.
3. [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=swiftlang.swift-vscode)에서 Swift 확장을 설치하거나 VS Code 확장 패널에서 직접 설치합니다.

![확장 패널에서 vscode-swift 확장 설치하기](/assets/images/getting-started-with-vscode-swift/installation.png)

## 새 Swift 프로젝트 만들기

새 Swift 프로젝트를 만들려면 Swift 확장의 `Swift: Create New Project...` 명령을 사용하세요. 커맨드 팔레트를 열고 아래 안내를 따릅니다.

- macOS: `CMD + Shift + P`
- 다른 플랫폼: `Ctrl + Shift + P`

1. 커맨드 팔레트에서 `Swift: Create New Project...` 명령을 검색합니다.
2. 템플릿 목록에서 만들고 싶은 프로젝트 유형을 선택합니다.

![사용 가능한 프로젝트 템플릿을 보여주는 새 프로젝트 만들기 명령](/assets/images/getting-started-with-vscode-swift/create-new-project/select-project-template.png)

3. 프로젝트를 저장할 디렉토리를 선택합니다.
4. 프로젝트 이름을 지정합니다.
5. 새로 만든 프로젝트를 엽니다. 현재 창, 새 창, 또는 현재 워크스페이스에 추가할지 선택하라는 안내가 표시됩니다.
   기본 동작은 `swift.openAfterCreateNewProject` 설정으로 변경할 수 있습니다.

## 언어 기능

Swift 확장은 [SourceKit-LSP](https://github.com/swiftlang/sourcekit-lsp)를 사용하여 언어 기능을 구동합니다. SourceKit-LSP는 에디터에서 다음 기능을 제공합니다. 각 항목의 VS Code 문서를 보려면 링크를 클릭하세요:

- [코드 완성](https://code.visualstudio.com/docs/editor/intellisense)
- [정의로 이동](https://code.visualstudio.com/docs/editor/editingevolved#_go-to-definition)
- [모든 참조 찾기](https://code.visualstudio.com/Docs/editor/editingevolved#_peek)
- [이름 변경 리팩토링](https://code.visualstudio.com/docs/editor/refactoring#_rename-symbol)
- [진단](https://code.visualstudio.com/docs/editor/editingevolved#_errors-warnings)
- [빠른 수정](https://code.visualstudio.com/docs/editor/editingevolved#_code-action)

SourceKit-LSP는 일반적인 작업을 자동화하는 코드 액션도 제공합니다. VS Code에서 코드 액션은 에디터 여백 근처에 전구 아이콘으로 표시됩니다(아래 스크린샷 참고). 전구를 클릭하면 사용 가능한 액션이 표시되며, 여기에는 다음이 포함됩니다:

- `Package.swift`에 타겟 추가
- JSON을 프로토콜로 변환
- 함수에 문서 추가

![Package.swift 액션](/assets/images/getting-started-with-vscode-swift/language-features/package_actions.png)

<div class="warning" markdown="1">
Swift 6.1 이전 버전에서는 언어 기능을 사용하기 전에 커맨드 라인이나 VS Code 작업을 통해 프로젝트에서 `swift build` 명령을 실행해야 합니다. 이를 통해 SourceKit-LSP의 인덱스가 구성됩니다.
</div>

## Swift 작업

Visual Studio Code는 외부 도구를 실행하는 방법으로 작업을 제공합니다. 자세한 내용은 [외부 도구와의 통합](https://code.visualstudio.com/docs/editor/tasks) 문서를 참고하세요.

Swift 확장은 Swift Package Manager를 통해 프로젝트를 빌드할 수 있는 기본 작업을 제공합니다. 프로젝트 루트 폴더에 `tasks.json` 파일을 만들어 사용자 정의 작업을 구성할 수도 있습니다. 예를 들어, 다음 `tasks.json`은 모든 Swift 타겟을 릴리스 모드로 빌드합니다:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "swift",
      "label": "Swift Build All - Release",
      "detail": "swift build --build-tests",
      "args": ["build", "--build-tests", "-c", "release"],
      "env": {},
      "cwd": "${workspaceFolder}",
      "group": "build"
    }
  ]
}
```

위 작업은 `build` 그룹으로 설정되어 있어 macOS에서는 `CMD + Shift + B`, 다른 플랫폼에서는 `Ctrl + Shift + B`로 열 수 있는 `빌드 작업 실행` 메뉴에 표시됩니다:

![빌드 작업 실행 메뉴](/assets/images/getting-started-with-vscode-swift/tasks/build-tasks.png)

빌드 중 발생하는 오류는 SourceKit-LSP가 제공하는 진단과 함께 에디터에 표시됩니다. 다른 빌드 작업을 실행하면 이전 빌드 작업의 진단이 지워집니다.

## 디버깅

Visual Studio Code는 풍부한 디버깅 환경을 제공합니다. 자세한 내용은 [디버깅](https://code.visualstudio.com/docs/editor/debugging) 문서를 참고하세요.

Swift 확장은 [LLDB DAP 확장](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap)을 사용하여 디버깅을 지원합니다.

기본적으로 확장은 Swift 패키지의 각 실행 가능 타겟에 대한 시작 구성을 생성합니다. 프로젝트 루트 폴더에 `launch.json` 파일을 추가하여 직접 구성할 수도 있습니다. 예를 들어, 다음 `launch.json`은 사용자 정의 인수로 Swift 실행 파일을 시작합니다:

```json
{
  "configurations": [
    {
      "type": "swift",
      "name": "Debug swift-executable",
      "request": "launch",
      "args": ["--hello", "world"],
      "cwd": "${workspaceFolder}",
      "program": "${workspaceFolder}/.build/debug/swift-executable",
      "preLaunchTask": "swift: Build Debug swift-executable"
    }
  ]
}
```

VS Code의 디버그 뷰에서 디버깅 세션을 시작할 수 있습니다.

1. 디버깅할 시작 구성을 선택합니다.
2. 녹색 재생 버튼을 클릭하여 디버깅 세션을 시작합니다.

실행 파일이 시작되면 Swift 코드에 중단점을 설정하여 코드 실행 중 해당 지점에서 멈출 수 있습니다.

아래 스크린샷은 Hello World 프로그램을 디버깅하는 예시입니다. 중단점에서 일시 정지된 상태이며, 디버그 뷰에서 스코프 내 변수 값을 확인할 수 있습니다. 에디터에서 식별자 위에 마우스를 올려 변수 값을 볼 수도 있습니다:

![디버깅](/assets/images/getting-started-with-vscode-swift/debugging/debugging.png)

## 테스트 탐색기

Visual Studio Code는 왼쪽 사이드바에 테스트 탐색기 뷰를 제공하며, 다음 용도로 사용할 수 있습니다:

- 테스트로 이동
- 테스트 실행
- 테스트 디버깅

Swift 확장은 [XCTest](https://developer.apple.com/documentation/xctest)와 [Swift Testing](https://swiftpackageindex.com/swiftlang/swift-testing/main/documentation/testing)을 모두 지원합니다. 테스트를 작성하면 자동으로 테스트 탐색기에 추가됩니다.

![인라인 테스트 오류](/assets/images/getting-started-with-vscode-swift/testing/inline_assertion_failures.png)

테스트를 디버깅하려면:

1. 중단점을 설정합니다.
2. `Debug Test` 프로필로 테스트, 테스트 스위트, 또는 전체 테스트 타겟을 실행합니다.

`Run Test with Coverage` 프로필은 테스트 대상 코드를 계측하고 테스트 실행이 완료되면 코드 커버리지 보고서를 엽니다. 커버된 파일을 탐색하면 테스트 중 실행된 줄 번호는 녹색으로, 누락된 줄은 빨간색으로 표시됩니다. 줄 번호 위에 마우스를 올리면 커버된 줄이 몇 번 실행되었는지 확인할 수 있습니다. `Test: Show Inline Coverage` 명령으로 줄 실행 횟수를 표시하거나 숨길 수 있습니다.

[태그](https://swiftpackageindex.com/swiftlang/swift-testing/main/documentation/testing/addingtags)가 지정된 Swift Testing 테스트는 테스트 탐색기에서 `@TestTarget:tagName`을 사용하여 필터링할 수 있습니다. 그런 다음 필터링된 테스트 목록을 실행하거나 디버깅할 수 있습니다.

<div class="warning" markdown="1">
Swift 확장은 Swift 5.10 이전 버전에서 Swift Testing 테스트 실행을 지원하지 않습니다.
</div>

## 고급 도구체인 선택

Swift 확장은 설치된 Swift 도구체인을 자동으로 감지합니다. 하지만 여러 도구체인이 설치된 경우 `Swift: Select Toolchain...` 명령을 사용하여 선택할 수 있습니다.

<div class="warning" markdown="1">
이 기능은 기본 도구체인이 아닌 다른 도구체인으로 VS Code를 구성하는 고급 기능입니다. macOS에서는 `xcode-select`, Linux에서는 `swiftly`를 사용하여 전역적으로 도구체인을 전환하는 것을 권장합니다.
</div>

새 경로를 어디에 저장할지 선택하라는 안내가 표시될 수 있습니다. 선택 옵션:

- 사용자 설정에 저장
- 워크스페이스 설정에 저장

워크스페이스 설정이 사용자 설정보다 우선 적용됩니다:

![설정 선택](/assets/images/getting-started-with-vscode-swift/toolchain-selection/configuration.png)

그 다음 Swift 확장은 새 도구체인을 적용하기 위해 확장을 다시 로드하라는 안내를 표시합니다. 반드시 다시 로드해야 하며, 그렇지 않으면 확장이 올바르게 동작하지 않습니다:

![VS Code 다시 로드 경고](/assets/images/getting-started-with-vscode-swift/toolchain-selection/reload.png)

## 더 알아보기 및 기여

이 확장의 공식 문서는 [swift.org에서 확인](https://docs.swift.org/vscode/documentation/userdocs)할 수 있습니다.

새로운 기능을 제안하려면 Swift 포럼의 [VS Code Swift Extension 카테고리](https://forums.swift.org/c/related-projects/vscode-swift-extension/)에 게시할 수 있습니다. 예상대로 동작하지 않는 부분이 있다면 [확장의 GitHub 저장소에 이슈를 등록](https://github.com/swiftlang/vscode-swift/issues/new)해 주세요.

이 프로젝트는 코드, 테스트, 문서를 포함한 기여를 환영합니다. 기여 방법에 대한 자세한 내용은 [기여 가이드](https://github.com/swiftlang/vscode-swift/blob/HEAD/CONTRIBUTING.md)를 참고하세요.
