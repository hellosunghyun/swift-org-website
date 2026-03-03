---
layout: page
title: 라이선스
---

[Swift 라이선스](/LICENSE.txt)는 [Apache 2.0 라이선스](https://www.apache.org/licenses/LICENSE-2.0.html)를 기반으로 하며, Swift를 사용하여 자체 바이너리를 빌드하고 배포할 때 귀속 요구 사항을 제거하는 [런타임 라이브러리 예외](#runtime-library-exception)가 포함되어 있습니다. Apache 2.0 라이선스는 Swift의 광범위한 사용을 허용하고, 많은 잠재적 기여자에게 이미 잘 알려져 있기 때문에 선택되었습니다.

저작권은 기여의 저자 또는 해당 개인이 소속된 회사나 조직이 보유합니다. 저작권 보유자 목록은 Swift.org의 [CONTRIBUTORS.txt](/CONTRIBUTORS.txt) 파일과 저장소 루트에 유지됩니다.

### 런타임 라이브러리 예외

런타임 라이브러리 예외는 Swift 컴파일러의 최종 사용자가 완성된 바이너리 애플리케이션, 게임 또는 서비스에서 Swift 사용을 귀속할 필요가 없음을 명확히 합니다. Swift 언어의 최종 사용자는 제한 없이 훌륭한 소프트웨어를 만들 수 있어야 합니다. 이 예외의 전문은 다음과 같습니다:

```
As an exception, if you use this Software to compile your source code and
portions of this Software are embedded into the binary product as a result,
you may redistribute such product without providing attribution as would
otherwise be required by Sections 4(a), 4(b) and 4(d) of the License.
```

이 예외는 [LICENSE.txt](/LICENSE.txt) 파일 하단에서도 확인할 수 있습니다.

### 소스 코드의 저작권과 라이선스

Swift.org에 호스팅되는 모든 소스 파일에는 해당되는 라이선스와 저작권을 선언하는 코멘트 블록이 파일 상단에 포함되어야 합니다. 이 텍스트는 예를 들어 [코드 기여][contributing_code] 섹션에 정의된 것과 같은 더 큰 헤더의 일부일 수 있습니다. 헤더 형식에 관계없이 라이선스 및 저작권 부분의 문구는 적절한 연도를 적용하여 다음과 같이 복사해야 합니다:

```
// This source file is part of the Swift.org open source project
//
// Copyright (c) {{site.time | date: "%Y"}} Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See /LICENSE.txt for license information
// See /CONTRIBUTORS.txt for the list of Swift project authors
```
