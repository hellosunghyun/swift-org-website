---
layout: new-layouts/post
published: true
date: 2017-06-21 09:45:00
title: Swift Package Manager 매니페스트 API 재설계
author: aciid
category: "Developer Tools"
---

Swift 4의 Package Manager에는 재설계된 `Package.swift` 매니페스트 API가 포함됩니다. 새 API는 사용하기 더 쉽고 [디자인 가이드라인](/documentation/api-design-guidelines/)을 따릅니다. Swift 3 Package Manager의 타겟 추론 규칙은 흔한 혼란의 원인이었습니다. 이 규칙을 수정하고 대부분의 추론을 제거하여 매니페스트에서 패키지 구조를 명시적으로 지정하는 방식을 선호합니다.

Swift 4의 Package Manager가 하위 호환되므로 Swift 3 패키지는 계속 동작합니다. 매니페스트 버전은 패키지의 _도구 버전_에 의해 선택됩니다. 도구 버전은 특별한 주석 구문 `// swift-tools-version:<specifier>`를 사용하여 매니페스트의 첫 줄에 지정됩니다. 이 특별한 주석을 생략한 패키지는 기본적으로 도구 버전 3.1.0이 됩니다.

도구 버전은 패키지 소스를 컴파일하는 데 사용되는 기본 Swift 언어 버전도 결정합니다. 기존 Swift 3 패키지는 Swift 3 호환 모드로 컴파일됩니다. 기본 버전을 원하지 않으면 Swift 3과 Swift 4 매니페스트 모두에서 `swiftLanguageVersions` 프로퍼티를 선택적으로 사용하여 패키지 컴파일에 사용할 언어 버전을 설정할 수 있습니다. 이는 소스를 Swift 4로 업그레이드하지 않고도 패키지를 새로운 매니페스트 형식으로 업그레이드할 수 있음을 의미합니다.

## Swift 4에서 새 패키지 만들기

Use the `init` subcommand to create a new package in Swift 4:

~~~sh
$ mkdir mytool && cd mytool
$ swift package init
$ swift build
$ swift test
~~~

위 명령으로 생성된 `Package.swift` 매니페스트는 아래와 같습니다.

~~~swift
// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mytool",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "mytool",
            targets: ["mytool"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target defines a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "mytool",
            dependencies: []),
        .testTarget(
            name: "mytoolTests",
            dependencies: ["mytool"]),
    ]
)
~~~

위의 Swift 4 매니페스트와 이전 매니페스트 형식 사이에는 세 가지 주요 차이점이 있습니다:

1. The tools version `4.0` is specified using the line `// swift-tools-version:4.0`.
2. 모든 타겟과 의존성을 명시적으로 선언해야 합니다.
3. 공개 타겟은 새 제품 API를 사용하여 제품으로 제공됩니다. Swift 4 패키지의 타겟은 다른 패키지의 제품이나 동일 패키지의 타겟에 의존할 수 있습니다.

## 커스텀 타겟 레이아웃

새 매니페스트는 패키지 레이아웃 커스터마이징을 지원합니다. 더 이상 복잡한 규약 기반 레이아웃 규칙을 따를 필요가 없습니다. 규칙은 하나뿐입니다: 타겟 경로가 제공되지 않으면 `Sources`, `Source`, `src`, `srcs`, `Tests` 디렉터리가 순서대로 검색되어 타겟을 찾습니다.

커스텀 레이아웃은 C 라이브러리를 Swift Package Manager로 포팅하는 것을 더 쉽게 만듭니다. 서버 사이드 Swift 커뮤니티에서 사용되는 두 C 라이브러리의 매니페스트입니다:

#### [LibYAML](https://github.com/yaml/libyaml)

~~~
Copyright (c) 2006-2016 Kirill Simonov, licensed under MIT license (https://github.com/yaml/libyaml/blob/master/LICENSE)
~~~

~~~swift
// swift-tools-version:4.0

import PackageDescription

let packages = Package(
    name: "LibYAML",
    products: [
        .library(
            name: "libyaml",
            targets: ["libyaml"]),
    ],
    targets: [
        .target(
            name: "libyaml",
            path: ".",
            sources: ["src"])
    ]
)
~~~

#### [Node.js http-parser](https://github.com/nodejs/http-parser)

~~~
Copyright by Authors (https://github.com/nodejs/http-parser/blob/master/AUTHORS), licensed under MIT license (https://github.com/nodejs/http-parser/blob/master/LICENSE-MIT)
~~~

~~~swift
// swift-tools-version:4.0

import PackageDescription

let packages = Package(
    name: "http-parser",
    products: [
        .library(
            name: "httpparser",
            targets: ["http-parser"]),
    ],
    targets: [
        .target(
            name: "http-parser",
            publicHeaders: ".",
            sources: ["http_parser.c"])
    ]
)
~~~

## 의존성 해석

Swift 3 Package Manager는 Swift 4 매니페스트 형식을 이해하지 못하므로 Swift 4 매니페스트가 포함된 Git 태그를 자동으로 무시합니다. 따라서 패키지가 Swift 4 매니페스트로 업그레이드하면 Swift 3 Package Manager는 Swift 3 매니페스트가 포함된 마지막 태그를 선택합니다. 반면 Swift 4의 Package Manager는 매니페스트 버전에 관계없이 최신 사용 가능한 버전을 선택합니다.

## 기존 패키지를 Swift 4 매니페스트 형식으로 업데이트

기존 패키지를 Swift 4 매니페스트 형식으로 업데이트하려면 다음 단계를 따르세요.

* 패키지의 도구 버전을 업데이트합니다.

    `tools-version` 하위 명령을 사용하여 패키지의 도구 버전을 업데이트합니다.

~~~sh
$ cd mypackage
$ swift package tools-version --set-current
~~~

* `dependencies` 레이블을 `targets` 레이블 앞으로 이동하고 패키지 의존성 구문을 업데이트합니다. 예:

~~~diff
    ...
    dependencies: [
-    .Package(url: "https://github.com/apple/example-package-fisheryates.git", majorVersion: 2),
+    .package(url: "https://github.com/apple/example-package-fisheryates.git", from: "2.0.0"),

-    .Package(url: "https://github.com/apple/example-package-playingcard.git", majorVersion: 3, minor: 3),
+    .package(url: "https://github.com/apple/example-package-playingcard.git", .upToNextMinor(from: "3.3.0")),
    ]
    ...
~~~

* 모든 일반 타겟과 테스트 타겟을 선언합니다.

    모든 타겟과 의존성을 명시적으로 선언해야 합니다. `Foo`와 `FooTests` 두 타겟이 있다면 `targets` 레이블에 둘 다 선언합니다. 예:

~~~swift
    ...
    targets: [
        .target(
            name: "Foo"),
        .testTarget(
            name: "FooTests",
            dependencies: ["Foo"]),
    ]
    ...
~~~

* 패키지가 레거시 단일 타겟 레이아웃을 사용하는 경우 레이아웃을 업데이트하거나 타겟 경로를 제공합니다.

    권장 레이아웃은 `Sources` 아래에 타겟당 하나의 디렉터리를 두는 것입니다(즉 `Sources/<target-name>`). 패키지가 이 레이아웃을 사용하면 타겟 경로가 자동으로 감지됩니다. 그렇지 않으면 타겟 경로를 제공합니다. 예:

~~~swift
    ...
    targets: [
        .target(
            name: "Foo",
            path: "."), // The sources are located in package root.
        .target(
            name: "Bar",
            path: "Sources") // The sources are located in directory Sources/.
    ]
    ...
~~~

* 제품 API를 사용하여 공개 타겟을 내보냅니다.

    라이브러리 패키지는 다른 패키지가 임포트할 수 있도록 공개 타겟을 명시적으로 내보내야 합니다. 샘플 코드 타겟, 테스트 지원 라이브러리 등의 타겟은 내보내지 마세요.

~~~swift
    ...
    products: [
        .library(
            name: "Foo",
            targets: ["Foo", "Bar"]),
    ],
    ...
~~~

* Swift 3 호환 모드로 컴파일합니다.

    패키지 소스 코드를 Swift 4로 업데이트하기 전에 패키지 매니페스트를 새 형식으로 업데이트할 수 있습니다. 이를 위해 `swiftLanguageVersions` 프로퍼티를 3으로 설정하여 Swift 3 호환 모드로 패키지를 빌드합니다.

~~~swift
    ...
    swiftLanguageVersions: [3]
    ...
~~~
