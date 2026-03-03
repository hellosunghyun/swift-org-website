---
redirect_from: 'server/guides/deploying/ubuntu'
layout: page
title: Ubuntu에 배포하기
---

Ubuntu 가상 머신이 준비되면 Swift 앱을 배포할 수 있습니다. 이 가이드에서는 `swift`라는 이름의 비루트 사용자로 새로 설치된 환경을 가정합니다. 또한 `root`와 `swift` 모두 SSH를 통해 접근 가능해야 합니다. 설정에 대한 자세한 내용은 플랫폼 가이드를 참고하세요:

- [DigitalOcean](/server/guides/deploying/digital-ocean.html)

[패키징](/server/guides/packaging.html) 가이드에서는 사용 가능한 배포 옵션에 대한 개요를 제공합니다. 이 가이드에서는 Ubuntu에 맞게 각 배포 옵션을 단계별로 안내합니다. 이 예제에서는 SwiftNIO의 [예제 HTTP 서버](https://github.com/apple/swift-nio/tree/master/Sources/NIOHTTP1Server)를 배포하지만, 자체 프로젝트로 테스트할 수도 있습니다.

- [바이너리 배포](#바이너리-배포)
- [소스 배포](#소스-배포)

## 바이너리 배포

이 섹션에서는 앱을 로컬에서 빌드하고 바이너리만 배포하는 방법을 보여줍니다.

### 바이너리 빌드

첫 번째 단계는 앱을 로컬에서 빌드하는 것입니다. 가장 쉬운 방법은 Docker를 사용하는 것입니다. 이 예제에서는 SwiftNIO의 데모 HTTP 서버를 배포합니다. 먼저 저장소를 클론합니다.

```sh
git clone https://github.com/apple/swift-nio.git
cd swift-nio
```

프로젝트 폴더에 들어간 후 다음 명령을 사용하여 Docker를 통해 앱을 빌드하고 모든 빌드 아티팩트를 `.build/install`에 복사합니다. 이 예제에서는 Ubuntu 18.04에 배포하므로 `-bionic` Docker 이미지를 사용하여 빌드합니다.

```sh
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  swift:5.7-bionic  \
  /bin/bash -cl ' \
     swift build && \
     rm -rf .build/install && mkdir -p .build/install && \
     cp -P .build/debug/NIOHTTP1Server .build/install/ && \
     cp -P /usr/lib/swift/linux/lib*so* .build/install/'
```

> 팁: 프로덕션용으로 이 프로젝트를 빌드하는 경우 `swift build -c release`를 사용하세요. 자세한 내용은 [프로덕션 빌드](/server/guides/building.html#building-for-production)를 참고하세요.

Swift의 공유 라이브러리가 포함되어 있다는 점에 유의하세요. Linux에서는 Swift가 ABI 안정적이지 않으므로 이것이 중요합니다. Swift 프로그램은 컴파일에 사용된 공유 라이브러리와 함께 실행해야 합니다.

프로젝트가 빌드된 후 다음 명령을 사용하여 서버로 쉽게 전송할 수 있는 아카이브를 생성합니다.

```sh
tar cvzf hello-world.tar.gz -C .build/install .
```

다음으로 `scp`를 사용하여 배포 서버의 홈 폴더에 아카이브를 복사합니다.

```sh
scp hello-world.tar.gz swift@<server_ip>:~/
```

복사가 완료되면 배포 서버에 로그인합니다.

```sh
ssh swift@<server_ip>
```

앱 바이너리를 보관할 새 폴더를 만들고 아카이브를 압축 해제합니다.

```sh
mkdir hello-world
tar -xvf hello-world.tar.gz -C hello-world
```

이제 실행 파일을 시작할 수 있습니다. 원하는 IP 주소와 포트를 지정합니다. 포트 `80`에 바인딩하려면 sudo가 필요하므로 대신 `8080`을 사용합니다.

[TODO]: <> (Link to Nginx guide once available for serving on port 80)

```sh
./hello-world/NIOHTTP1Server <server_ip> 8080
```

앱에서 Foundation을 사용하는 경우 `libxml`이나 `tzdata`와 같은 추가 시스템 라이브러리를 설치해야 할 수 있습니다. Swift의 슬림 Docker 이미지에서 설치하는 시스템 의존성은 좋은 [참고 자료](https://github.com/swiftlang/swift-docker/blob/master/5.2/ubuntu/18.04/slim/Dockerfile)입니다.

마지막으로 브라우저나 로컬 터미널을 통해 서버의 IP에 접속하면 응답을 확인할 수 있습니다.

```
$ curl http://<server_ip>:8080
Hello world!
```

`CTRL+C`를 눌러 서버를 종료합니다.

Ubuntu에서 Swift 서버 앱 실행을 성공적으로 완료했습니다!

## 소스 배포

이 섹션에서는 배포 서버에서 직접 프로젝트를 빌드하고 실행하는 방법을 보여줍니다.

## Swift 설치

새 Ubuntu 서버를 만들었으므로 이제 Swift를 설치할 수 있습니다. 이 작업은 `root`(또는 `sudo` 접근 권한이 있는 별도 사용자)로 로그인해야 합니다.

```sh
ssh root@<server_ip>
```

### Swift 의존성

Swift에 필요한 의존성을 설치합니다.

```sh
sudo apt update
sudo apt install clang libicu-dev build-essential pkg-config
```

### 툴체인 다운로드

이 가이드에서는 Swift 5.2를 설치합니다. 최신 릴리스 링크는 [Swift 다운로드](/download/#releases) 페이지를 방문하세요. Ubuntu 18.04용 다운로드 링크를 복사합니다.

![Swift 다운로드](/assets/images/server-guides/swift-download-ubuntu-18-copy-link.png)

Swift 툴체인을 다운로드하고 압축을 해제합니다.

```sh
wget https://swift.org/builds/swift-5.2-release/ubuntu1804/swift-5.2-RELEASE/swift-5.2-RELEASE-ubuntu18.04.tar.gz
tar xzf swift-5.2-RELEASE-ubuntu18.04.tar.gz
```

> 참고: Swift의 [다운로드 사용법](/download/#using-downloads) 가이드에는 PGP 서명을 사용한 다운로드 검증 방법이 포함되어 있습니다.

### 툴체인 설치

Swift를 접근하기 쉬운 위치로 이동합니다. 이 가이드에서는 `/swift`를 사용하며 각 컴파일러 버전을 하위 폴더에 배치합니다.

```sh
sudo mkdir /swift
sudo mv swift-5.2-RELEASE-ubuntu18.04 /swift/5.2.0
```

`swift`와 `root`가 실행할 수 있도록 Swift를 `/usr/bin`에 추가합니다.

```sh
sudo ln -s /swift/5.2.0/usr/bin/swift /usr/bin/swift
```

Swift가 올바르게 설치되었는지 확인합니다.

```sh
swift --version
```

## 프로젝트 설정

Swift가 설치되었으니 프로젝트를 클론하고 컴파일해 보겠습니다. 이 예제에서는 SwiftNIO의 [예제 HTTP 서버](https://github.com/apple/swift-nio/tree/master/Sources/NIOHTTP1Server)를 사용합니다.

먼저 SwiftNIO의 시스템 의존성을 설치합니다.

```sh
sudo apt-get install zlib1g-dev
```

### 클론 및 빌드

설치가 완료되었으므로 애플리케이션을 빌드하고 실행하기 위해 비루트 사용자로 전환할 수 있습니다.

```sh
su swift
cd ~
```

프로젝트를 클론한 후 `swift build`를 사용하여 컴파일합니다.

```sh
git clone https://github.com/apple/swift-nio.git
cd swift-nio
swift build
```

> 팁: 프로덕션용으로 이 프로젝트를 빌드하는 경우 `swift build -c release`를 사용하세요. 자세한 내용은 [프로덕션 빌드](/server/guides/building.html#building-for-production)를 참고하세요.

### 실행

프로젝트 컴파일이 완료되면 서버의 IP와 포트 `8080`으로 실행합니다.

```sh
.build/debug/NIOHTTP1Server <server_ip> 8080
```

`swift build -c release`를 사용한 경우 다음을 실행해야 합니다:

```sh
.build/release/NIOHTTP1Server <server_ip> 8080
```

브라우저나 로컬 터미널을 통해 서버의 IP에 접속하면 응답을 확인할 수 있습니다.

```
$ curl http://<server_ip>:8080
Hello world!
```

`CTRL+C`를 눌러 서버를 종료합니다.

Ubuntu에서 Swift 서버 앱 실행을 성공적으로 완료했습니다!
