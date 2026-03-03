---
layout: page
title: Windows 설치 방법
---

## 의존성

Swift에는 다음과 같은 일반 의존성이 필요합니다:

- Git (Swift Package Manager에서 사용)
- Python[^1] (디버거 - LLDB에서 사용)

[^1]: Windows 바이너리는 Python 3.10 기준으로 빌드됩니다.

Windows에서 Swift를 사용하려면 다음과 같은 추가 플랫폼별 의존성이 필요합니다:

- Windows SDK (Windows 헤더 및 임포트 라이브러리 제공)
- Visual Studio (추가 헤더를 위한 Visual C++ SDK/Build Tools 제공)

## 개발자 모드

애플리케이션 개발, 특히 Swift Package Manager를 사용하려면 개발자 모드를 활성화해야 합니다. 개발자 모드 활성화 방법은 Microsoft [문서](https://docs.microsoft.com/windows/apps/get-started/enable-your-device-for-development)를 참고하세요.

{% include_relative _winget.md %}
{% include_relative _scoop.md %}
{% include_relative _traditional.md %}
