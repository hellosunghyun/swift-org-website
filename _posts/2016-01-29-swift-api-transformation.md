---
layout: new-layouts/post
published: true
date: 2016-1-29
title: "다가오는 대규모 Swift API 변환"
author: dabrahams
category: "Language"
---

Cocoa, Swift 표준 라이브러리, 여러분의 타입과 메서드까지—모든 것이 곧 바뀌며, 여러분이 그 방향을 결정하는 데 참여할 수 있습니다.

Swift가 출시되기 전부터 Cocoa 인터페이스와 Swift 표준 라이브러리의 API 사이에는 스타일 차이가 있었습니다. 많은 것이 불필요하게 *달라* 보였습니다. 이는 단순한 미적 문제가 아닙니다. 비일관성과 예측 불가능함은 코딩부터 디버깅, 유지보수에 이르기까지 모든 것을 어렵게 만듭니다. 다행히 Swift 개발자들은 이런 차이에도 불구하고 훌륭한 코드를 많이 만들었고, 그 과정에서 "Swift다운" 코드가 어떤 모습이어야 하는지에 대한 감각이 형성되었습니다.

그런 경험을 바탕으로 API를 살펴보면 개선의 여지가 명확히 보입니다. 컴파일러가 Objective-C API를 임포트하는 방식(결과가 Swift에서 자연스럽지 않은 경우)과 Cocoa 사용자가 기대하는 수준의 규칙성과 일관성이 부족한 Swift 표준 라이브러리 모두에서 말입니다. 그래서 Apple은 이 문제를 해결하기로 했습니다.

Cocoa와 표준 라이브러리를 수렴시키기 위해 모두가 따를 수 있는 통합된 서면 API 디자인 접근 방식이라는 목표가 필요했습니다. 기존의 가정을 처음부터 다시 검토하는 것에서 시작했습니다. 기존 가이드라인은 훌륭했지만, 상당 부분이 Objective-C에 맞춰져 있었고, 기본 인수 같은 Swift 고유 기능을 다루지 않았으며, 무엇보다 우리가 포착하고 싶었던 "Swift다움"의 감각이 반영되지 않았습니다.

이 가이드라인을 개발하면서 표준 라이브러리 전체, Cocoa 전체, 그리고 몇 가지 샘플 프로젝트에 적용했습니다. 결과를 평가하고, 개선하고, 반복했습니다. Swift가 오픈 소스화되기 전이라면 이 모든 것을 비공개로 진행하고 다음 릴리스에서 결과를 제시했겠지만, Swift에 새로운 시대가 열렸습니다. 우리가 해 온 작업을 세상에 보여줄 때입니다. 변환 전 코드의 간단한 예시입니다:

~~~swift
class UIBezierPath : NSObject, NSCopying, NSCoding { ... }
...
path.addLineToPoint(CGPoint(x: 100, y: 0))
path.fillWithBlendMode(kCGBlendModeMultiply, alpha: 0.7)
~~~

변환 후:

~~~swift
class UIBezierPath : Object, Copying, Coding { ... }
...
path.addLineTo(CGPoint(x: 100, y: 0))
path.fillWith(kCGBlendModeMultiply, alpha: 0.7)
~~~

이 제안된 변환의 세 부분을 [Swift Evolution 그룹](/community/#mailing-lists)에 공개 리뷰를 위해 올렸습니다:
[Cocoa 임포트 방식 변경](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md),
[표준 라이브러리 표면 변경](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0006-apply-api-guidelines-to-the-standard-library.md),
그리고 이 모든 것을 연결하는
[API 가이드라인](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0023-api-guidelines.md).
참여자들의 개선 제안이 이미 들어오고 있으며, 이 제안이
[API에 미치는 영향](https://github.com/apple/swift-3-api-guidelines-review/pull/5/files)을 확인할 수 있습니다.

예를 들어,
[한 제안](http://news.gmane.org/find-root.php?message_id=3C5040B3%2dA205%2d46FA%2d98D3%2d5696D678EB39%40gmail.com)을
[검토](http://news.gmane.org/find-root.php?message_id=18A8335F%2d65F3%2d46A1%2dA494%2dAA89AC10836B%40apple.com)한 결과, 다음 호출이:

~~~swift
path.addArcWithCenter(
  origin, radius: 20.0,
  startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
~~~

다음과 같이 바뀝니다:

~~~swift
path.addArc(
  center: origin, radius: 20.0,
  startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
~~~

이 변경이 실제로 이루어질까요? 아직 결정되지 않았지만, 지금이 여러분의 의견을 내야 할 때입니다. 리뷰 기간이 **2월 5일 금요일**까지 연장되었습니다. 여러분의 언어와 프레임워크의 미래를 함께 만들고 싶다면
[토론에 참여해 주세요](/contributing/#participating-in-the-swift-evolution-process).
제안서와 관련 리뷰 스레드는 다음과 같습니다:

* [API 디자인 가이드라인](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0023-api-guidelines.md) — [토론](http://news.gmane.org/find-root.php?message_id=ABB71FFD%2d1AE8%2d43D3%2dB3F5%2d58225A2BAD66%40apple.com)
* [Objective-C API의 Swift 변환 개선](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md) — [토론](http://news.gmane.org/find-root.php?message_id=CC036592%2d085D%2d4095%2d8D73%2d1DA9FC90A07B%40apple.com)
* [API 가이드라인을 표준 라이브러리에 적용](https://github.com/swiftlang/swift-evolution/blob/master/proposals/0006-apply-api-guidelines-to-the-standard-library.md) — [토론](http://news.gmane.org/find-root.php?message_id=73E699B0%2dFAD2%2d46DA%2dB74E%2d849445A2F38A%40apple.com)
