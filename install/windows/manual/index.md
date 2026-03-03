---
layout: page-wide
title: 수동 설치
---

## Windows 플랫폼 의존성 설치

Windows에서 Swift를 사용하려면 C++ 툴체인과 Windows SDK를 포함한 여러 개발 도구가 필요합니다. Windows에서는 일반적으로 [Visual Studio](https://visualstudio.microsoft.com)로 이러한 컴포넌트를 설치합니다.

다음 Visual Studio 컴포넌트를 설치해야 합니다:

| 이름                                                       | 컴포넌트 ID                                         |
| ---------------------------------------------------------- | --------------------------------------------------- |
| MSVC v143 - VS 2022 C++ x64/x86 빌드 도구 (최신)[^1]       | Microsoft.VisualStudio.Component.VC.Tools.x86.x64   |
| MSVC v143 - VS 2022 C++ ARM64/ARM64EC 빌드 도구 (최신)[^1] | Microsoft.VisualStudio.Component.VC.Tools.ARM64     |
| Windows 11 SDK (10.0.22000.0)[^2]                          | Microsoft.VisualStudio.Component.Windows11SDK.22000 |

[^1]: 최소한 현재 머신 아키텍처에 맞는 빌드 도구를 설치해야 합니다. 다른 머신 아키텍처에서 실행할 Swift 바이너리를 크로스 컴파일하려면 추가 아키텍처도 설치하는 것을 권장합니다.

[^2]: 더 새로운 SDK를 설치해도 됩니다.

다음 의존성도 설치해야 합니다:

- [Python 3.10._x_](https://www.python.org/downloads/windows/) [^3]
- [Git for Windows](https://git-scm.com/downloads/win)

[^3]: 최신 `.x` 패치 릴리스를 설치할 수 있지만, 최적의 호환성을 위해 지정된 `major.minor` 버전의 Python을 사용하세요.

## 개발자 모드 활성화

개발자 모드는 Swift 개발에 필요한 디버깅 및 기타 설정을 활성화합니다. 개발자 모드 활성화 방법은 Microsoft [문서](https://docs.microsoft.com/windows/apps/get-started/enable-your-device-for-development)를 참고하세요.

## Swift 설치

위 의존성을 모두 설치한 후, [최신 Swift 안정 릴리스({{ site.data.builds.swift_releases.last.name }})의 설치 프로그램을 다운로드하여 실행하세요](/install/windows).

활발히 개발 중인 기능을 사용하려면 [개발 스냅샷](/install/windows/#development-snapshots)을 설치할 수도 있습니다.

기본적으로 Swift 바이너리는 `%LocalAppData%\Programs\Swift`에 설치됩니다.

<hr>
