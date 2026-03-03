## 이전 Swift 릴리스 설치

<div class="warning" markdown="1">
이 페이지는 Swift 5.9 이전 버전의 수동 설치 과정을 안내합니다. 이후 릴리스에서는 의존성이 업데이트되었으며 [간소화된 설치 과정](/install/windows/manual)을 사용합니다.
</div>

이전 버전의 Swift는 [Visual Studio](https://visualstudio.microsoft.com) 2019에서 테스트되었습니다. 다음 컴포넌트와 함께 Visual Studio를 설치해야 합니다. 이전 Swift 설치 프로그램은 [다운로드](/download/#:~:text=Older%20Releases) 섹션에서 받을 수 있습니다. Windows에서 툴체인은 일반적으로 `%SystemDrive%\Library\Developer\Toolchains`에 설치됩니다.

다음 Visual Studio 컴포넌트가 **필수**입니다:

| 컴포넌트                                         | Visual Studio ID                                    |
| ------------------------------------------------ | --------------------------------------------------- |
| MSVC v142 - VS 2019 C++ x64/x86 빌드 도구 (최신) | Microsoft.VisualStudio.Component.VC.Tools.x86.x64   |
| Windows 10 SDK (10.0.17763.0)[^2]                | Microsoft.VisualStudio.Component.Windows10SDK.17763 |

[^2]: 더 새로운 SDK를 설치해도 됩니다.

다음 추가 Visual Studio 컴포넌트를 **권장**합니다:

| 컴포넌트                | Visual Studio ID                     |
| ----------------------- | ------------------------------------ |
| Git for Windows         | Microsoft.VisualStudio.Component.Git |
| Python 3 64-bit (3.7.8) | Component.CPython.x64                |

다음 추가 Visual Studio 컴포넌트를 **제안**합니다:

| 컴포넌트                    | Visual Studio ID                                  |
| --------------------------- | ------------------------------------------------- |
| C++ CMake tools for Windows | Microsoft.VisualStudio.Component.VC.CMake.Project |

Visual Studio와 필수 컴포넌트를 설치한 후:

0. 필요한 [이전 Swift 릴리스 설치 프로그램](/download/#:~:text=Older%20Releases)을 다운로드합니다.

1. 패키지 설치 프로그램을 실행합니다.

### 지원 파일

<div class="info" markdown="1">
이 과정은 5.4.2 이전 버전에서만 필요합니다.
</div>

<div class="warning" markdown="1">
다음 명령은 `x64 Native Tools for VS2019 Command Prompt`를 관리자 권한으로 실행하여 사용해야 합니다.
`x64 Native Tools for VS2019 Command Prompt`는 시스템 헤더를 찾는 데 필요한 환경 변수를 설정합니다.
Visual Studio 설치를 수정하려면 관리자 권한이 필요합니다.
</div>

Windows SDK를 Swift에서 사용할 수 있도록 하려면 Windows SDK에 몇 개의 파일을 배포해야 합니다.

```batch
copy /Y %SDKROOT%\usr\share\ucrt.modulemap "%UniversalCRTSdkDir%\Include\%UCRTVersion%\ucrt\module.modulemap"
copy /Y %SDKROOT%\usr\share\visualc.modulemap "%VCToolsInstallDir%\include\module.modulemap"
copy /Y %SDKROOT%\usr\share\visualc.apinotes "%VCToolsInstallDir%\include\visualc.apinotes"
copy /Y %SDKROOT%\usr\share\winsdk.modulemap "%UniversalCRTSdkDir%\Include\%UCRTVersion%\um\module.modulemap"
```

Windows SDK는 일반적으로 Visual Studio의 일부로 설치되므로, Visual Studio가 업데이트될 때마다 이 파일을 다시 복사해야 할 수 있습니다.

### Visual Studio 업데이트 후 복구

<div class="info" markdown="1">
이 과정은 5.9.0 이전 버전에서만 필요합니다.
</div>

Visual Studio가 업데이트되면 설치를 복구해야 할 수 있습니다. 5.4.2 이전 버전의 경우 [위에서 안내한](#support-files) 지원 파일을 다시 설치하세요. 이후 버전의 경우 설치된 프로그램 복구에 대한 Microsoft [안내](https://support.microsoft.com/windows/repair-apps-and-programs-in-windows-10-e90eefe4-d0a2-7c1b-dd59-949a9030f317)를 참고하세요.

### Windows에서의 코드 서명

<div class="warning" markdown="1">
다음 명령은 PowerShell에서 실행해야 합니다.
</div>

0. [GnuPG.org](https://gnupg.org/download/index.html)에서 GPG를 설치합니다.

1. Swift 패키지를 **처음 다운로드하는 경우**, PGP 키를 키링에 가져옵니다:

{% assign all_keys_file = 'all-keys.asc' %}

```powershell
$ gpg.exe —keyserver hkp://keyserver.ubuntu.com `
          —receive-keys `
          'A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561' `
          '8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA'
```

또는:

```powershell
$ wget /keys/{{ all_keys_file }} -UseBasicParsing | Select-Object -Expand Content | gpg.exe —import -
```

이전에 키를 가져온 적이 있다면 이 단계를 건너뛰세요.

0. PGP 서명을 검증합니다.

   Windows용 `.exe` 설치 프로그램은 Swift 오픈 소스 프로젝트의 키 중 하나를 사용하여 GnuPG로 서명됩니다. 소프트웨어를 사용하기 전에 반드시 서명을 검증하는 것을 권장합니다.

   먼저 새로운 키 폐기 인증서가 있으면 다운로드하기 위해 키를 갱신합니다:

   ```powershell
   $ gpg.exe —keyserver hkp://keyserver.ubuntu.com —refresh-keys Swift
   ```

   그런 다음 서명 파일을 사용하여 아카이브가 손상되지 않았는지 확인합니다:

   ```powershell
   $ gpg.exe —verify swift-<VERSION>-<PLATFORM>.exe.sig
   ...
   gpg: Good signature from "Swift Automatic Signing Key #3 <swift-infrastructure@swift.org>"
   ```

   공개 키가 없어서 `gpg`가 검증에 실패한 경우(`gpg: Can't check signature: No public key`), 아래 [활성 서명 키](#active-signing-keys)의 지침에 따라 키를 키링에 가져오세요.

   다음과 같은 경고가 표시될 수 있습니다:

   ```powershell
   gpg: WARNING: This key is not certified with a trusted signature!
   gpg:          There is no indication that the signature belongs to the owner.
   ```

   이 경고는 이 키와 사용자 사이에 신뢰 웹(Web of Trust) 경로가 없음을 의미합니다. 위의 단계에 따라 신뢰할 수 있는 출처에서 키를 가져왔다면 이 경고는 무해합니다.

<div class="warning" markdown="1">
  `gpg`가 검증에 실패하고 "BAD signature"를 보고하면 다운로드한 설치 프로그램을 실행하지 마세요. 대신 가능한 한 자세한 내용을 포함하여 <swift-infrastructure@forums.swift.org>로 이메일을 보내 주시면 문제를 조사하겠습니다.
</div>

<hr>
