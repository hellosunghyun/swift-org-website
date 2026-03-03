## Docker를 사용한 설치

Swift 공식 Docker 이미지는 [hub.docker.com/\_/swift](https://hub.docker.com/_/swift/)에서 호스팅됩니다.

Swift Dockerfile은 [swift-docker](https://github.com/swiftlang/swift-docker) 저장소에 있습니다.

#### Docker 이미지 사용하기

0. [Docker Hub](https://hub.docker.com/_/swift/)에서 Docker 이미지를 가져옵니다:

   ```shell
   docker pull swift
   ```

1. `latest` 태그를 사용하여 컨테이너를 생성하고 연결합니다:

   ```shell
   docker run --privileged --interactive --tty \
   --name swift-latest swift:latest /bin/bash
   ```

2. `swift-latest` 컨테이너를 시작합니다:

   ```shell
   docker start swift-latest
   ```

3. `swift-latest` 컨테이너에 연결합니다:

   ```shell
   docker attach swift-latest
   ```
