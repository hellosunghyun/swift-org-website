---
layout: new-layouts/post
published: true
date: 2016-02-08 18:00:00
title: Swift 벤치마크 스위트 공개
author: lplarson
category: "Developer Tools"
---

Apple Swift 팀은 Swift [벤치마크 스위트](https://github.com/apple/swift/tree/master/benchmark)를 오픈 소스로 공개하게 되어 기쁩니다.

이 스위트에는 Swift 성능을 추적하고 커밋 전에 성능 회귀를 포착하기 위한 벤치마크 소스 코드, 라이브러리, 유틸리티가 포함되어 있습니다:

- 주요 Swift 워크로드를 다루는 75개의 벤치마크
- 자주 필요한 벤치마킹 기능을 제공하는 라이브러리
- 벤치마크를 실행하고 성능 지표를 표시하는 드라이버
- Swift 버전 간 벤치마크 지표를 비교하는 유틸리티

Swift를 가능한 한 빠르게 만들기 위해 Swift 커뮤니티와 함께 작업하기를 기대합니다!

## 벤치마크 빌드 및 실행

Swift 프로젝트 기여자는 잠재적인 성능 회귀를 포착하기 위해 풀 리퀘스트를 요청하기 전에 변경 사항에 대해 Swift 벤치마크 스위트를 실행하는 것이 좋습니다. Swift 벤치마크 빌드 및 실행 방법은 [swift/benchmark/README.md](https://github.com/apple/swift/tree/master/benchmark)에서 확인할 수 있습니다.

향후 풀 리퀘스트에 대해 벤치마크를 실행하는 기능을 Swift의 [지속적 통합 시스템](https://ci.swift.org)에 추가할 계획입니다.

## 벤치마크 및 개선 사항 기여

Swift 벤치마크 스위트에 대한 기여를 환영합니다! 성능에 중요한 워크로드를 다루는 새로운 벤치마크, 벤치마크 헬퍼 라이브러리 추가, 기타 개선 사항에 대한 풀 리퀘스트를 권장합니다. Swift 벤치마크 스위트는 Swift 프로젝트의 [라이선스](https://github.com/apple/swift/blob/master/LICENSE.txt)를 공유하므로, 다른 라이선스가 적용된 벤치마크의 Swift 포팅은 수용할 수 없습니다. 스위트에 대한 추가 정보와 벤치마크 추가 방법은 [swift/benchmark/README.md](https://github.com/apple/swift/tree/master/benchmark)에서 확인할 수 있습니다.
