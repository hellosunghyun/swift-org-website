## Scoop을 사용한 설치

[Scoop](https://scoop.sh)은 Windows용 커맨드라인 설치 도구입니다. 다음 PowerShell 명령으로 설치할 수 있습니다.

```powershell
# 선택 사항: 원격 스크립트를 처음 실행할 때 필요
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Scoop 설치 명령
Invoke-RestMethod get.scoop.sh | Invoke-Expression
```

0. 일반 의존성을 설치합니다:

   ```batch
   scoop bucket add versions
   scoop install python39
   ```

1. Windows 플랫폼 의존성을 설치합니다:

   필요한 C++ 툴체인과 Windows SDK는 Visual Studio 2022의 일부로 설치됩니다. 아래 지침은 Community 에디션 기준이지만, 사용 환경과 팀 규모에 따라 [다른 Visual Studio 에디션](https://visualstudio.microsoft.com/vs/compare/)을 사용할 수도 있습니다.

   <div class="warning" markdown="1">
   이 코드 스니펫은 기존 명령 프롬프트(`cmd.exe`)에서 실행해야 합니다.
   </div>

   ```batch
   curl -sOL https://aka.ms/vs/17/release/vs_community.exe
   start /w vs_community.exe --passive --wait --norestart --nocache --add Microsoft.VisualStudio.Component.Windows11SDK.22000 --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.Tools.ARM64
   del /q vs_community.exe
   ```

2. Swift를 설치합니다:

   ```batch
   scoop install swift
   ```
