---
layout: page
title: Vapor로 웹 서비스 만들기
---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/vapor/swift-getting-started-web-server)에서 확인할 수 있습니다.

{% include getting-started/_installing.md %}

## 웹 프레임워크 선택

지난 몇 년간 Swift 커뮤니티는 웹 서비스 구축을 돕기 위한 여러 웹 프레임워크를 만들어 왔습니다.
이 가이드에서는 커뮤니티에서 인기 있는 웹 프레임워크인 [Vapor](https://vapor.codes)를 다룹니다.

## Vapor 설치

먼저 Vapor 도구 모음(toolbox)을 설치해야 합니다.
macOS에 Homebrew가 이미 설치되어 있다면 다음을 실행하세요:

```bash
brew install vapor
```

다른 운영체제를 사용하거나 소스에서 직접 설치하려면 [Vapor 문서](https://docs.vapor.codes/install/linux/#install-toolbox)를 참고하세요.

## 프로젝트 생성

터미널에서 새 프로젝트를 생성할 디렉터리로 이동한 다음 실행합니다:

```bash
vapor new HelloVapor
```

이 명령은 템플릿을 다운로드하고 몇 가지 질문을 통해 시작에 필요한 모든 것이 갖춰진 간단한 프로젝트를 생성합니다. 이 가이드에서는 JSON을 주고받을 수 있는 간단한 REST API를 만들 것이므로, 나머지 질문에는 모두 no로 답하세요. 프로젝트가 성공적으로 생성된 것을 확인할 수 있습니다:

![A New Vapor Project]({{site.url}}/assets/images/getting-started-guides/vapor-web-server/new-project.png)

생성된 디렉터리로 이동하고 원하는 IDE로 프로젝트를 열어 보세요. 예를 들어 VSCode를 사용하려면:

```bash
cd HelloVapor
code .
```

Xcode를 사용하려면:

```bash
cd HelloVapor
open Package.swift
```

Vapor의 템플릿에는 여러 파일과 함수가 이미 구성되어 있습니다. **configure.swift**에는 애플리케이션 설정 코드가, **routes.swift**에는 라우트 핸들러 코드가 들어 있습니다.

## 라우트 만들기

먼저 **routes.swift**를 열고, 사이트에 접속하는 사람에게 인사하는 새 라우트를 만들어 봅시다. `app.get("hello") { ... }` 아래에 새 라우트를 선언하세요:

```swift
// 1
app.get("hello", ":name") { req async throws -> String in
    // 2
    let name = try req.parameters.require("name")
    // 3
    return "Hello, \(name.capitalized)!"
}
```

코드를 하나씩 살펴보겠습니다:

1. `/hello/<NAME>`에 대한 **GET** 요청으로 등록되는 새 라우트 핸들러를 선언합니다. `:`은 Vapor에서 동적 경로 파라미터를 나타내며, 어떤 값이든 매칭되어 라우트 핸들러에서 가져올 수 있습니다. `app.get(...)`은 마지막 파라미터로 클로저를 받으며, 비동기일 수 있고 `Response`나 `String` 같은 `ResponseEncodable`을 준수하는 타입을 반환해야 합니다.
2. 파라미터에서 이름을 가져옵니다. 기본적으로 `String`을 반환합니다. `Int`나 `UUID` 같은 다른 타입을 추출하려면 `req.parameters.require("id", as: UUID.self)`처럼 작성하면 Vapor가 해당 타입으로 캐스팅을 시도하고, 불가능하면 자동으로 오류를 던집니다. 라우트가 올바른 파라미터 이름으로 등록되지 않은 경우에도 오류를 던집니다.
3. `Response`를 반환합니다. 이 경우에는 `String`입니다. 상태 코드, 응답 본문, 헤더를 직접 설정할 필요가 없습니다. Vapor가 이 모든 것을 자동으로 처리하며, 필요하면 반환되는 `Response`를 직접 제어할 수도 있습니다.

파일을 저장하고 앱을 빌드한 후 실행합니다:

```bash
$ swift run
Building for debugging...
...
Build complete! (59.87s)
[ NOTICE ] Server starting on http://127.0.0.1:8080
```

`http://localhost:8080/hello/tim`으로 **GET** 요청을 보내 보세요. 다음과 같은 응답을 받게 됩니다:

```bash
$ curl http://localhost:8080/hello/tim
Hello, Tim!
```

다른 이름으로도 시도해 보면 자동으로 바뀌는 것을 확인할 수 있습니다!

## JSON 반환

Vapor는 내부적으로 [`Codable`](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)을 사용하며, `Content`라는 래퍼 프로토콜로 몇 가지 기능을 더해 JSON을 쉽게 주고받을 수 있도록 합니다. 다음으로 Hello! 라우트의 메시지를 JSON 본문으로 반환해 보겠습니다. 먼저 **routes.swift** 하단에 새 타입을 만드세요:

```swift
struct UserResponse: Content {
    let message: String
}
```

반환할 JSON 형태와 일치하는 `Content`를 준수하는 새 타입입니다.

`app.get("hello", ":name") { ... }` 아래에 이 JSON을 반환하는 새 라우트를 만듭니다:

```swift
// 1
app.get("json", ":name") { req async throws -> UserResponse in
    // 2
    let name = try req.parameters.require("name")
    let message = "Hello, \(name.capitalized)!"
    // 3
    return UserResponse(message: message)
}
```

코드를 살펴보겠습니다:

1. `/json`에 대한 **GET** 요청을 처리하는 새 라우트 핸들러를 정의합니다. 중요한 점은 클로저의 반환 타입이 `UserResponse`라는 것입니다.
2. 이전과 같이 이름을 가져오고 메시지를 구성합니다.
3. `UserResponse`를 반환합니다.

저장하고 앱을 다시 빌드하여 실행한 후 `http://localhost:8080/json/tim`으로 GET 요청을 보냅니다:

```bash
$ curl http://localhost:8080/json/tim
{"message":"Hello, Tim!"}
```

이번에는 JSON으로 응답을 받습니다!

## JSON 처리

마지막으로 JSON을 수신하는 방법을 다루겠습니다. **routes.swift** 하단에 서버 앱으로 전송할 JSON을 모델링하는 새 타입을 만드세요:

```swift
struct UserInfo: Content {
    let name: String
    let age: Int
}
```

이름과 나이, 두 개의 프로퍼티를 포함합니다. 그런 다음 JSON 라우트 아래에 이 본문을 가진 POST 요청을 처리하는 새 라우트를 만듭니다:

```swift
// 1
app.post("user-info") { req async throws -> UserResponse in
    // 2
    let userInfo = try req.content.decode(UserInfo.self)
    // 3
    let message = "Hello, \(userInfo.name.capitalized)! You are \(userInfo.age) years old."
    return UserResponse(message: message)
}
```

이 새 라우트 핸들러의 중요한 차이점은:

1. 이 라우트 핸들러가 **POST** 요청이므로 `app.get(...)` 대신 `app.post(...)`를 사용합니다.
2. 요청 본문에서 JSON을 디코딩합니다.
3. JSON 본문의 데이터를 사용하여 새 메시지를 만듭니다.

유효한 JSON 본문과 함께 POST 요청을 보내고 응답을 확인해 보세요:

```bash
$ curl http://localhost:8080/user-info -X POST -d '{"name": "Tim", "age": 99}' -H "Content-Type: application/json"
{"message":"Hello, Tim! You are 99 years old."}
```

축하합니다! Swift로 첫 번째 웹 서버를 만들었습니다!

> 이 가이드의 소스 코드는 [GitHub](https://github.com/vapor/swift-getting-started-web-server)에서 확인할 수 있습니다.
