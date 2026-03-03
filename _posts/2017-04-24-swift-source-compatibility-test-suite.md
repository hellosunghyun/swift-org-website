---
layout: new-layouts/post
published: true
date: 2017-04-24 13:01:01
title: Swift 소스 호환성 테스트 스위트 공개
author: lplarson
category: "Developer Tools"
---

향후 Swift 릴리스에서 소스 호환성을 유지하기 위한 노력의 일환으로 새로운 [Swift 소스 호환성 테스트 스위트](https://github.com/swiftlang/swift-source-compat-suite)를 공개하게 되어 기쁩니다.

소스 호환성 테스트 스위트는 커뮤니티 주도로 운영되며, 오픈 소스 프로젝트 소유자가 자신의 프로젝트를 스위트에 포함시킬 수 있습니다. 테스트 스위트에 오픈 소스 프로젝트를 추가하는 방법은 Swift.org의 [Swift 소스 호환성](/documentation/source-compatibility) 섹션에서 확인할 수 있습니다.

[Swift 지속적 통합 시스템](https://ci.swift.org)은 소스 호환성 회귀를 가능한 빨리 포착하기 위해 스위트에 포함된 프로젝트를 Swift 개발 버전으로 주기적으로 빌드합니다.

Swift 컴파일러 개발자는 이제 Swift의 풀 리퀘스트 테스트 시스템을 사용하여 소스 호환성 테스트 스위트에 대해 변경 사항을 테스트할 수 있어, 병합 전에 소스 호환성 회귀를 포착할 수 있습니다.

목표는 수천 개의 프로젝트를 포함하는 강력한 소스 호환성 테스트 스위트를 갖추는 것입니다. 프로젝트 소유자들이 오픈 소스 Swift 프로젝트를 테스트 스위트에 포함시켜 이 목표를 달성하는 데 도움을 주시기를 기대합니다.
