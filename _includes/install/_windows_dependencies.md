## 의존성

Swift에는 다음과 같은 일반적인 의존성이 필요합니다:

- Git (Swift Package Manager에서 사용)
- Python[^1] (디버거 LLDB에서 사용)

[^1]: Windows 바이너리는 Python 3.10 기반으로 빌드되었습니다.

Windows에서 Swift를 사용하려면 다음과 같은 플랫폼별 추가 의존성이 필요합니다:

- Windows SDK (Windows 헤더와 import 라이브러리 제공)
- Visual Studio (추가 헤더를 위한 Visual C++ SDK/Build Tools 제공)

## 개발자 모드

애플리케이션을 개발하려면, 특히 Swift Package Manager를 사용할 때 개발자 모드를 활성화해야 합니다. 개발자 모드 활성화 방법은 Microsoft [문서](https://docs.microsoft.com/windows/apps/get-started/enable-your-device-for-development)를 참고하세요.
