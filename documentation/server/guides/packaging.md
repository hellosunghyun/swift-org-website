---
redirect_from: 'server/guides/packaging'
layout: page
title: 배포를 위한 애플리케이션 패키징
---

애플리케이션이 프로덕션용으로 빌드된 후에도 서버에 배포하려면 패키징이 필요합니다. Swift 애플리케이션을 배포용으로 패키징하는 여러 전략이 있습니다.

## Docker

요즘 애플리케이션을 패키징하는 가장 인기 있는 방법 중 하나는 [Docker](https://www.docker.com)와 같은 컨테이너 기술을 사용하는 것입니다.

Docker 도구를 사용하면 애플리케이션을 Docker 이미지로 빌드하고 패키징한 후 Docker 저장소에 게시하고, 나중에 서버에서 직접 실행하거나 [Kubernetes](https://kubernetes.io)와 같은 Docker 배포를 지원하는 플랫폼에서 실행할 수 있습니다. AWS, GCP, Azure, IBM 등 많은 퍼블릭 클라우드 제공업체가 이러한 배포 방식을 권장합니다.

다음은 CentOS 기반으로 애플리케이션을 빌드하고 패키징하는 `Dockerfile` 예제입니다:

```Dockerfile
#------- build -------
FROM swift:centos8 as builder

# set up the workspace
RUN mkdir /workspace
WORKDIR /workspace

# copy the source to the docker image
COPY . /workspace

RUN swift build -c release --static-swift-stdlib

#------- package -------
FROM centos
# copy executables
COPY --from=builder /workspace/.build/release/<executable-name> /

# set the entry point (application name)
CMD ["<executable-name>"]
```

`Dockerfile`에서 로컬 Docker 이미지를 생성하려면 애플리케이션 소스 위치에서 `docker build` 명령을 사용합니다:

```bash
$ docker build . -t <my-app>:<my-app-version>
```

로컬 이미지를 테스트하려면 `docker run` 명령을 사용합니다:

```bash
$ docker run <my-app>:<my-app-version>
```

마지막으로 `docker push` 명령을 사용하여 원하는 Docker 저장소에 애플리케이션의 Docker 이미지를 게시합니다:

```bash
$ docker tag <my-app>:<my-app-version> <docker-hub-user>/<my-app>:<my-app-version>
$ docker push <docker-hub-user>/<my-app>:<my-app-version>
```

이 시점에서 애플리케이션의 Docker 이미지는 서버 호스트(Docker가 실행 중이어야 함) 또는 Docker 배포를 지원하는 플랫폼에 배포할 준비가 된 것입니다.

Docker에 대한 보다 완전한 정보는 [Docker 공식 문서](https://docs.docker.com/engine/reference/commandline/)를 참고하세요.

### Distroless

[Distroless](https://github.com/GoogleContainerTools/distroless)는 애플리케이션과 런타임 의존성만 포함하는 최소한의 이미지를 만들려는 Google 프로젝트입니다. 패키지 관리자, 셸 또는 표준 Linux 배포판에서 기대할 수 있는 다른 프로그램이 포함되지 않습니다.

Distroless는 Docker를 지원하고 Debian을 기반으로 하므로, Swift 애플리케이션을 패키징하는 방법은 위의 Docker 프로세스와 상당히 유사합니다. 다음은 distroless의 C++ 기본 이미지 위에 애플리케이션을 빌드하고 패키징하는 `Dockerfile` 예제입니다:

```Dockerfile
#------- build -------
# Building using Ubuntu Bionic since its compatible with Debian runtime
FROM swift:bionic as builder

# set up the workspace
RUN mkdir /workspace
WORKDIR /workspace

# copy the source to the docker image
COPY . /workspace

RUN swift build -c release --static-swift-stdlib

#------- package -------
# Running on distroless C++ since it includes
# all(*) the runtime dependencies Swift programs need
FROM gcr.io/distroless/cc-debian10
# copy executables
COPY --from=builder /workspace/.build/release/<executable-name> /

# set the entry point (application name)
CMD ["<executable-name>"]
```

위 예제에서는 `gcr.io/distroless/cc-debian10`을 런타임 이미지로 사용합니다. 이 이미지는 `FoundationNetworking`이나 `FoundationXML`을 사용하지 않는 Swift 프로그램에서 동작합니다. 보다 완전한 지원을 위해 커뮤니티에서 `FoundationNetworking`과 `FoundationXML`에 각각 필요한 `libcurl`과 `libxml`을 포함하는 Swift 기본 이미지를 distroless에 PR로 제출할 수 있습니다.

## 아카이브 (Tarball, ZIP 파일 등)

Mac이나 Windows에서 Linux용 Swift 크로스 컴파일은 아직 지원되지 않으므로, Linux에서 실행할 애플리케이션을 컴파일하려면 Docker와 같은 가상화 기술을 사용해야 합니다.

그렇다고 해서 애플리케이션을 배포하기 위해 반드시 Docker 이미지로 패키징해야 하는 것은 아닙니다. Docker 이미지를 사용한 배포가 편리하고 인기 있지만, tarball이나 ZIP 파일과 같은 간단하고 가벼운 아카이브 형식으로 패키징한 후 서버에 업로드하여 추출하고 실행할 수도 있습니다.

다음은 Docker와 `tar`를 사용하여 Ubuntu 서버 배포용으로 애플리케이션을 빌드하고 패키징하는 예제입니다:

먼저 애플리케이션 소스 위치에서 `docker run` 명령을 사용하여 빌드합니다:

```bash
$ docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  swift:bionic \
  /bin/bash -cl "swift build -c release --static-swift-stdlib"
```

소스 디렉터리를 바인드 마운트하여 빌드 아티팩트가 로컬 드라이브에 작성되고, 이후에 패키징할 수 있도록 합니다.

다음으로 애플리케이션의 실행 파일이 포함된 스테이징 영역을 만들 수 있습니다:

```bash
$ docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  swift:bionic  \
  /bin/bash -cl ' \
     rm -rf .build/install && mkdir -p .build/install && \
     cp -P .build/release/<executable-name> .build/install/'
```

이 명령은 위의 빌드 명령과 결합할 수 있지만, 예제의 가독성을 위해 분리했습니다.

마지막으로 스테이징 디렉터리에서 tarball을 생성합니다:

```bash
$ tar cvzf <my-app>-<my-app-version>.tar.gz -C .build/install .
```

tarball의 무결성을 테스트하려면 디렉터리에 추출한 후 Docker 런타임 컨테이너에서 애플리케이션을 실행합니다:

```bash
$ cd <extracted directory>
$ docker run -v "$PWD:/app" -w /app bionic ./<executable-name>
```

대상 서버에 애플리케이션의 tarball을 배포하는 것은 `scp`와 같은 유틸리티를 사용하거나, 보다 정교한 환경에서는 `chef`, `puppet`, `ansible` 등의 구성 관리 시스템을 사용하여 수행할 수 있습니다.

## 소스 배포

Ruby나 Javascript와 같은 동적 언어에서 인기 있는 또 다른 배포 기법은 서버에 소스를 배포한 후 서버에서 직접 컴파일하는 것입니다.

서버에서 직접 Swift 애플리케이션을 빌드하려면 올바른 Swift 툴체인이 설치되어 있어야 합니다. [Swift.org](/download/#linux)에서 다양한 Linux 배포판용 툴체인을 게시하고 있으니, 서버의 Linux 버전과 원하는 Swift 버전에 맞는 것을 사용하세요.

이 방식의 주요 장점은 간편하다는 것입니다. 추가적인 장점은 서버에 전체 툴체인(예: 디버거)이 있어 서버에서 "실시간으로" 문제를 해결하는 데 도움이 된다는 것입니다.

이 방식의 주요 단점은 서버에 전체 툴체인(예: 컴파일러)이 있어 정교한 공격자가 코드를 실행할 수 있는 방법을 찾을 수 있다는 것입니다. 또한 민감할 수 있는 소스 코드에 접근할 가능성도 있습니다. 비공개 또는 보호된 저장소에서 애플리케이션 코드를 클론해야 하는 경우 서버에 자격 증명 접근 권한이 필요하여 추가적인 공격 표면이 생깁니다.

대부분의 경우, 이러한 보안 문제로 인해 소스 배포는 권장되지 않습니다.

## 정적 링킹과 Curl/XML

**참고:** `-static-stdlib`으로 컴파일하고 FoundationNetworking과 함께 Curl을 사용하거나 FoundationXML과 함께 XML을 사용하는 경우, 대상 시스템에 libcurl 및/또는 libxml2가 설치되어 있어야 정상 작동합니다.
