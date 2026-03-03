---
layout: page
title: Passkey로 비밀번호 없이 인증하기
---

이 튜토리얼에서는 Passkey를 살펴봅니다. 좀 더 구체적으로, [Swift WebAuthn 라이브러리](https://github.com/swift-server/webauthn-swift)를 서버사이드 Swift 앱에 통합하는 방법을 알아봅니다. Passkey를 사용한 등록 및 인증 과정은 꽤 간단하지만, 클라이언트와 서버 간의 여러 차례 통신이 필요합니다. 따라서 이 튜토리얼은 Passkey 등록과 Passkey 인증의 두 부분으로 나뉩니다.

처음부터 시작하지 않고 이 블로그 글이 한 권의 책이 되는 것을 피하기 위해 간단한 스타터 프로젝트를 준비했으며, [여기서 다운로드](https://github.com/brokenhandsio/swift-webauthn-guide)할 수 있습니다.

오늘은 독립적인 Passkey 로그인의 구현 예제를 보여드리겠지만, 하드웨어 기반 2FA를 위해 기존의 비밀번호 기반 로그인과 함께 webauthn-swift를 통합하는 것도 가능합니다.

Passkey란? 다른 분들이 이미 잘 설명해 놓았으니, 바퀴를 다시 발명할 필요는 없겠죠. [passkeys.com](https://passkeys.com)의 인용문입니다:

> Passkey는 웹에서 인증하기 위한 새로운 표준입니다.
> Passkey는 비밀번호의 더 안전하고 쉬운 대체제입니다. Passkey를 사용하면 생체 인식 센서(지문 또는 얼굴 인식 등), PIN 또는 패턴으로 앱과 웹사이트에 로그인할 수 있어, 비밀번호를 기억하고 관리할 필요가 없습니다.

Passkey와 작동 방식에 대해 더 알고 싶다면 다음 두 가지 리소스를 추천합니다:

- 소개: [https://webauthn.guide](https://webauthn.guide/)
- 상세 정보: [https://w3c.github.io/webauthn](https://w3c.github.io/webauthn/)
- Apple 개발자 문서: [https://developer.apple.com/passkeys](https://developer.apple.com/passkeys/)

## 기본 개념

Passkey는 브라우저에 통합되어 있으며, Passkey 프롬프트를 트리거하는 데 사용할 수 있는 JavaScript API를 노출합니다.

_Safari Passkey 프롬프트:_
![Safari 브라우저가 Passkey를 요청하는 스크린샷](/assets/images/server-guides/safari_passkey_prompt.png)

_다른 예시 - 1Password 프롬프트:_
![Safari 브라우저가 1Password 확장을 통해 Passkey를 요청하는 스크린샷](/assets/images/server-guides/1password_passkey_prompt.png)

이 두 프롬프트는 `navigator.credentials.create(...)`와 `navigator.credentials.get(...)`을 호출한 결과입니다.

더 잘 이해하기 위해 이 API를 직접 사용해 보겠습니다. 새 탭에서 [Swift.org](https://swift.org)를 열고 브라우저의 개발자 패널을 열어 JavaScript 콘솔로 전환합니다. 다음 변수를 생성합니다:

```js
const publicKeyCredentialCreationOptions = {
  challenge: Uint8Array.from('randomStringFromServer', (c) => c.charCodeAt(0)),
  rp: {
    name: 'Swift',
    id: 'swift.org',
  },
  user: {
    id: Uint8Array.from('UZSL85T9AFC', (c) => c.charCodeAt(0)),
    name: 'me@example.com',
    displayName: 'FooBar',
  },
  pubKeyCredParams: [{ alg: -7, type: 'public-key' }],
  authenticatorSelection: {
    authenticatorAttachment: 'cross-platform',
  },
  timeout: 60000,
  attestation: 'direct',
}
```

내용을 이해할 필요는 없습니다. 실제로 Swift WebAuthn 라이브러리가 이를 자동으로 생성합니다. 이제 새로 생성한 `publicKeyCredentialCreationOptions`로 Passkey API를 호출하면 새 Passkey를 생성하라는 프롬프트가 나타납니다:

```js
const credential = await navigator.credentials.create({
  publicKey: publicKeyCredentialCreationOptions,
})
```

## 1막 - 설정

### Relying Party 설정

아직 [데모 프로젝트](https://github.com/brokenhandsio/swift-webauthn-guide)를 다운로드하지 않았다면, 지금 다운로드하세요. `starter`와 `final` 프로젝트가 있습니다. starter 프로젝트를 열고 `Package.swift`에 Swift WebAuthn 라이브러리를 추가합니다:

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/swift-server/webauthn-swift.git", from: "1.0.0-alpha")
],

// ...

targets: [
    .target(
        name: "App",
        dependencies: [
            // ...
            .product(name: "WebAuthn", package: "webauthn-swift")
// ...
]
```

먼저 Swift WebAuthn 라이브러리의 핵심인 `WebAuthnManager` 인스턴스를 생성해야 합니다. WebAuthn 라이브러리는 모든 서버사이드 Swift 프레임워크에서 작동하지만, 이 튜토리얼에서는 Vapor를 사용합니다. Vapor에서는 `Request`를 확장하여 라우트 핸들러에서 쉽게 접근할 수 있는 `webAuthn` 프로퍼티를 추가할 수 있습니다. `Request+webAuthn.swift`라는 새 파일에 이를 추가합니다:

```swift
import Vapor
import WebAuthn

extension Request {
    var webAuthn: WebAuthnManager {
        WebAuthnManager(
            config: WebAuthnManager.Config(
                // 1
                relyingPartyID: "localhost",
                // 2
                relyingPartyName: "Vapor Passkey Tutorial",
                // 3
                relyingPartyOrigin: "http://localhost:8080"
            )
        )
    }
}
```

여기서 3가지를 구성합니다:

1. `relyingPartyID`는 앱이 접근 가능한 도메인만으로(스킴, 포트, 경로 제외) 앱을 식별합니다. 생성된 모든 Passkey는 이 식별자에 범위가 지정됩니다. 즉, `example.org`에서 생성된 Passkey는 동일한 도메인에서만 사용할 수 있습니다. `auth.example.org`와 같은 하위 도메인을 지정하면 `dev.auth.example.org` 등의 Passkey도 허용하지만 `login.example.org`는 허용하지 않습니다. 이는 다른 웹사이트가 임의의 Passkey와 통신하는 것을 방지합니다. 그러나 이는 도메인을 변경하려는 경우 모든 사용자가 Passkey를 다시 생성해야 한다는 것을 의미합니다!
2. `relyingPartyName`은 등록 또는 로그인 시 사용자에게 표시되는 친숙한 이름입니다.
3. `relyingPartyOrigin`은 relying party id와 비슷하게 작동하지만, [추가 보호 계층으로 사용](https://w3c.github.io/webauthn/#sctn-validating-origin)됩니다. 여기서는 전체 오리진을 지정해야 합니다. 이 경우 스킴 `https://` + relying party id + 포트 `:8080`입니다.

🚨 _일부_ WebAuthn 브라우저 구현, 비밀번호 관리자, 인증기는 "유효한" 도메인에서만 작동하므로 `127.0.0.1`이 아닌 `localhost`에서 앱을 실행하는 것이 중요합니다. Vapor에서는 `--hostname localhost`를 사용하여 이를 달성할 수 있습니다:

```bash
swift run App serve --hostname localhost
```

좋습니다, 시작하는 데 필요한 것은 이것이 전부입니다.

## 2막 - 등록

UI 관점에서 우리에게 필요한 것은 세 가지 컴포넌트뿐입니다: 두 개의 버튼과 사용자 이름을 입력하는 텍스트 필드! 비밀번호 필드는 필요 없습니다... 그것이 바로 우리가 여기 있는 이유니까요! 먼저 HTML로 간단한 등록 양식을 만들어 보겠습니다. `Resources/Views/index.leaf`에서 `<!-- Form -->` 바로 뒤에 다음 양식을 삽입합니다:

```html
<form id="registerForm">
  <input id="username" type="text" />
  <button type="submit">Register</button>
</form>
```

이제 앱이 http://localhost:8080/에서 빈 HTML 양식을 반환해야 합니다.

### 미리 계획하기

비즈니스 로직으로 넘어가기 전에 필요한 것을 적어 보겠습니다:

1. 사용자가 "Register" 버튼을 클릭하면 서버에 새 등록 시도를 알립니다.
2. 서버가 몇 가지 정보를 조합하여 클라이언트(브라우저)에 다시 보냅니다.
3. 클라이언트가 이 정보를 받아 `create(parseCreationOptionsFromJSON(...))` JavaScript 함수에 전달하면 Passkey 프롬프트가 트리거됩니다. 이 함수의 반환 값이 새로운 Passkey입니다!
4. 마지막으로 새 Passkey를 서버로 보내고, 검증한 후 데이터베이스에 저장합니다.

할 일이 많아 보이지만, 실제로는 꽤 간단합니다.

### `<form>`에 생명 불어넣기

좋습니다, 첫 번째 단계부터 시작합시다. 이전 단계에서 닫는 `</form>` 태그 뒤에 다음을 추가합니다:

```html
<script type="module">
  // import WebAuthn wrapper
  import {
    create,
    parseCreationOptionsFromJSON,
  } from 'https://cdn.jsdelivr.net/npm/@github/webauthn-json@2.1.1/dist/esm/webauthn-json.browser-ponyfill.js'

  // Get a reference to our registration form
  const registerForm = document.getElementById('registerForm')

  // Listen for the form's "submit" event
  registerForm.addEventListener('submit', async function (event) {
    event.preventDefault()

    // Get the username
    const username = document.getElementById('username').value

    // Send request to server
    const registerResponse = await fetch('/register?username=' + username)

    // Parse response as json and pass into wrapped WebAuthn API
    const registerResponseJSON = await registerResponse.json()
    const passkey = await create(
      parseCreationOptionsFromJSON(registerResponseJSON),
    )
  })
</script>
```

먼저 원래 WebAuthn API인 `navigator.credentials.create`와 `navigator.credentials.get` 위에 사용자 친화적인 래퍼를 추가하는 GitHub에서 개발한 서드파티 스크립트를 추가합니다. 이는 편의를 위한 것으로 필수는 아닙니다! 사용하지 않으려면 원래 API가 몇 가지 "원시" 바이트 배열을 기대하므로 `registrationOptions`의 일부 속성을 역직렬화해야 합니다. 래퍼를 사용하면 서버의 JSON 응답을 간단히 전달할 수 있습니다 — 깔끔하죠! 공식 WebAuthn API가 [언젠가 이를 기본 지원](https://w3c.github.io/webauthn/#sctn-parseCreationOptionsFromJSON)하겠지만, 현재는 GitHub의 "webauthn-json" 라이브러리에 의존합니다.

스크립트는 양식의 `submit` 이벤트를 수신 대기합니다. 제출 시 백엔드에 `/register` 요청을 보내고 JSON 응답을 `create(parseCreationOptionsFromJSON(...))`에 전달하여 브라우저의 Passkey 프롬프트를 트리거합니다.

사용자가 프롬프트에 성공적으로 응답하면 `const passkey`에 새 Passkey가 들어옵니다. 나중에 이 Passkey를 서버로 보내 검증합니다. 서버 측에서는 JavaScript 코드에서 호출한 엔드포인트를 아직 추가해야 합니다. Vapor 앱에서는 `routes.swift`에 새 라우트를 등록해야 합니다:

```swift
app.get("register") { req in
    // Create and login user
    let username = try req.query.get(String.self, at: "username")
    let user = User(username: username)
    try await user.create(on: req.db)
    req.auth.login(user)

    // Generate registration options
    let options = req.webAuthn.beginRegistration(user:
        .init(
            id: try [UInt8](user.requireID().uuidString.utf8),
            name: user.username,
            displayName: user.username
        )
    )

    // Also pass along challenge because we need it later
    req.session.data["registrationChallenge"] = Data(options.challenge).base64EncodedString()

    return CreateCredentialOptions(publicKey: options)
}
```

`/register`에서 새 사용자를 생성하고 새로 생성된 사용자로 `beginRegistration` 함수를 호출합니다. 이렇게 하면 클라이언트에 다시 보내는 옵션 세트가 제공됩니다. 또한 나중에 새 Passkey를 검증할 때 필요하므로 챌린지를 쿠키에 저장합니다. 반환된 옵션을 살펴보면 이 블로그 글의 시작 부분에서 브라우저의 JavaScript 콘솔에 수동으로 입력한 옵션과 동일한 것을 알 수 있습니다!

WebAuthn API는 `publicKey`라는 프로퍼티 안에 옵션이 있기를 기대합니다. 그래서 아직 존재하지 않는 `CreateCredentialOptions` 인스턴스를 반환합니다. 이를 생성하고 Vapor 라우트 핸들러에서 쉽게 반환할 수 있도록 `AsyncResponseEncodable`에 준수합니다:

```swift
struct CreateCredentialOptions: Encodable, AsyncResponseEncodable {
    let publicKey: PublicKeyCredentialCreationOptions

    func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.contentType = .json
        return try Response(status: .ok, headers: headers, body: .init(data: JSONEncoder().encode(self)))
    }
}
```

시도해 볼 시간입니다: 사용자 이름을 입력하고 "Register"를 클릭하면 새 Passkey를 생성하라는 프롬프트가 트리거되어야 합니다! 하지만 그 후에는 아무 일도 일어나지 않습니다. 이를 고쳐 보겠습니다!

### Passkey 검증 및 저장

브라우저가 Passkey를 생성한 후 서버로 보내고, 모든 것이 제대로 되었는지 검증하고 어딘가에 저장해야 합니다.

먼저 Passkey를 서버로 보냅시다. JavaScript 코드에서 `registerForm` 이벤트 리스너의 `const passkey = await create(parseCreationOptionsFromJSON(registerResponseJSON));` 바로 아래에 다음을 추가합니다:

```js
const createPasskeyResponse = await fetch('/passkeys', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(passkey),
})
```

서버에서는 먼저 Passkey를 등록할 사용자를 가져옵니다. 그런 다음 요청 본문에서 Passkey를 디코드하고 검증합니다. 모든 것이 잘 되면 데이터베이스에 Passkey를 저장할 수 있습니다. 새 `POST /register` 엔드포인트에 이 로직을 추가합니다:

```swift
// Example implementation for a Vapor app
app.post("register", use: { req in
    // Obtain the user we're registering a credential for
    let user = try req.auth.require(User.self)

    // Obtain the challenge we stored for this session
    guard let challengeEncoded = req.session.data["registrationChallenge"],
        let challenge = Data(base64Encoded: challengeEncoded) else {
        throw Abort(.badRequest, reason: "Missing registration challenge")
    }

    // Delete the challenge to prevent attackers from reusing it
    req.session.data["registrationChallenge"] = nil

    // Verify the credential the client sent us
    let credential = try await req.webAuthn.finishRegistration(
        challenge: [UInt8](challenge),
        credentialCreationData: req.content.decode(RegistrationCredential.self),
        confirmCredentialIDNotRegisteredYet: { _ in true}
    )

    try await Passkey(
        id: credential.id,
        publicKey: credential.publicKey.base64URLEncodedString().asString(),
        currentSignCount: credential.signCount,
        userID: user.requireID()
    ).save(on: req.db)

    return HTTPStatus.ok
})
```

축하합니다, Passkey 등록을 구현했습니다! 사용자 이름을 입력하고 "Register"를 누르면 비공개 페이지로 리디렉션됩니다. Passkey는 이제 데이터베이스(passkeys 테이블)에도 나타나야 합니다.

## 2막 - 로그인

이제 Passkey가 있으므로 이를 사용하여 로그인할 수 있습니다. 이 과정은 등록 과정과 매우 유사하지만, 사용자 이름을 입력하는 입력 필드가 필요 없습니다.
프론트엔드부터 시작합시다. `Resources/Views/index.leaf`에서 등록 양식 아래에 새 HTML 양식을 추가합니다:

```html
</form>
<!-- End of registration form -->

<form id="loginForm">
    <button type="submit">Login</button>
</form>
```

다음으로 GitHub WebAuthn 래퍼에서 두 개의 추가 헬퍼를 import해야 합니다. `<script>` 태그의 import 문을 업데이트하여 `get`과 `parseRequestOptionsFromJSON`을 포함합니다:

```js
import { create, get, parseCreationOptionsFromJSON, parseRequestOptionsFromJSON } from 'https://cdn.jsdelivr.net.....
```

스크립트 끝에 다음 코드를 추가합니다:

```js
// ...
//     location.href = "/private";
// });

// Get a reference to our login form
const loginForm = document.getElementById('loginForm')

// Listen for the form's "submit" event
loginForm.addEventListener('submit', async function (event) {
  event.preventDefault()
  // Send request to Vapor app
  const loginResponse = await fetch('/login')
  // Parse response as json and pass into wrapped WebAuthn API
  const loginResponseJSON = await loginResponse.json()
  const loginAttempt = await get(parseRequestOptionsFromJSON(loginResponseJSON))
})
```

등록과 마찬가지로 양식의 `submit` 이벤트를 수신 대기합니다. 제출 시 백엔드에 `/login` 요청을 보냅니다. 응답에는 여러 옵션과 무작위로 생성된 챌린지가 포함됩니다. 이 데이터를 `get(parseRequestOptionsFromJSON(...))`에 전달하면 브라우저가 Passkey를 사용하여 로그인하라는 프롬프트를 표시합니다. 성공하면 챌린지가 Passkey에 의해 서명됩니다. 이 서명된 챌린지를 두 번째 요청으로 서버에 다시 보냅니다. `const loginAttempt = await get(parseRequestOptionsFromJSON(loginResponseJSON));` 바로 뒤에 다음을 추가합니다:

```js
// Send passkey to Vapor app
const loginAttemptResponse = await fetch('/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify(loginAttempt),
})

// Redirect to private page
location.href = '/private'
```

이것은 서명된 챌린지가 포함된 로그인 시도를 서버로 보내고, 모든 것이 잘 되면 사용자를 비공개 페이지로 리디렉션합니다. 서버 측을 구현합시다. 먼저 옵션과 무작위로 생성된 챌린지를 반환하는 `GET /login` 요청을 처리하는 엔드포인트를 추가합니다:

```swift
app.get("login") { req in
    // Generate registration options
    let options = try req.webAuthn.beginAuthentication()
    // Also pass along challenge because we need it later
    req.session.data["authChallenge"] = Data(options.challenge).base64EncodedString()
    return RequestCredentialOptions(publicKey: options)
}
```

나중에 Passkey를 검증할 때 필요하므로 챌린지를 쿠키에도 저장합니다. 서버를 실행하고 "Login"을 누르면 Passkey 프롬프트가 트리거되어야 합니다. 이전에 등록한 경우 사용자 이름(또는 여러 계정을 등록한 경우 사용자 이름 목록)도 표시됩니다. 그러나 프롬프트를 확인하려고 하면 아무 일도 일어나지 않습니다.

마지막 단계는 `POST /login` 엔드포인트에서 로그인 시도를 검증하는 것입니다. 엔드포인트를 추가하고 사용자 세션에서 챌린지를 가져오는 것부터 시작합니다:

```swift
app.post("login") { req in
    // Obtain the challenge we stored on the server for this session
    guard let challengeEncoded = req.session.data["authChallenge"],
        let challenge = Data(base64Encoded: challengeEncoded) else {
        throw Abort(.badRequest, reason: "Missing authentication challenge")
    }

    req.session.data["authChallenge"] = nil
}
```

공격자가 [리플레이 공격](https://en.wikipedia.org/wiki/Replay_attack)이라고 하는 방법으로 챌린지를 재사용하는 것을 방지하기 위해 세션에서 즉시 삭제합니다. 로그인 시도를 검증하기 위해 먼저 요청 본문에서 디코드하고 데이터베이스에서 해당하는 Passkey를 찾습니다. Passkey를 찾으면 계속 진행하여 로그인 시도를 검증할 수 있습니다. `req.session.data["authChallenge"] = nil` 아래에 다음을 추가합니다:

```swift
let authenticationCredential = try req.content.decode(AuthenticationCredential.self)

guard let credential = try await Passkey.query(on: req.db)
    .filter(\.$id == authenticationCredential.id.urlDecoded.asString())
    .with(\.$user)
    .first() else {
    throw Abort(.unauthorized)
}

let verifiedAuthentication = try req.webAuthn.finishAuthentication(
    credential: authenticationCredential,
    expectedChallenge: [UInt8](challenge),
    credentialPublicKey: [UInt8](URLEncodedBase64(credential.publicKey).urlDecoded.decoded!),
    credentialCurrentSignCount: credential.currentSignCount
)
```

마지막으로 `webAuthn.finishAuthentication`이 오류를 던지지 않고 반환하면 로그인 시도가 성공한 것입니다. 이제 Passkey의 `currentSignCount`를 업데이트하고 사용자를 로그인시킨 후 응답을 반환할 수 있습니다. `req.webAuthn.finishAuthentication` 호출 바로 뒤에 추가합니다:

```swift
credential.currentSignCount = verifiedAuthentication.newSignCount
try await credential.save(on: req.db)

req.auth.login(credential.user)
return HTTPStatus.ok
```

축하합니다, Passkey 로그인을 구현했습니다! 로그인 버튼을 누르고 Passkey 프롬프트를 확인하면 비공개 페이지로 리디렉션됩니다. 전체 구현을 보고 싶다면 [데모 프로젝트](https://github.com/brokenhandsio/swift-webauthn-guide)의 "final" 디렉터리에서 찾을 수 있습니다.
