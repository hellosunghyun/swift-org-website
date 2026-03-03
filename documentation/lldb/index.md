---
redirect_from: '/lldb/'
layout: page
title: REPL과 디버거
---

Swift.org 커뮤니티는 [LLDB 디버거](https://github.com/swiftlang/llvm-project/tree/next/lldb)를 사용하여 풍부한 REPL 환경과 Swift 언어의 디버깅 환경을 제공합니다. Swift는 디버거에 내장된 Swift 컴파일러 버전과 긴밀하게 결합되어 있습니다. 컴파일러와 디버거의 긴밀한 통합으로 Swift 타입의 정확한 검사는 물론, 빠르게 발전하는 언어의 컨텍스트에서 완전한 기능의 표현식 평가가 가능합니다.

그러나 이러한 긴밀한 통합 때문에, 개발자는 _반드시_ 동일한 소스로 빌드된 컴파일러와 디버거 쌍을 사용해야 합니다. 다른 버전의 LLDB로 디버깅하면 예측할 수 없는 결과가 발생할 수 있습니다.

### REPL과 디버거를 결합한 이유

Swift 디버거를 Swift REPL의 기반으로 사용하게 된 결정에는 여러 동기 요인이 있었습니다.

- **통합 디버깅.** 가장 확실한 이점은 Swift REPL이 완전한 기능의 디버거이기도 하다는 것입니다. 함수를 선언하고, 브레이크포인트를 설정한 다음 호출하는 것이 매우 간단합니다. 브레이크포인트에서 실행이 멈추면 디버거의 전체 기능을 즉시 사용할 수 있습니다.

  ```text
    1> func answer() -> Int {
    2.     return 42
    3. }
    4> :b 2
    4> answer()
  Execution stopped at breakpoint.  Enter LLDB commands to investigate (type help for assistance.)
     1   	  func answer() -> Int {
  -> 2   	      return 42
     3   	  }
  ```

- **실패 복구.** Swift의 치명적 오류는 보통 프로세스를 즉시 종료시키며, 프로덕션 코드의 프로그래머 오류에는 합리적이지만 대화형 환경에서는 바람직하지 않습니다. Swift REPL은 전체 디버거로 오류를 조사하거나 즉시 복구를 위한 언와인딩을 지원합니다.

  ```text
    1> ["One", "Two"][2]
  fatal error: Array index out of range
  Execution interrupted. Enter Swift code to recover and continue.
  Enter LLDB commands to investigate (type :help for assistance.)
  ```

- **강력한 표현식 평가.** 디버거에서 전체 범위의 REPL 시나리오를 지원하는 것은 표현식 평가기에 높은 기준을 설정했습니다. 그 결과 디버거의 표현식은 Swift의 전체 언어 기능에 접근할 수 있으며, 유효한 모든 언어 구문을 자유롭게 선언할 수 있습니다.

- **일관된 결과 포맷팅.** REPL에서 값을 텍스트로 표현하는 전략이 디버거와 공유되어, 사용자 정의 타입에서도 일관된 출력을 보장합니다.

{% include_relative _playground-support.md %}

[coding_conventions]: https://llvm.org/docs/CodingStandards.html
[llvm-bugs]: https://bugs.llvm.org/ 'LLVM Bug Tracker'
