---
layout: new-layouts/post
date: 2018-10-08 10:00:00
title: Swift Package Manager에서 REPL 지원
author: aciid
category: "Developer Tools"
---

`swift run` 명령어에 패키지의 라이브러리 타겟을 임포트할 수 있는 Swift REPL을 실행하는 새로운 `--repl` 옵션이 추가되었습니다.

Swift 배포판에는 Swift 언어용 REPL이 포함되어 있습니다. Swift REPL은 일회용 Swift 패키지나 Xcode 프로젝트를 만들지 않고도 Swift 코드를 실험해 볼 수 있는 훌륭한 도구입니다. REPL은 아무 인자 없이 `swift` 명령어를 실행하면 시작됩니다.

Swift REPL에서는 `Foundation`, `Dispatch` 같은 핵심 라이브러리와 macOS의 `Darwin`, Linux의 `Glibc` 같은 시스템 모듈을 임포트할 수 있습니다. 사실 REPL은 REPL을 시작할 때 제공되는 컴파일러 인자를 통해 올바르게 찾고 로드할 수 있는 모든 Swift 모듈을 임포트할 수 있습니다. Swift Package Manager는 이 기능을 활용하여 패키지의 라이브러리 타겟을 임포트하는 데 필요한 컴파일러 인자와 함께 REPL을 시작합니다.

## 예제

몇 가지 예제를 통해 새로운 기능을 살펴보겠습니다:

### [Yams](https://github.com/jpsim/Yams)

Yams는 YAML을 다루기 위한 Swift 패키지입니다.

패키지를 클론하고 `swift run --repl`을 사용하여 REPL을 실행합니다:

~~~sh
$ git clone https://github.com/jpsim/Yams
$ cd Yams
$ swift run --repl
~~~

패키지가 컴파일되고 Swift REPL이 실행됩니다. 객체를 YAML로 변환하는 `dump` 메서드를 사용해 보겠습니다:

~~~swift
  1> import Yams

  2> let yaml = try Yams.dump(object: ["foo": [1, 2, 3, 4], "bar": 3])
yaml: String = "bar: 3\nfoo:\n- 1\n- 2\n- 3\n- 4\n"

  3> print(yaml)
bar: 3
foo:
- 1
- 2
- 3
- 4
~~~

마찬가지로 `load` 메서드를 사용하여 문자열을 다시 객체로 변환할 수 있습니다:

~~~swift
  4> let object = try Yams.load(yaml: yaml)
object: Any? = 2 key/value pairs {
  ...
}

  5> print(object)
Optional([AnyHashable("bar"): 3, AnyHashable("foo"): [1, 2, 3, 4]])
~~~

### Vapor의 [HTTP](https://github.com/vapor/http)

[Vapor](http://vapor.codes) 프로젝트에는 [SwiftNIO](https://github.com/apple/swift-nio) 패키지 위에 구축된 [HTTP](https://github.com/vapor/http) 패키지가 있습니다.

패키지를 클론하고 `swift run --repl`을 사용하여 REPL을 실행합니다:

~~~sh
$ git clone https://github.com/vapor/http
$ cd http
$ swift run --repl
~~~

`HTTPClient` 타입을 사용하여 `GET` 요청을 만들어 보겠습니다:

~~~swift
  1> import HTTP
  2> let worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
  3> let client = HTTPClient.connect(hostname: "httpbin.org", on: worker).wait()
  4> let httpReq = HTTPRequest(method: .GET, url: "/json")
  5> let httpRes = try client.send(httpReq).wait()

  6> print(httpRes)
HTTP/1.1 200 OK
Connection: keep-alive
Server: gunicorn/19.9.0
Date: Sun, 30 Sep 2018 21:30:41 GMT
Content-Type: application/json
Content-Length: 429
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
Via: 1.1 vegur
{
  "slideshow": {
    "author": "Yours Truly",
    "date": "date of publication",
    "slides": [
      {
        "title": "Wake up to WonderWidgets!",
        "type": "all"
      },
      {
        "items": [
          "Why <em>WonderWidgets</em> are great",
          "Who <em>buys</em> WonderWidgets"
        ],
        "title": "Overview",
        "type": "all"
      }
    ],
    "title": "Sample Slide Show"
  }
}
~~~

Foundation의 `JSONSerialization`을 사용하여 응답을 파싱할 수 있습니다:

~~~swift
  7> let result = try JSONSerialization.jsonObject(with: httpRes.body.data!) as! NSDictionary
result: NSDictionary = 1 key/value pair {
  [0] = {
    key = "slideshow"
    value = 4 key/value pairs {
      [0] = {
        key = "slides"
        value = 2 elements
      }
      [1] = {
        key = "author"
        value = "Yours Truly"
      }
      [2] = {
        key = "title"
        value = "Sample Slide Show"
      }
      [3] = {
        key = "date"
        value = "date of publication"
      }
    }
  }
}
~~~

## 구현 세부 사항

Swift 패키지에서 REPL을 사용하려면 REPL 인자를 구성하기 위해 두 가지 정보가 필요합니다. 첫 번째는 라이브러리 타겟과 그 의존성에 대한 헤더 검색 경로를 제공하는 것입니다. Swift 타겟의 경우 모듈의 `.swiftmodule` 파일 경로를 제공해야 하고, C 타겟의 경우 타겟의 modulemap 파일이 포함된 디렉터리 경로가 필요합니다. 두 번째는 모든 라이브러리 타겟을 포함하는 공유 동적 라이브러리를 구성하는 것입니다. 이를 통해 REPL이 런타임에 필요한 심볼을 로드할 수 있습니다. SwiftPM은 루트 패키지의 모든 라이브러리 타겟을 포함하는 특수 product를 합성하여 이를 수행합니다. 이 특수 product는 `--repl` 옵션을 사용할 때만 빌드되며, 다른 패키지 매니저 작업에는 영향을 미치지 않습니다.

이 기능을 구현한 [풀 리퀘스트](https://github.com/swiftlang/swift-package-manager/pull/1793)에서 전체 구현 세부 사항을 확인하세요!

## 결론

Swift 패키지에 대한 REPL 지원은 REPL 환경을 더욱 강화하고, 라이브러리 패키지 작성자와 소비자 모두가 더 쉽게 실험할 수 있게 합니다. 이 기능은 최신 트렁크 [스냅샷](/download/#snapshots)에서 사용할 수 있습니다. 버그를 발견하거나 개선 요청이 있으면 [JIRA](https://github.com/swiftlang/swift-package-manager/blob/master/Documentation/Resources.md#reporting-a-good-swiftpm-bug)에 제출해 주세요!

## 질문이 있으신가요?

질문이 있거나 더 자세히 알고 싶다면 Swift 포럼의 관련 [토론 스레드](https://forums.swift.org/t/swift-org-blog-repl-support-for-swift-packages/16792)를 확인하세요.
