---
redirect_from: 'server/guides/llvm-sanitizers'
layout: page
title: LLVM TSAN / ASAN
---

멀티스레드 및 저수준 unsafe 인터페이스 서버 코드의 경우, LLVM의 [ThreadSanitizer](https://clang.llvm.org/docs/ThreadSanitizer.html)와
[AddressSanitizer](https://clang.llvm.org/docs/AddressSanitizer.html)를 사용하면 잘못된 스레드 사용 및 잘못된 메모리 사용/접근 문제를 해결하는 데 도움이 됩니다.

TSAN 사용법을 설명하는 [블로그 글](/blog/tsan-support-on-linux/)이 있습니다.

요약하면 각 도구에 대해 swiftc 커맨드라인 옵션 `-sanitize=address`와 `-sanitize=thread`를 사용하면 됩니다.

Swift Package Manager 프로젝트에서도 커맨드라인에서 `--sanitize`를 사용할 수 있습니다. 예:

```
swift build --sanitize=address
```

또는

```
swift build --sanitize=thread
```

테스트에도 사용할 수 있습니다:

```
swift test --sanitize=address
```

또는

```
swift test --sanitize=thread
```
