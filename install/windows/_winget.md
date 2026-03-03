## Windows 패키지 관리자를 사용한 설치

[Windows 패키지 관리자](https://docs.microsoft.com/windows/package-manager/)(WinGet)는 Windows 11(21H2 이상)에 기본 설치되어 있습니다. [Microsoft Store](https://www.microsoft.com/p/app-installer/9nblggh4nns1)에서 찾거나 [직접 설치](ms-appinstaller:?source=https://aka.ms/getwinget)할 수도 있습니다.

0. 필요한 모든 [의존성](/install/windows/#dependencies)을 설정합니다.

1. Windows 플랫폼 의존성을 설치합니다:

   필요한 C++ 툴체인과 Windows SDK는 Visual Studio 2022의 일부로 설치됩니다. 아래 지침은 Community 에디션 기준이지만, 사용 환경과 팀 규모에 따라 [다른 Visual Studio 에디션](https://visualstudio.microsoft.com/vs/compare/)을 사용할 수도 있습니다.

   ```batch
   winget install --id Microsoft.VisualStudio.2022.Community --exact --force --custom "--add Microsoft.VisualStudio.Component.Windows11SDK.22000 --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.Tools.ARM64"
   ```

2. Swift 및 기타 의존성을 설치합니다:

   최신 Swift 개발자 패키지와 필요한 경우 호환되는 Git, Python 도구를 설치합니다.

   ```batch
   winget install --id Swift.Toolchain -e
   ```
