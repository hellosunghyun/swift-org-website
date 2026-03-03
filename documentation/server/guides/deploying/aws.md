---
redirect_from: 'server/guides/deploying/aws'
layout: page
title: Amazon Linux 2에서 AWS에 배포하기
---

이 가이드에서는 Amazon Linux 2를 실행하는 AWS 인스턴스를 시작하고 Swift를 실행하도록 구성하는 방법을 설명합니다. 여기서는 콘솔을 통한 단계별 접근 방식을 사용합니다. 이 방법은 학습에 좋지만, 좀 더 성숙한 접근 방식으로는 AWS CloudFormation과 같은 Infrastructure as Code 도구를 사용하고, Auto Scaling Groups와 같은 자동화 도구로 인스턴스를 생성·관리하는 것을 권장합니다. 이러한 도구를 활용한 접근 방식은 다음 블로그 글을 참고하세요: https://aws.amazon.com/blogs/opensource/continuous-delivery-with-server-side-swift-on-amazon-linux-2/

## AWS 인스턴스 시작

Service 메뉴에서 EC2 서비스를 선택합니다.

![EC2 서비스 선택](/assets/images/server-guides/aws/services.png)

"Instances" 메뉴에서 "Instances"를 클릭합니다.

![Instances 선택](/assets/images/server-guides/aws/ec2.png)

화면 상단 또는 해당 리전에서 처음 인스턴스를 생성하는 경우 화면 중앙에 있는 "Launch Instance"를 클릭합니다.

![인스턴스 시작](/assets/images/server-guides/aws/launch-0.png)

Amazon Machine Image(AMI)를 선택합니다. 이 가이드에서는 Amazon Linux 2를 사용하므로 해당 AMI 유형을 선택합니다.

![AMI 선택](/assets/images/server-guides/aws/launch-1.png)

인스턴스 유형을 선택합니다. 큰 인스턴스 유형일수록 메모리와 CPU가 많지만 비용이 더 높습니다. 실험 목적으로는 작은 인스턴스 유형으로도 충분합니다. 여기서는 `t2.micro` 인스턴스 유형을 선택했습니다.

![인스턴스 유형 선택](/assets/images/server-guides/aws/launch-2.png)

인스턴스 세부 정보를 구성합니다. 인터넷에서 직접 이 인스턴스에 접근하려면, 선택한 서브넷이 퍼블릭 IP를 자동 할당하는지 확인하세요. VPC에 인터넷 연결이 가능해야 하며, 이를 위해 Internet Gateway(IGW)와 올바른 네트워킹 규칙이 필요하지만 기본 VPC에는 이미 설정되어 있습니다. 프라이빗(인터넷 접근 불가) VPC에 이 인스턴스를 설정하려면 배스천 호스트, AWS Systems Manager Session Manager 또는 기타 연결 메커니즘을 설정해야 합니다.

![인스턴스 세부 정보 선택](/assets/images/server-guides/aws/launch-3.png)

스토리지를 추가합니다. AWS EC2 시작 마법사에서 기본 스토리지를 제안합니다. 테스트 목적으로는 이 기본값이면 충분하지만, 더 많은 스토리지나 다른 스토리지 성능 요구사항이 있다면 여기서 크기와 볼륨 유형을 변경할 수 있습니다.

![인스턴스 스토리지 선택](/assets/images/server-guides/aws/launch-4.png)

태그를 추가합니다. 나중에 이 서버를 올바르게 식별할 수 있도록 필요한 만큼 태그를 추가하는 것이 좋습니다. 특히 서버가 많을 경우 어떤 서버가 어떤 목적으로 사용되었는지 기억하기 어려울 수 있습니다. 최소한 기억하기 쉬운 `Name` 태그를 추가하세요.

![태그 추가](/assets/images/server-guides/aws/launch-5.png)

보안 그룹을 구성합니다. 보안 그룹은 인스턴스에 허용되는 트래픽을 제한하는 상태 저장 방화벽입니다. 가능한 한 제한적으로 구성하는 것이 좋습니다. 여기서는 포트 22(ssh)의 트래픽만 허용하도록 구성합니다. 소스도 제한하는 것이 좋습니다. 현재 워크스테이션의 IP로 제한하려면 "Source" 드롭다운에서 "My IP"를 선택하세요.

![보안 그룹 구성](/assets/images/server-guides/aws/launch-6.png)

인스턴스를 시작합니다. "Launch"를 클릭하고 인스턴스에 연결할 때 사용할 키 페어를 선택합니다. 이전에 사용한 키 페어가 있다면 "Choose an existing key pair"를 선택하여 재사용할 수 있습니다. 그렇지 않으면 "Create a new key pair"를 선택하여 새 키 페어를 생성할 수 있습니다.

![인스턴스 시작](/assets/images/server-guides/aws/launch-7.png)

인스턴스가 시작될 때까지 기다립니다. 준비가 되면 "Instance state"에 "running"으로, "Status Checks"에 "2/2 checks pass"로 표시됩니다. 인스턴스를 클릭하여 창 하단에서 세부 정보를 확인하고 "IPv4 Public IP"를 찾으세요.

![인스턴스 시작 대기 및 세부 정보 확인](/assets/images/server-guides/aws/ec2-list.png)

인스턴스에 연결합니다. 시작 단계에서 사용하거나 생성한 키 페어와 이전 단계의 IP를 사용하여 ssh를 실행합니다. 이후 단계에서 동일한 키로 두 번째 인스턴스에 연결할 수 있도록 ssh에 `-A` 옵션을 사용하세요.

![인스턴스에 연결](/assets/images/server-guides/aws/ssh-0.png)

바이너리를 컴파일하는 두 가지 방법이 있습니다: 인스턴스에서 직접 컴파일하거나 Docker를 사용하는 것입니다. 두 가지 방법을 모두 살펴보겠습니다.

## 인스턴스에서 컴파일

인스턴스에서 코드를 컴파일하는 두 가지 대안적 방법이 있습니다:

- [툴체인을 직접 다운로드하여 인스턴스에서 컴파일하기](#다운로드한-툴체인으로-컴파일)
- [Docker를 사용하여 Docker 컨테이너 내에서 컴파일하기](#docker로-컴파일)

### 다운로드한 툴체인으로 컴파일

SSH 터미널에서 다음 명령을 실행합니다. Swift 툴체인의 더 최신 버전이 있을 수 있습니다. Amazon Linux 2용 최신 툴체인 URL은 [https://swift.org/download/#releases](/download/#releasess)에서 확인하세요.

```
SwiftToolchainUrl="https://swift.org/builds/swift-5.4.1-release/amazonlinux2/swift-5.4.1-RELEASE/swift-5.4.1-RELEASE-amazonlinux2.tar.gz"
sudo yum install ruby binutils gcc git glibc-static gzip libbsd libcurl libedit libicu libsqlite libstdc++-static libuuid libxml2 tar tzdata ruby -y
cd $(mktemp -d)
wget ${SwiftToolchainUrl} -O swift.tar.gz
gunzip < swift.tar.gz | sudo tar -C / -xv --strip-components 1
```

마지막으로 Swift REPL을 실행하여 Swift가 올바르게 설치되었는지 확인합니다: `swift`.

![REPL 실행](/assets/images/server-guides/aws/repl.png)

이제 테스트 애플리케이션을 다운로드하고 빌드해 보겠습니다. Swift 툴체인이 설치되지 않은 다른 서버에 배포할 수 있도록 `--static-swift-stdlib` 옵션을 사용합니다. 이 예제에서는 SwiftNIO의 [예제 HTTP 서버](https://github.com/apple/swift-nio/tree/master/Sources/NIOHTTP1Server)를 배포하지만, 자체 프로젝트로 테스트할 수도 있습니다.

```
git clone https://github.com/apple/swift-nio.git
cd swift-nio
swift build -v --static-swift-stdlib -c release
```

## Docker로 컴파일

인스턴스에 Docker와 git이 설치되어 있는지 확인합니다:

```
sudo yum install docker git
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
```

Docker를 사용하려면 로그아웃 후 다시 로그인해야 할 수 있습니다. `docker ps`를 실행하여 오류 없이 실행되는지 확인하세요.

SwiftNIO의 [예제 HTTP 서버](https://github.com/apple/swift-nio/tree/master/Sources/NIOHTTP1Server)를 다운로드하고 컴파일합니다:

```
docker run --rm  -v "$PWD:/workspace"  -w /workspace swift:5.4-amazonlinux2   /bin/bash -cl ' \
     swift build -v --static-swift-stdlib -c release
```

## 바이너리 테스트

위와 동일한 단계를 사용하여 두 번째 인스턴스를 시작합니다(위의 bash 명령은 실행하지 마세요!). 반드시 동일한 SSH 키 페어를 사용하세요.

AWS 관리 콘솔에서 EC2 서비스로 이동하여 방금 시작한 인스턴스를 찾습니다. 인스턴스를 클릭하여 세부 정보를 확인하고 내부 IP를 찾습니다. 이 예제에서 내부 IP는 `172.31.3.29`입니다.

원래 빌드 인스턴스에서 새 서버 인스턴스로 바이너리를 복사합니다:
`scp .build/release/NIOHTTP1Server ec2-user@172.31.3.29`

이제 새 인스턴스에 연결합니다:
`ssh ec2-user@172.31.3.29`

새 인스턴스에서 Swift 바이너리를 테스트합니다:

```
NIOHTTP1Server localhost 8080 &
curl localhost:8080
```

여기서부터는 Swift 활용 방법에 따라 무한한 가능성이 열립니다. 웹 서비스를 실행하려면 보안 그룹에서 올바른 포트와 올바른 소스를 열어야 합니다. Swift 테스트가 끝나면 불필요한 컴퓨팅 비용을 피하기 위해 인스턴스를 종료하세요. EC2 대시보드에서 두 인스턴스를 모두 선택하고 메뉴에서 "Actions"를 선택한 후 "Instance state"를 선택하고 마지막으로 "terminate"를 선택합니다.

![인스턴스 종료](/assets/images/server-guides/aws/terminate.png)
