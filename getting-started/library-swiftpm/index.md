---
layout: page
title: 라이브러리 만들기
---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/apple/swift-getting-started-package-library)에서 확인할 수 있습니다.

{% include getting-started/_installing.md %}

## 프로젝트 생성

새로 구성한 Swift 개발 환경으로 간단한 라이브러리를 만들어 보겠습니다.
먼저 SwiftPM을 사용해 새 프로젝트를 생성합니다. 터미널에서 다음 명령을 실행하세요:

```bash
$ mkdir MyLibrary
$ cd MyLibrary
$ swift package init --name MyLibrary --type library
```

이 명령은 다음과 같은 파일 구조의 _MyLibrary_ 디렉터리를 생성합니다:

```no-highlight
.
├── Package.swift
├── Sources
│   └── MyLibrary
│       └── MyLibrary.swift
└── Tests
    └── MyLibraryTests
        └── MyLibraryTests.swift
```

`Package.swift`는 Swift의 매니페스트 파일입니다. 프로젝트의 메타데이터와 의존성 정보를 관리하는 곳입니다.

`Sources/MyLibrary/MyLibrary.swift`는 라이브러리의 초기 소스 파일이자, 라이브러리 코드를 작성할 곳입니다.
`Test/MyLibraryTests/MyLibraryTests.swift`는 라이브러리의 테스트를 작성할 수 있는 곳입니다.

SwiftPM이 "Hello, world!" 프로젝트를 유닛 테스트까지 포함하여 자동으로 생성해 줍니다!
터미널에서 `swift test`를 실행하면 테스트를 바로 실행할 수 있습니다.

```no-highlight
$ swift test
Building for debugging...
[5/5] Linking MyLibraryPackageTests
Build complete! (7.91s)
Test Suite 'All tests' started at 2025-08-01 14:02:39.232.
Test Suite 'All tests' passed at 2025-08-01 14:02:39.233.
   Executed 0 tests, with 0 failures (0 unexpected) in 0.000 (0.001) seconds
◇ Test run started.
↳ Testing Library Version: 6.1 (43b6f88e2f2712e)
↳ Target Platform: arm64-apple-macosx
◇ Test example() started.
✔ Test example() passed after 0.001 seconds.
✔ Test run with 1 test passed after 0.001 seconds.
```

## 간단한 라이브러리

이제 간단한 라이브러리를 작성해 보겠습니다.
`MyLibrary.swift`의 예시 코드를 다음 코드로 교체하세요:

```swift
import Foundation

struct Email: CustomStringConvertible {
  var description: String

  public init(_ emailString: String) throws {
    let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
    guard let _ = emailString.range(of: regex, options: .regularExpression) else {
      throw InvalidEmailError(email: emailString)
    }
    self.description = emailString
  }
}

private struct InvalidEmailError: Error {
  let email: String
}
```

이제 이 강타입 Email API에 대한 유닛 테스트를 추가하겠습니다.
`MyLibraryTests.swift`의 예시 코드를 다음 코드로 교체하세요:

```swift
import Testing
@testable import MyLibrary

struct MyLibraryTests {
  @Test func email() throws {
    let email = try Email("john.appleseed@apple.com")
    #expect(email.description == "john.appleseed@apple.com")

    #expect(throws: (any Error).self) {
      try Email("invalid")
    }
  }
}
```

저장한 후 테스트를 다시 실행합니다:

```no-highlight
$ swift test
Building for debugging...
[5/5] Linking MyLibraryPackageTests
Build complete! (3.09s)
Test Suite 'All tests' started at 2025-08-01 14:24:32.687.
Test Suite 'All tests' passed at 2025-08-01 14:24:32.689.
   Executed 0 tests, with 0 failures (0 unexpected) in 0.000 (0.001) seconds
◇ Test run started.
↳ Testing Library Version: 6.1 (43b6f88e2f2712e)
↳ Target Platform: arm64-apple-macosx
◇ Suite MyLibraryTests started.
◇ Test email() started.
✔ Test email() passed after 0.001 seconds.
✔ Suite MyLibraryTests passed after 0.001 seconds.
✔ Test run with 1 test passed after 0.001 seconds.
```

---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/apple/swift-getting-started-package-library)에서 확인할 수 있습니다.
