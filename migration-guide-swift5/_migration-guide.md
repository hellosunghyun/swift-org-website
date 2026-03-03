Xcode 10.2에는 프로젝트를 Swift 5로 마이그레이션하는 데 도움이 되는 Swift Migrator 도구가 포함되어 있습니다.

> 이전 릴리스의 마이그레이션 가이드는 [Swift 4.2로 마이그레이션하기](/migration-guide-swift4.2)를 참고하세요.

## 마이그레이션 사전 준비

마이그레이션하려는 프로젝트가 Swift 4 또는 Swift 4.2 모드에서 성공적으로 빌드되고, 모든 테스트가 통과하는지 확인하세요. 컴파일러 변경으로 인해 처음에 오류를 해결해야 할 수도 있습니다.

프로젝트를 소스 컨트롤로 관리하는 것을 적극 권장합니다. 이렇게 하면 마이그레이션 어시스턴트를 통해 적용된 변경 사항을 쉽게 검토하고, 필요한 경우 변경을 취소하고 마이그레이션을 다시 시도할 수 있습니다.

프로젝트에 적합한 시점에 타겟별로 마이그레이션 여부와 시기를 결정할 수 있습니다. Swift 5로의 마이그레이션을 적극 권장하지만, Swift 4, 4.2, 5 타겟이 공존하고 함께 링크될 수 있으므로 전부 한꺼번에 해야 하는 것은 아닙니다.

마이그레이션 어시스턴트는 선택한 스킴을 사용하여 *migrator 빌드*를 수행하고 변경 사항을 수집하므로, 처리되는 타겟은 스킴에 포함된 타겟입니다. 스킴에 포함된 항목을 검토하고 수정하려면 _Edit Scheme..._ 시트를 열고 왼쪽 열에서 _Build_ 탭을 선택한 다음, 모든 타겟과 단위 테스트가 포함되어 있는지 확인하세요.

> 프로젝트가 Carthage나 CocoaPods에서 제공하는 다른 오픈 소스 프로젝트에 의존하는 경우, [Carthage/CocoaPods 프로젝트 사용](#using-carthagecocoapods-projects) 섹션을 참고하세요.

## Swift 마이그레이션 어시스턴트

Xcode 10.2로 프로젝트를 처음 열면 Issue Navigator에 마이그레이션 기회 항목이 표시됩니다. 이를 클릭하면 마이그레이션 여부를 묻는 시트가 활성화됩니다. 나중에 알림을 받거나 메뉴 *Edit -> Convert -> To Current Swift Syntax...*에서 Migrator를 수동으로 실행할 수 있습니다.

마이그레이션할 타겟 목록이 표시됩니다. Swift 코드가 포함되지 않은 타겟은 선택되지 않습니다.

*Next*를 클릭하면 _Generate Preview_ 시트가 나타나고, 어시스턴트가 *migration 빌드*를 시작하여 소스 변경 사항을 수집합니다. 완료되면 'Save'를 클릭했을 때 적용될 모든 변경 사항이 표시됩니다. 이때 마이그레이션된 타겟의 _Swift Language Version_ 빌드 설정도 *Swift 5*로 변경됩니다.

타겟 처리 중 마이그레이션 프로세스에 부정적인 영향을 미치는 문제가 있었을 수 있습니다. *Report Navigator*로 전환하고 추가된 _Convert_ 항목을 선택하세요. 이것이 변환 빌드 로그입니다. 나타난 오류가 있는지 로그를 확인하세요.

타겟의 코드 서명을 할 수 없다는 오류가 보이면, 타겟의 빌드 설정에서 코드 서명을 비활성화해 보세요. 다른 오류가 보이면 [버그 리포트](https://bugreport.apple.com)를 제출하고 세부 사항을 포함해 주세요. 가능하면 잘못된 마이그레이션을 보여주는 프로젝트를 첨부하는 것을 적극 권장합니다.

## Swift 5 마이그레이션 변경 사항 개요

Swift 5는 4.2 버전으로 컴파일된 코드에 미치는 영향이 최소한입니다. 자체 코드에서 다음과 같은 사항을 만날 수 있습니다:

### 컴파일러

- `@autoclosure` 매개변수에서 비롯된 인수 함수를 자체적으로 `@autoclosure`로 표시된 함수 매개변수에 올바르게 전달하기 위해 `()`를 추가하라는(호출 형성) fix-it과 함께 컴파일러 오류 `add () to forward @autoclosure parameter`가 발생합니다. 이 변경은 [SR-5719](https://bugs.swift.org/browse/SR-5719) 해결의 결과입니다.
  - Migrator가 이 fix-it을 자동으로 적용합니다.
- [SE-0230 Flatten nested optional](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0230-flatten-optional-try.md)로 인한 타입 null 허용 불일치 오류
  - Migrator는 Swift 4.2 버전에서의 타입을 보존하기 위해 `try?` 표현식을 래핑하고 캐스트를 추가하는 로컬 변경을 수행하여 코드가 계속 컴파일되도록 합니다. 그러나 이 변경은 이상적이지 않으며, Swift 4.2에서 `try?`로 생성되는 중첩 옵셔널 처리의 필요성을 제거하려는 제안의 취지에 어긋납니다. 캐스트를 제거하고 나중에 함수 본문이나 필요한 경우 함수 시그니처 자체에서 필요한 수동 변경을 하는 것을 권장합니다. 이러한 변경은 Migrator가 자동으로 수행하기에는 너무 침투적입니다.
- [SE-0192](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0192-non-exhaustive-enums.md)로 인한 컴파일러 경고 `switch must be exhaustive`
  - Swift 5 모드에서 Objective-C에서 선언되었거나 시스템 프레임워크에서 제공되는 열거형에 대한 switch 문은 "알 수 없는 케이스", 즉 향후 추가될 수 있거나 Objective-C 구현 파일에서 "비공개"로 정의된 케이스를 처리해야 합니다. (공식적으로 Objective-C는 기본 타입에 맞는 한 열거형에 어떤 값이든 저장할 수 있습니다.) 이러한 "알 수 없는 케이스"는 새로운 `@unknown` default 케이스를 사용하여 처리할 수 있으며, 이는 알려진 케이스가 switch에서 누락된 경우에도 여전히 경고를 제공합니다. 일반 default로도 처리할 수 있습니다.
  - Objective-C에서 자체 열거형을 정의했고 클라이언트가 알 수 없는 케이스를 처리할 필요가 없다면, `NS_ENUM` 대신 `NS_CLOSED_ENUM` 매크로를 사용할 수 있습니다. Swift 컴파일러가 이를 인식하고 switch에 default 케이스를 요구하지 않습니다.
  - Swift 4 및 4.2 모드에서도 `@unknown` default를 사용할 수 있습니다. 이를 생략하고 알 수 없는 값이 switch에 전달되면, 프로그램은 런타임에 트랩합니다(Xcode 10.1과 동일한 동작).

### Swift 표준 라이브러리

- 컴파일러 경고 `'index(of:)' is deprecated: renamed to 'firstIndex(of:)'` 및 `'index(where:)' is deprecated: renamed to 'firstIndex(where:)`
  - Migrator가 필요한 변경을 수행합니다.

### SDK

4.2와 5 모드 간 SDK의 소스 호환성 변경은 최소한이며, API의 정확성을 개선하기 위해 필요했습니다.

- AppKit의 일부 API가 `NSBindingSelectionMarker` 대신 `Any` 또는 `AnyObject`를 반환하도록 타입이 변경되었습니다.
- AVFoundation, CloudKit, GameKit에서 일부 프로퍼티의 반환 타입이 nullable로 변경되었습니다.
  - Migrator는 Swift 4.2 버전에서의 기존 동작을 보존하고 코드가 계속 컴파일되도록 해당 프로퍼티 참조에 `!`를 추가합니다.

### Swift 4에서 마이그레이션하는 경우

Swift 4 코드에서 마이그레이션하는 경우, 작년 Migrator의 마이그레이션 변경 사항 개요인 [Swift 4.2로 마이그레이션하기](/migration-guide-swift4.2/#swift-42-migration-changes-overview)도 참고하세요.

## 마이그레이션 후

Migrator가 많은 기계적 변경을 처리해 주지만, Migrator 변경 사항을 적용한 후 프로젝트를 빌드하기 위해 추가적인 수동 변경이 필요할 수 있습니다.

코드가 정상적으로 컴파일되더라도, Migrator가 제공한 코드가 이상적이지 않을 수 있습니다. 자체 판단을 사용하고 변경 사항이 프로젝트에 적합한지 확인하세요.

## Carthage/CocoaPods 프로젝트 사용

Swift Package Manager, Carthage 또는 CocoaPods과 같은 패키지 관리자를 사용하는 외부 의존성이 있는 프로젝트를 마이그레이션할 때 고려해야 할 몇 가지 중요한 사항이 있습니다.

- 다른 Xcode 버전에서 생성된 모듈은 서로 호환되지 않으므로, 바이너리 Swift 모듈보다 소스 의존성을 사용하는 것이 권장됩니다. 또는 Xcode 10.2로 빌드된 배포판을 확보하세요.
- 소스 의존성이 자체 타겟과 마찬가지로 Swift 4/4.2 모드에서 성공적으로 빌드되는지 확인하세요.
- Carthage의 빌드 폴더 내 바이너리 Swift 모듈을 찾기 위한 프레임워크 검색 경로를 설정한 경우, 검색 경로를 제거하거나 빌드 폴더를 정리하여 Xcode 워크스페이스에서 빌드된 Swift 모듈만 사용하고 있는지 확인하세요.
- 소스 의존성이 Swift 4/4.2 모드에서 빌드할 수 있는 한 마이그레이션할 필요는 없습니다.

## 기타

- 프로젝트에 다른 타겟을 포함하는 여러 스킴이 있는 경우, 그 중 하나만 마이그레이션해야 한다는 알림을 받게 됩니다. 새 스킴을 수동으로 선택한 다음 *Edit -> Convert -> To Current Swift Syntax*를 실행하여 나머지 스킴을 마이그레이션해야 합니다. 또는 프로젝트의 모든 타겟을 포함하는 스킴을 만들고, 마이그레이션 어시스턴트를 실행하기 전에 선택해 두면 됩니다.
