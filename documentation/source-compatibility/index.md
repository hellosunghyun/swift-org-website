---
redirect_from: '/source-compatibility/'
layout: page
title: Swift 소스 호환성
---

소스 호환성은 향후 Swift 릴리스의 중요한 목표입니다. 이 목표를 지원하기 위해, 커뮤니티가 소유하는 소스 호환성 테스트 스위트가 (점진적으로 증가하는) Swift 소스 코드 코퍼스에 대한 컴파일러 변경 사항의 회귀 테스트를 수행합니다. 이 테스트 스위트에 추가된 프로젝트는 [Swift의 지속적 통합 시스템](https://ci.swift.org)의 일환으로 최신 개발 버전의 Swift에 대해 주기적으로 빌드되어, Swift 컴파일러 개발자가 실제 Swift 프로젝트에 미치는 호환성 영향을 이해할 수 있게 합니다.

## 현재 프로젝트 목록

<ul>
 {% for project in site.data.source-compatibility.projects %}
   <li><a href="{{project.url}}">{{ project.path }}</a></li>
 {% endfor %}
</ul>

## 프로젝트 추가

Swift 소스 호환성 테스트 스위트는 커뮤니티 주도이므로, 수용 기준을 충족하는 오픈 소스 Swift 프로젝트 소유자가 프로젝트를 테스트 스위트에 포함하도록 제출하는 것을 권장합니다. 스위트에 추가된 프로젝트는 일반적인 소스 호환성 테스트로 활용되며, 향후 Swift 릴리스에서 의도치 않은 소스 호환성 문제로부터 더 강력하게 보호됩니다.

### 수용 기준

Swift 소스 호환성 테스트 스위트에 포함되려면 프로젝트가 다음 조건을 충족해야 합니다:

1. Linux, macOS 또는 iOS/tvOS/watchOS 기기를 대상으로 할 것
2. _Xcode_ 또는 _Swift Package Manager_ 프로젝트일 것 (Carthage와 CocoaPods는 현재 지원되지 않지만 향후 지원이 검토되고 있습니다)
3. Linux 또는 macOS에서 빌드를 지원할 것
4. 공개적으로 접근 가능한 Git 저장소에 있을 것
5. 현재 Swift GM 버전 호환성 모드에서 빌드되고 유닛 테스트를 통과하는 프로젝트 브랜치를 유지할 것
6. 적시에 문제를 해결할 의지가 있는 관리자가 있을 것
7. 최신 GM/Beta 버전의 _Xcode_ 및 *swiftpm*과 호환될 것
8. 스위트에 아직 포함되지 않은 가치를 추가할 것
9. 다음 허용 라이선스 중 하나로 라이선스될 것:
   - BSD
   - MIT
   - Apache License, version 2.0
   - Eclipse Public License
   - Mozilla Public License (MPL) 1.1
   - MPL 2.0
   - CDDL

참고: 지속적 통합에서의 Linux 호환성 테스트는 아직 제공되지 않지만, Linux 프로젝트는 현재 접수 중입니다.

### 프로젝트 추가하기

수용 기준을 충족하는 프로젝트를 스위트에 추가하려면, 다음 단계를 수행하세요:

1. 선택한 커밋에서 현재 Swift GM 버전에 대해 프로젝트가 성공적으로 빌드되는지 확인합니다.
2. [소스 호환성 스위트 저장소](https://github.com/swiftlang/swift-source-compat-suite)에 대한 Pull Request를 생성하여, **projects.json**에 테스트 스위트에 추가할 프로젝트 참조를 포함하도록 수정합니다.

프로젝트 인덱스는 Xcode 및/또는 Swift Package Manager 대상 액션을 포함하는 저장소 목록이 담긴 JSON 파일입니다.

새로운 Swift Package Manager 프로젝트를 추가하려면 다음 템플릿을 사용하세요:

```json
{
  "repository": "Git",
  "url": "https://github.com/example/project.git",
  "path": "project",
  "branch": "main",
  "maintainer": "email@example.com",
  "compatibility": {
    "3.0": {
      "commit": "195cd8cde2bb717242b3081f9c367ccd0a2f0121"
    }
  },
  "platforms": ["Darwin"],
  "actions": [
    {
      "action": "BuildSwiftPackage",
      "configuration": "release"
    },
    {
      "action": "TestSwiftPackage"
    }
  ]
}
```

`commit` 필드는 저장소를 고정할 커밋 해시를 지정합니다. 이 필드는 해당 커밋이 컴파일할 수 있는 Swift 버전을 지정하는 `compatibility` 필드 안에 있습니다. 서로 다른 Swift 버전과 호환되는 여러 커밋을 지정할 수 있습니다.

`platforms` 필드는 프로젝트를 빌드할 수 있는 플랫폼을 지정합니다. 현재 Linux와 Darwin을 지정할 수 있습니다.

테스트가 지원되지 않으면 테스트 액션 항목을 제거하세요.

새로운 Swift Xcode 워크스페이스를 추가하려면 다음 템플릿을 사용하세요:

```json
{
  "repository": "Git",
  "url": "https://github.com/example/project.git",
  "path": "project",
  "branch": "main",
  "maintainer": "email@example.com",
  "compatibility": {
    "3.0": {
      "commit": "195cd8cde2bb717242b3081f9c367ccd0a2f0121"
    }
  },
  "platforms": ["Darwin"],
  "actions": [
    {
      "action": "BuildXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project OSX",
      "destination": "platform=macOS",
      "configuration": "Release"
    },
    {
      "action": "BuildXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project iOS",
      "destination": "generic/platform=iOS",
      "configuration": "Release"
    },
    {
      "action": "BuildXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project tvOS",
      "destination": "generic/platform=tvOS",
      "configuration": "Release"
    },
    {
      "action": "BuildXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project watchOS",
      "destination": "generic/platform=watchOS",
      "configuration": "Release"
    },
    {
      "action": "TestXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project OSX",
      "destination": "platform=macOS"
    },
    {
      "action": "TestXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project iOS",
      "destination": "platform=iOS Simulator,name=iPhone 7"
    },
    {
      "action": "TestXcodeWorkspaceScheme",
      "workspace": "project.xcworkspace",
      "scheme": "project tvOS",
      "destination": "platform=tvOS Simulator,name=Apple TV 1080p"
    }
  ]
}
```

새로운 Swift Xcode 프로젝트를 추가하려면 다음 템플릿을 사용하세요:

```json
{
  "repository": "Git",
  "url": "https://github.com/example/project.git",
  "path": "project",
  "branch": "main",
  "maintainer": "email@example.com",
  "compatibility": {
    "3.0": {
      "commit": "195cd8cde2bb717242b3081f9c367ccd0a2f0121"
    }
  },
  "platforms": ["Darwin"],
  "actions": [
    {
      "action": "BuildXcodeProjectTarget",
      "project": "project.xcodeproj",
      "target": "project",
      "destination": "generic/platform=iOS",
      "configuration": "Release"
    }
  ]
}
```

프로젝트를 인덱스에 추가한 후, 지정된 Swift 버전에 대해 고정된 커밋에서 성공적으로 빌드되는지 확인하세요. 예시에서 커밋은 Xcode 8.0에 포함된 Swift 3.0과 호환되는 것으로 지정되어 있습니다.

```bash
# Select Xcode 8.0 GM
sudo xcode-select -s /Applications/Xcode.app
# Build project at pinned commit against selected Xcode
./check project-path-field
```

Linux에서는 Swift 3.0 릴리스 툴체인으로 빌드할 수 있습니다:

```bash
curl -O https://download.swift.org/swift-3.0-release/ubuntu1510/swift-3.0-RELEASE/swift-3.0-RELEASE-ubuntu15.10.tar.gz
tar xzvf swift-3.0-RELEASE-ubuntu15.10.tar.gz
./check project-path-field --swiftc swift-3.0-RELEASE-ubuntu15.10/usr/bin/swiftc
```

## 프로젝트 유지 관리

Swift가 프로젝트와의 소스 호환성을 깨는 변경 사항을 도입하면(예: 컴파일러의 잘못된 동작을 수정하는 버그 수정), 프로젝트 관리자는 알림을 받은 후 2주 이내에 프로젝트를 업데이트하고 업데이트된 커밋 해시로 새 Pull Request를 제출해야 합니다. 그렇지 않으면 유지 관리되지 않는 프로젝트는 프로젝트 인덱스에서 제거될 수 있습니다.

## Pull Request 테스트

Swift 소스 호환성 스위트에 대한 Pull Request 테스트는 Swift Pull Request에 `@swift-ci Please test source compatibility`를 댓글로 달아 실행할 수 있습니다.

## 프로젝트 빌드

로컬에서 지정된 Swift 컴파일러에 대해 모든 프로젝트를 빌드하려면, 아래와 같이 `runner.py` 유틸리티를 사용하세요.

```bash
./runner.py --swift-branch main --projects projects.json --swift-version 3 --include-actions 'action.startswith("Build")' --swiftc path/to/swiftc
```

`--include-repos` 플래그를 사용하여 특정 프로젝트를 빌드할 수 있습니다.

```bash
./runner.py --swift-branch main --projects projects.json --swift-version 3 --include-actions 'action.startswith("Build")' --include-repos 'path == "Alamofire"' --swiftc path/to/swiftc
```

기본적으로 빌드 출력은 현재 작업 디렉터리의 액션별 `.log` 파일로 리다이렉트됩니다. 빌드 결과를 표준 출력으로 출력하려면 `--verbose` 플래그를 사용하세요.
