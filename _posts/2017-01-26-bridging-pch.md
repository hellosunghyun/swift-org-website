---
layout: new-layouts/post
published: true
date: 2017-1-26 10:00:00
title: 프리컴파일된 브리징 헤더로 더 빠른 혼합 빌드
author: graydon
category: "Language"
---

Objective-C와 Swift를 혼합하고 대규모 브리징 헤더를 포함하는 Xcode 프로젝트의 빌드 시간을 분석하면, Swift 컴파일러가 프로젝트의 모든 Swift 파일에 대해 동일한 브리징 헤더를 반복적으로 처리하는 데 많은 시간을 소비하는 것을 알 수 있습니다. 특정 프로젝트에서는 Swift 파일이 매우 작더라도 파일이 추가될 때마다 전체 빌드 시간이 눈에 띄게 증가합니다.

이 글에서는 이 컴파일 시간 비용과 Swift 3.1에서 어떻게 해결하고 있는지 설명합니다.

## 문제

혼합 언어 타겟의 Swift 파일이 컴파일될 때마다, Swift 컴파일러는 Objective-C 코드를 Swift 코드에서 볼 수 있도록 프로젝트의 브리징 헤더를 파싱합니다. 브리징 헤더가 크고 Swift 컴파일러가 여러 번 실행되는 경우(디버그 구성에서처럼) 브리징 헤더를 반복적으로 파싱하는 비용이 전체 빌드 시간의 상당 부분을 차지할 수 있습니다.

## 해결책

Swift 3.1에서 컴파일러에 이 비용을 줄이는 새로운 모드가 추가되었습니다: 브리징 헤더 _프리컴파일_. 이 모드가 활성화되면, 혼합 언어 타겟의 각 Swift 파일에 대해 브리징 헤더를 반복적으로 파싱하는 대신, 브리징 헤더가 한 번만 파싱되고 결과(임시 "프리컴파일된 헤더" 또는 "PCH" 파일)가 캐시되어 타겟의 모든 Swift 파일에서 재사용됩니다. 이는 Objective-C와 C++ 코드에서 접두사 헤더를 프리컴파일하는 데 사용되는 것과 동일한 프리컴파일된 헤더 기술을 활용합니다.

이 모드가 개발되고 테스트된 Swift 프로젝트에서 **디버그 빌드 시간이 30% 단축**되었습니다. 속도 향상은 프로젝트의 브리징 헤더 크기에 따라 달라지며, 이 모드는 [전체 모듈 최적화 빌드](/blog/whole-module-optimizations)에는 영향을 주지 않습니다. 하지만 디버그 구성에서 반복 작업 시 컴파일 시간을 크게 개선할 수 있습니다.

## 사용해 보기

이 모드는 Swift 3.1의 일부이며 [swift.org의 나이틀리 스냅샷](/download/#snapshots)과 [Xcode 8.3 beta](https://developer.apple.com/download/)에서 사용할 수 있습니다. 현재는 실험적이며 수동으로 활성화해야 합니다. 향후 릴리스에서 개발자 피드백에 따라 잘 동작하고 상당한 속도 향상을 제공하는 것으로 확인되면 기본적으로 활성화될 예정입니다. 당장 사용해 보려면 지원하는 컴파일러를 설치하고 프로젝트의 빌드 설정을 열어 "Other Swift Flags"에 `-enable-bridging-pch` 옵션을 추가하세요:

![브리징 PCH 활성화](/assets/images/bridging-pch-blog/build-setting.png)

## 피드백 제출

대규모 브리징 헤더가 있는 프로젝트가 있다면 이 새로운 모드를 사용해 보세요. 문제가 발생하면 [Swift.org 버그 추적 시스템](https://bugs.swift.org/)이나 [Apple 버그 리포트](https://bugreport.apple.com/)에 버그를 신고해 주세요. 일반적인 피드백도 [swift-users 메일링 리스트](https://lists.swift.org/pipermail/swift-users/)나 [Twitter](https://twitter.com/swiftlang)(`#SwiftBridgingPCH` 멘션)를 통해 환영합니다.

> 참고: Swift 메일링 리스트는 폐쇄되어 아카이브되었으며 [Swift Forums](https://forums.swift.org)로 대체되었습니다.
> [공지 사항은 여기]({% post_url 2018-01-19-forums %})를 참조하세요.
> 일반적인 피드백을 위한 공간은 포럼의 [Using Swift](https://forums.swift.org/c/swift-users/) 카테고리입니다.
