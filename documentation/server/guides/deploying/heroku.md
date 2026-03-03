---
redirect_from: 'server/guides/deploying/heruko'
layout: page
title: Heroku에 배포하기
---

Heroku는 인기 있는 올인원 호스팅 솔루션입니다.

Heroku 애플리케이션을 위해 가상 운영 체제([스택](#stack-selection))와 사전 설치된 소프트웨어 패키지([빌드팩](#buildpack-selection))만 선택하면 됩니다. Heroku의 CLI 도구를 설치한 후 표준 git 명령을 사용하여 코드를 Heroku에 푸시하면 소스에서 빌드되어 배포됩니다.

자세한 내용은 [heroku.com](https://heroku.com/)에서 확인할 수 있습니다.

## 가입

Heroku 계정이 필요합니다. 계정이 없다면 [여기](https://signup.heroku.com/)에서 가입하세요.

## CLI 설정

Heroku CLI 도구가 설치되어 있는지 확인하세요.

### Homebrew 설치

```bash
brew tap heroku/brew && brew install heroku
```

### 다른 설치 방법

다른 설치 방법은 [여기](https://devcenter.heroku.com/articles/heroku-cli#install-the-heroku-cli)를 참조하세요.

### 로그인

CLI를 설치한 후 다음 명령으로 로그인합니다:

```bash
heroku login
```

…안내에 따라 진행하세요.

## 애플리케이션 설정

[Heroku 대시보드](https://dashboard.heroku.com/)를 방문하여 계정에 접근하고, 오른쪽 상단 드롭다운에서 새 애플리케이션을 생성합니다. Heroku가 리전과 애플리케이션 이름 등 몇 가지를 물어보면 안내에 따라 진행하세요.

### 예제 프로젝트 생성

이 가이드에서는 Swift NIO의 예제 HTTP 서버를 호스팅하겠습니다 — 이 개념을 자신의 프로젝트에 적용할 수 있습니다. NIO를 클론하는 것부터 시작합니다:

```bash
git clone https://github.com/apple/swift-nio
```

새로 클론한 디렉토리를 작업 디렉토리로 설정합니다:

```bash
cd swift-nio
```

기본적으로 Heroku는 **main** 브랜치를 배포합니다. 푸시하기 전에 모든 변경 사항이 이 브랜치에 커밋되어 있는지 항상 확인하세요.

#### Heroku 연결

앱을 Heroku에 연결합니다(_앱 이름으로 교체_):

```bash
heroku git:remote -a your-apps-name-here
```

### 스택 선택

2023년 12월 기준 Heroku의 기본 스택은 Heroku 22입니다:

```bash
heroku stack:set heroku-22 -a your-apps-name-here
```

현재 사용 가능한 스택 목록은 [여기](https://devcenter.heroku.com/articles/stack)에서 확인할 수 있습니다.

### 빌드팩 선택

Heroku에 Swift를 다루는 방법을 알려주기 위해 빌드팩을 설정합니다. [Vapor Community 빌드팩](https://github.com/vapor-community/heroku-buildpack)은 _모든_ Swift 프로젝트에 적합한 빌드팩입니다. Vapor를 설치하지 않으며, Vapor 전용 설정도 없습니다.

```bash
heroku buildpacks:set vapor/vapor
```

### Swift 버전 선택

추가한 빌드팩은 프로젝트 루트 디렉토리의 **.swift-version** 파일을 확인하여 사용할 Swift 버전을 결정합니다.

```bash
echo "5.9" > .swift-version
```

이 명령은 **.swift-version** 파일을 `5.9`라는 내용으로 생성합니다.

새 Swift 버전이 출시되면 최신 버전을 도입하기 전에 빌드팩을 업데이트해야 합니다.

### Procfile 생성

Heroku는 **Procfile**을 사용하여 앱을 실행하는 방법을 알아냅니다. 여기에는 실행 파일 이름과 필요한 인자가 포함됩니다. 아래에서 `$PORT`를 볼 수 있는데, 이를 통해 Heroku가 앱을 시작할 때 특정 포트를 할당할 수 있습니다.

```bash
web: NIOHTTP1Server 0.0.0.0 $PORT
```

터미널에서 이 명령으로 파일을 설정할 수 있습니다:

```bash
echo "web: NIOHTTP1Server 0.0.0.0 $PORT" > Procfile
```

이 파일의 내용은 서버 프레임워크에 따라 다를 수 있습니다. Vapor 앱의 경우 기본 Procfile 내용은 다음과 같습니다:

```bash
web: Run serve --env production --hostname 0.0.0.0 --port $PORT
```

### 마무리

`.swift-version`과 `Procfile` 파일을 추가했으니, 배포에 포함되도록 `main`에 커밋되어 있는지 확인하세요:

```bash
git add .swift-version Procfile
git commit -am "Add Swift version file and Procfile"
```

## Heroku에 배포

배포할 준비가 되면 터미널에서 다음을 실행합니다:

```bash
git push heroku main
```

Heroku가 모든 의존성을 포함하여 프로젝트를 처음부터 빌드하고 검증 및 배포하므로 일반 git 작업보다 상당히 오래 걸립니다.

자세한 내용은 [여기](https://devcenter.heroku.com/articles/git#deploy-your-code)에서 확인할 수 있습니다.
