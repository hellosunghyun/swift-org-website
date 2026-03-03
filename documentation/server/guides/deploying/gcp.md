---
redirect_from: 'server/guides/deploying/gcp'
layout: page
title: Google Cloud Platform(GCP)에 배포하기
---

이 가이드에서는 [Google Cloud Build](https://cloud.google.com/build)와
[Google Cloud Run](https://cloud.google.com/run)을 사용하여 서버리스
아키텍처에서 Swift 서버를 빌드하고 실행하는 방법을 설명합니다. Docker 이미지를 저장하기 위해
[Artifact Registry](https://cloud.google.com/artifact-registry/docs/docker/quickstart)를
사용합니다.

## Google Cloud Platform 설정

[GCP 시작하기](https://cloud.google.com/gcp/getting-started/)에서
자세한 내용을 확인할 수 있습니다. Swift 서버 애플리케이션을 실행하려면 다음이 필요합니다:

- [결제](https://console.cloud.google.com/billing) 활성화(신용카드 필요).
  새 계정을 생성하면 GCP에서 처음 90일 동안 사용할 수 있는 $300의
  무료 크레딧을 제공합니다. 새 계정이라면 이 가이드를 무료로 따라할 수 있습니다.
  이 가이드의 모든 내용은 GCP의 "무료 등급" 범위에 해당합니다(하루 120분 빌드 시간,
  월 200만 Cloud Run 요청
  [무료 등급 사용 한도](https://cloud.google.com/free/docs/gcp-free-tier#free-tier-usage-limits)).
- [Cloud Build API](https://console.cloud.google.com/apis/api/cloudbuild.googleapis.com/overview) 활성화
- [Cloud Run Admin API](https://console.cloud.google.com/apis/api/run.googleapis.com/overview) 활성화
- [Artifact Registry API](https://console.cloud.google.com/apis/api/artifactregistry.googleapis.com/overview) 활성화
- [Artifact Registry에서 저장소 생성](https://console.cloud.google.com/artifacts/create-repo)
  (형식: Docker, 리전: 원하는 리전)

## 프로젝트 요구사항

서버가 `127.0.0.1`이 아닌 `0.0.0.0`에서 수신 대기하는지 확인하고,
하드코딩된 값 대신 환경 변수 `$PORT`를 사용하는 것이 좋습니다.
워크플로가 통과하려면 두 개의 파일이 필수이며, 둘 다 프로젝트 루트에 있어야 합니다:

1. Dockerfile
2. cloudbuild.yaml

### `Dockerfile`

`docker build . -t test`와 `docker run -p 8080:8080 test`로
Dockerfile이 로컬에서 빌드되고 실행되는지 테스트해야 합니다.

*Dockerfile*은 [패키징 가이드](/server/guides/packaging.html#docker)와 동일합니다.
`<executable-name>`을 사용하는 `executableTarget`(예: "Server")으로 교체하세요:

```Dockerfile
#------- build -------
FROM swift:centos as builder

# set up the workspace
RUN mkdir /workspace
WORKDIR /workspace

# copy the source to the docker image
COPY . /workspace

RUN swift build -c release --static-swift-stdlib

#------- package -------
FROM centos:8
# copy executable
COPY --from=builder /workspace/.build/release/<executable-name> /

# set the entry point (application name)
CMD ["<executable-name>"]
```

### `cloudbuild.yaml`

`cloudbuild.yaml` 파일에는 클라우드에서 서버 이미지를 직접 빌드하고
빌드 성공 후 새 Cloud Run 인스턴스를 배포하는 일련의 단계가 포함되어 있습니다.
`${_VAR}`는 빌드 시점에 사용할 수 있는
["대체 변수"](https://cloud.google.com/cloud-build/docs/configuring-builds/substitute-variable-values)이며,
"deploy" 단계에서 런타임 환경에 전달할 수 있습니다.
[빌드 트리거](#배포)(5단계)를 구성할 때 변수를 설정합니다.

```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        docker pull ${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:latest || exit 0
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - build
      - -t
      - ${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:$SHORT_SHA
      - -t
      - ${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:latest
      - .
      - --cache-from
      - ${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:latest
  - name: 'gcr.io/cloud-builders/docker'
    args:
      [
        'push',
        '${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:$SHORT_SHA',
      ]
  - name: 'gcr.io/cloud-builders/gcloud'
    args:
      - run
      - deploy
      - swift-service
      - --image=${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:$SHORT_SHA
      - --port=8080
      - --region=${_REGION}
      - --memory=512Mi
      - --platform=managed
      - --allow-unauthenticated
      - --min-instances=0
      - --max-instances=5
images:
  - '${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:$SHORT_SHA'
  - '${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPOSITORY_NAME}/${_SERVICE_NAME}:latest'
timeout: 1800s
```

### 단계 상세 설명

1. Artifact Registry에서 최신 이미지를 풀링하여 캐시된 레이어를 가져옵니다
2. `$SHORT_SHA`와 `latest` 태그로 이미지를 빌드합니다
3. Artifact Registry에 이미지를 푸시합니다
4. Cloud Run에 이미지를 배포합니다

`images`는 레지스트리에 저장할 빌드 이미지를 지정합니다. 기본
`timeout`은 10분이므로 Swift 빌드를 위해 늘려야 합니다.
기본 포트로 `8080`을 사용하지만, 이 줄을 제거하고 서버가
`$PORT`에서 수신 대기하도록 하는 것이 좋습니다.

## 배포

![Cloud Build 트리거 설정 및 코드 저장소 연결 방법](/assets/images/server-guides/gcp-connect-repo.png)

모든 파일을 원격 저장소에 푸시합니다. Cloud Build는 현재 GitHub,
Bitbucket, GitLab을 지원합니다.
[Cloud Build 트리거](https://console.cloud.google.com/cloud-build/triggers)로
이동하여 "Create Trigger"를 클릭합니다:

1. 이름과 설명을 추가합니다
2. Event: "Push to a branch"가 활성화되어 있습니다
3. Source: "Connect New Repository"로 코드 제공자에 인증하고,
   Swift 서버 코드가 호스팅된 저장소를 추가합니다. 먼저
   [GitHub](https://cloud.google.com/build/docs/automating-builds/build-repos-from-github),
   [GitLab](https://cloud.google.com/build/docs/automating-builds/build-repos-from-gitlab)
   또는
   [Bitbucket](https://cloud.google.com/build/docs/automating-builds/build-repos-from-bitbucket-cloud)에서
   GCP 접근을 허용하도록 구성해야 합니다.
4. Configuration: "Cloud Build configuration file" / Location: Repository
5. Advanced:
   [대체 변수](https://cloud.google.com/cloud-build/docs/configuring-builds/substitute-variable-values):
   여기서 리전, 저장소 이름, 서비스 이름에 대한 변수를 설정해야 합니다.
   원하는 [리전](https://cloud.google.com/about/locations/)을 선택할 수 있습니다(예:
   `us-central1`). 모든 사용자 정의 변수는 밑줄로 시작해야 합니다
   (`_REGION`). `_REPOSITORY_NAME`과 `_SERVICE_NAME`은 자유롭게 지정할 수 있습니다.
   데이터베이스나 서드파티 서비스에 연결하기 위해 환경 변수를 사용하는 경우
   여기서 값을 설정할 수도 있습니다.
6. "Create"

새 서비스를 배포하기 전 마지막 단계로,
[Cloud Build 설정](https://console.cloud.google.com/cloud-build/settings)으로
이동하여 "Cloud Run"이 활성화되어 있는지 확인합니다. 이를 통해 Cloud Build에
Cloud Run 서비스를 배포하는 데 필요한 IAM 권한이 부여됩니다.

![Cloud Build 설정](/assets/images/server-guides/gcp-cloud-build-settings.png)

트리거 개요 페이지에서 새 "swift-service" 트리거를 확인할 수 있습니다.
오른쪽의 "RUN"을 클릭하여 `main` 브랜치에서 수동으로 트리거를 시작합니다.
간단한 Hummingbird 프로젝트의 경우 빌드에 약 7-8분이 소요됩니다.
Vapor는 표준/소형 빌드 머신에서 약 25분이 소요되며, 이 머신은 상당히
느립니다. Vapor Discord 커뮤니티의 "Jordane"은 배포 속도를 높이기 위해
`cloudbuild.yaml`에서
[`machineType: E2_HIGHCPU_8`을 사용할 것을 권장](https://discord.com/channels/431917998102675485/447893851374616576/915819735738888222)합니다:

```yaml
options:
  machineType: 'E2_HIGHCPU_8'
```

빌드가 성공하면 빌드 로그에서 서비스 URL을 확인할 수 있습니다:

![Cloud Run에 성공적으로 빌드 및 배포](/assets/images/server-guides/gcp-cloud-build.png)

Cloud Run으로 이동하여 서비스가 실행 중인 것을 확인할 수 있습니다:

![Cloud Run 개요](/assets/images/server-guides/gcp-cloud-run.png)

트리거는 `main`에 대한 모든 새 커밋을 배포합니다. 기능 중심 워크플로를 위해
Pull Request 트리거를 활성화할 수도 있습니다. Cloud Build는 블루/그린
빌드, 자동 스케일링 등 다양한 기능도 지원합니다.

이제 커스텀 도메인을 새 서비스에 연결하고 서비스를 시작할 수 있습니다.

## 정리

- Cloud Run 서비스를 삭제합니다
- Cloud Build 트리거를 삭제합니다
- Artifact Registry 저장소를 삭제합니다
