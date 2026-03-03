---
redirect_from: 'server/guides/deploying/aws-copilot-fargate-vapor-mongo'
layout: page
title: Fargate, Vapor, MongoDB Atlas로 AWS에 배포하기
---

이 가이드에서는 AWS에 서버사이드 Swift 워크로드를 배포하는 방법을 설명합니다. 이 워크로드는 할 일 목록을 추적하는 REST API입니다. [Vapor](https://vapor.codes/) 프레임워크를 사용하여 API 메서드를 프로그래밍합니다. 이 메서드는 [MongoDB Atlas](https://www.mongodb.com/atlas/database) 클라우드 데이터베이스에 데이터를 저장하고 검색합니다. Vapor 애플리케이션은 컨테이너화되어 [AWS Copilot](https://aws.github.io/copilot-cli/) 툴킷을 사용하여 AWS Fargate에 배포됩니다.

## 아키텍처

![아키텍처](/assets/images/server-guides/aws/aws-fargate-vapor-mongo.png)

- Amazon API Gateway가 API 요청을 수신합니다
- API Gateway가 AWS Cloud Map에서 관리하는 내부 DNS를 통해 AWS Fargate의 애플리케이션 컨테이너를 찾습니다
- API Gateway가 요청을 컨테이너로 전달합니다
- 컨테이너는 Vapor 프레임워크를 실행하며 항목을 GET 및 POST하는 메서드가 있습니다
- Vapor는 MongoDB가 관리하는 AWS 계정에서 실행되는 MongoDB Atlas 클라우드 데이터베이스에 항목을 저장하고 검색합니다

## 사전 요구사항

이 샘플 애플리케이션을 빌드하려면 다음이 필요합니다:

- [AWS 계정](https://console.aws.amazon.com/)
- [MongoDB Atlas 데이터베이스](https://www.mongodb.com/atlas/database)
- [AWS Copilot](https://aws.github.io/copilot-cli/) - AWS에서 컨테이너화된 워크로드를 생성하는 데 사용되는 명령줄 도구
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) - Swift 코드를 Docker 이미지로 컴파일하기 위해 필요
- [Vapor](https://vapor.codes/) - REST 서비스를 코딩하기 위해 필요
- [AWS Command Line Interface(AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) - CLI를 설치하고 AWS 계정의 자격 증명으로 [구성](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)합니다

## 1단계: 데이터베이스 생성

MongoDB Atlas가 처음이라면 이 [시작 가이드](https://www.mongodb.com/docs/atlas/getting-started/)를 따르세요. 다음 항목을 생성해야 합니다:

- Atlas 계정
- 클러스터
- 데이터베이스 사용자 이름 / 비밀번호
- 데이터베이스
- 컬렉션

후속 단계에서 이 항목들의 값을 제공하여 애플리케이션을 구성합니다.

## 2단계: 새 Vapor 프로젝트 초기화

프로젝트 폴더를 생성합니다.

```
mkdir todo-app && cd todo-app
```

*api*라는 이름으로 Vapor 프로젝트를 초기화합니다.

```
vapor new api -n
```

## 3단계: 프로젝트 의존성 추가

Vapor가 프로젝트 의존성을 위한 _Package.swift_ 파일을 초기화합니다. 프로젝트에는 추가 라이브러리 [MongoDBVapor](https://github.com/mongodb/mongodb-vapor)가 필요합니다. _Package.swift_ 파일의 프로젝트 및 타겟 의존성에 MongoDBVapor 라이브러리를 추가합니다.

업데이트된 파일은 다음과 같아야 합니다:

**api/Package.swift**

```swift
// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "api",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", .upToNextMajor(from: "4.7.0")),
        .package(url: "https://github.com/mongodb/mongodb-vapor", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "MongoDBVapor", package: "mongodb-vapor")
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
```

## 4단계: Dockerfile 업데이트

Swift 서버 코드를 Docker 이미지로 AWS Fargate에 배포합니다. Vapor가 애플리케이션을 위한 초기 Dockerfile을 생성합니다. 애플리케이션에는 이 Dockerfile에 몇 가지 수정이 필요합니다:

- [Amazon ECR Public Gallery](https://gallery.ecr.aws) 컨테이너 저장소에서 _build_ 및 _run_ 이미지를 풀링합니다
- 빌드 이미지에 *libssl-dev*를 설치합니다
- 실행 이미지에 *libxml2*와 *curl*을 설치합니다

Vapor가 생성한 Dockerfile의 내용을 다음 코드로 교체합니다:

**api/Dockerfile**

```Dockerfile
# ================================
# Build image
# ================================
FROM public.ecr.aws/docker/library/swift:5.6.2-focal as build

# Install OS updates
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -y install libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

# Build everything, with optimizations
RUN swift build -c release --static-swift-stdlib

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Run" ./

# Copy resources bundled by SwiftPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Run image
# ================================
FROM public.ecr.aws/ubuntu/ubuntu:focal

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      ca-certificates \
      tzdata \
      curl \
      libxml2 \
    && rm -r /var/lib/apt/lists/*

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder
COPY --from=build --chown=vapor:vapor /staging /app

# Ensure all further commands run as the vapor user
USER vapor:vapor

# Let Docker bind to port 8080
EXPOSE 8080

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
```

## 5단계: Vapor 소스 코드 업데이트

Vapor는 API를 코딩하는 데 필요한 샘플 파일도 생성합니다. 할 일 목록 API 메서드를 노출하고 MongoDB 데이터베이스와 상호 작용하는 코드로 이 파일들을 사용자 정의해야 합니다.

_configure.swift_ 파일은 MongoDB 데이터베이스에 대한 애플리케이션 전체 연결 풀을 초기화합니다. 런타임에 환경 변수에서 MongoDB 데이터베이스에 대한 연결 문자열을 검색합니다.

파일 내용을 다음 코드로 교체합니다:

**api/Sources/App/configure.swift**

```swift
import MongoDBVapor
import Vapor

public func configure(_ app: Application) throws {

    let MONGODB_URI = Environment.get("MONGODB_URI") ?? ""

    try app.mongoDB.configure(MONGODB_URI)

    ContentConfiguration.global.use(encoder: ExtendedJSONEncoder(), for: .json)
    ContentConfiguration.global.use(decoder: ExtendedJSONDecoder(), for: .json)

    try routes(app)
}
```

_routes.swift_ 파일은 API의 메서드를 정의합니다. 새 항목을 삽입하는 _POST Item_ 메서드와 기존의 모든 항목 목록을 검색하는 _GET Items_ 메서드가 포함됩니다. 각 섹션에서 일어나는 일을 이해하려면 코드의 주석을 참고하세요.

파일 내용을 다음 코드로 교체합니다:

**api/Sources/App/routes.swift**

```swift
import Vapor
import MongoDBVapor

// define the structure of a ToDoItem
struct ToDoItem: Content {
    var _id: BSONObjectID?
    let name: String
    var createdOn: Date?
}

// import the MongoDB database and collection names from environment variables
let MONGODB_DATABASE = Environment.get("MONGODB_DATABASE") ?? ""
let MONGODB_COLLECTION = Environment.get("MONGODB_COLLECTION") ?? ""

// define an extension to the Vapor Request object to interact with the database and collection
extension Request {

    var todoCollection: MongoCollection<ToDoItem> {
        self.application.mongoDB.client.db(MONGODB_DATABASE).collection(MONGODB_COLLECTION, withType: ToDoItem.self)
    }
}

// define the api routes
func routes(_ app: Application) throws {

    // an base level route used for container healthchecks
    app.get { req in
        return "OK"
    }

    // GET items returns a JSON array of all items in the database
    app.get("items") { req async throws -> [ToDoItem] in
        try await req.todoCollection.find().toArray()
    }

    // POST item inserts a new item into the database and returns the item as JSON
    app.post("item") { req async throws -> ToDoItem in

        var item = try req.content.decode(ToDoItem.self)
        item.createdOn = Date()

        let response = try await req.todoCollection.insertOne(item)
        item._id = response?.insertedID.objectIDValue

        return item
    }
}
```

_main.swift_ 파일은 애플리케이션의 시작 및 종료 코드를 정의합니다. 애플리케이션이 종료될 때 MongoDB 데이터베이스에 대한 연결을 닫는 _defer_ 문을 포함하도록 코드를 변경합니다.

파일 내용을 다음 코드로 교체합니다:

**api/Sources/Run/main.swift**

```swift
import App
import Vapor
import MongoDBVapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
try configure(app)

// shutdown and cleanup the MongoDB connection when the application terminates
defer {
  app.mongoDB.cleanup()
  cleanupMongoSwift()
  app.shutdown()
}

try app.run()
```

## 6단계: AWS Copilot 초기화

[AWS Copilot](https://aws.github.io/copilot-cli/)은 AWS에서 컨테이너화된 애플리케이션을 생성하기 위한 명령줄 유틸리티입니다. Copilot을 사용하여 Vapor 코드를 Fargate의 컨테이너로 빌드하고 배포합니다. Copilot은 또한 MongoDB 연결 문자열 값에 대한 AWS Systems Manager 시크릿 매개변수를 생성하고 추적합니다. 이 값은 데이터베이스의 사용자 이름과 비밀번호를 포함하므로 시크릿으로 저장합니다. 이 값을 절대 소스 코드에 저장해서는 안 됩니다. 마지막으로 Copilot은 API의 공개 엔드포인트를 노출하기 위해 API Gateway를 생성합니다.

새 Copilot 애플리케이션을 초기화합니다.

```bash
copilot app init todo
```

새 Copilot *Backend Service*를 추가합니다. 이 서비스는 컨테이너를 빌드하는 방법에 대한 지침을 위해 Vapor 프로젝트의 Dockerfile을 참조합니다.

```bash
copilot svc init --name api --svc-type "Backend Service" --dockerfile ./api/Dockerfile
```

애플리케이션을 위한 Copilot 환경을 생성합니다. 환경은 일반적으로 dev, test 또는 prod와 같은 단계에 맞춥니다. 메시지가 표시되면 AWS CLI로 구성한 AWS 자격 증명 프로파일을 선택합니다.

```bash
copilot env init --name dev --app todo --default-config
```

_dev_ 환경을 배포합니다:

```bash
copilot env deploy --name dev
```

## 7단계: 데이터베이스 자격 증명을 위한 Copilot 시크릿 생성

애플리케이션이 MongoDB Atlas 데이터베이스에 인증하기 위해 자격 증명이 필요합니다. 이 민감한 정보를 절대 소스 코드에 저장해서는 안 됩니다. 자격 증명을 저장하기 위해 Copilot *시크릿*을 생성합니다. 이는 MongoDB 클러스터에 대한 연결 문자열을 AWS Systems Manager 시크릿 매개변수에 저장합니다.

MongoDB Atlas 웹사이트에서 연결 문자열을 확인합니다. 클러스터 페이지에서 _Connect_ 버튼을 선택하고 *Connect your application*을 선택합니다.

![아키텍처](/assets/images/server-guides/aws/aws-fargate-vapor-mongo-atlas-connection.png)

Driver로 *Swift version 1.2.0*을 선택하고 표시된 연결 문자열을 복사합니다. 다음과 같은 형태입니다:

```bash
mongodb+srv://username:<password>@mycluster.mongodb.net/?retryWrites=true&w=majority
```

연결 문자열에는 데이터베이스 사용자 이름과 비밀번호 플레이스홀더가 포함되어 있습니다. **\<password\>** 부분을 데이터베이스 비밀번호로 교체합니다. 그런 다음 MONGODB_URI라는 새 Copilot 시크릿을 생성하고 값을 입력하라는 메시지가 표시되면 연결 문자열을 저장합니다.

```bash
copilot secret init --app todo --name MONGODB_URI
```

Fargate는 런타임에 시크릿 값을 환경 변수로 컨테이너에 주입합니다. 위의 5단계에서 _api/Sources/App/configure.swift_ 파일에서 이 값을 추출하고 MongoDB 연결을 구성하는 데 사용했습니다.

## 8단계: 백엔드 서비스 구성

Copilot은 Docker 이미지, 네트워크, 시크릿, 환경 변수 등 서비스의 속성을 정의하는 _manifest.yml_ 파일을 애플리케이션에 대해 생성합니다. Copilot이 생성한 매니페스트 파일을 변경하여 다음 속성을 추가합니다:

- 컨테이너 이미지에 대한 헬스 체크 구성
- MONGODB_URI 시크릿에 대한 참조 추가
- 서비스 네트워크를 *private*으로 구성
- MONGODB_DATABASE 및 MONGODB_COLLECTION에 대한 환경 변수 추가

이러한 변경을 구현하려면 _manifest.yml_ 파일의 내용을 다음 코드로 교체합니다. 이 애플리케이션을 위해 MongoDB Atlas에서 생성한 데이터베이스와 클러스터의 이름을 반영하도록 MONGODB_DATABASE 및 MONGODB_COLLECTION 값을 업데이트합니다.

**Mac M1/M2** 머신에서 이 솔루션을 빌드하는 경우, ARM 빌드를 지정하기 위해 manifest.yml 파일의 **platform** 속성의 주석을 해제합니다. 기본값은 *linux/x86_64*입니다.

**copilot/api/manifest.yml**

```yaml
# The manifest for the "api" service.
# Read the full specification for the "Backend Service" type at:
#  https://aws.github.io/copilot-cli/docs/manifest/backend-service/

# Your service name will be used in naming your resources like log groups, ECS services, etc.
name: api
type: Backend Service

# Your service is reachable at "http://api.${COPILOT_SERVICE_DISCOVERY_ENDPOINT}:8080" but is not public.

# Configuration for your containers and service.
image:
  # Docker build arguments. For additional overrides: https://aws.github.io/copilot-cli/docs/manifest/backend-service/#image-build
  build: api/Dockerfile
  # Port exposed through your container to route traffic to it.
  port: 8080
  healthcheck:
    command: ['CMD-SHELL', 'curl -f http://localhost:8080 || exit 1']
    interval: 10s
    retries: 2
    timeout: 5s
    start_period: 0s

# Mac M1/M2 users - uncomment the following platform line
# the default platform is linux/x86_64

# platform: linux/arm64

cpu: 256 # Number of CPU units for the task.
memory: 512 # Amount of memory in MiB used by the task.
count: 2 # Number of tasks that should be running in your service.
exec: true # Enable running commands in your container.

# define the network as private. this will place Fargate in private subnets
network:
  vpc:
    placement: private

# Optional fields for more advanced use-cases.
#
# Pass environment variables as key value pairs.
variables:
  MONGODB_DATABASE: home
  MONGODB_COLLECTION: todolist

# Pass secrets from AWS Systems Manager (SSM) Parameter Store.
secrets:
  MONGODB_URI: /copilot/${COPILOT_APPLICATION_NAME}/${COPILOT_ENVIRONMENT_NAME}/secrets/MONGODB_URI

# You can override any of the values defined above by environment.
#environments:
#  test:
#    count: 2               # Number of tasks to run for the "test" environment.
#    deployment:            # The deployment strategy for the "test" environment.
#       rolling: 'recreate' # Stops existing tasks before new ones are started for faster deployments.
```

## 9단계: API Gateway를 위한 Copilot 애드온 서비스 생성

Copilot에는 애플리케이션에 API Gateway를 추가하는 기능이 없습니다. 그러나 [Copilot "Addons"](https://aws.github.io/copilot-cli/docs/developing/additional-aws-resources/#how-to-do-i-add-other-resources)를 사용하여 애플리케이션에 추가 AWS 리소스를 추가할 수 있습니다.

Copilot 서비스 폴더 아래에 _addons_ 폴더를 생성하고 생성하려는 서비스를 정의하는 CloudFormation yaml 템플릿을 만들어 애드온을 정의합니다.

애드온 폴더를 생성합니다:

```bash
mkdir -p copilot/api/addons
```

API Gateway를 정의하는 파일을 생성합니다:

```bash
touch copilot/api/addons/apigateway.yml
```

메인 서비스에서 애드온 서비스로 매개변수를 전달하는 파일을 생성합니다:

```bash
touch copilot/api/addons/addons.parameters.yml
```

_addons.parameters.yml_ 파일에 다음 코드를 복사합니다. Cloud Map 서비스의 ID를 애드온 스택에 전달합니다.

**copilot/api/addons/addons.parameters.yml**

```yaml
Parameters:
  DiscoveryServiceARN: !GetAtt DiscoveryService.Arn
```

_addons/apigateway.yml_ 파일에 다음 코드를 복사합니다. DiscoveryServiceARN을 사용하여 Copilot이 Fargate 컨테이너를 위해 생성한 Cloud Map 서비스와 통합하는 API Gateway를 생성합니다.

**copilot/api/addons/apigateway.yml**

```yaml
Parameters:
  App:
    Type: String
    Description: Your application's name.
  Env:
    Type: String
    Description: The environment name your service, job, or workflow is being deployed to.
  Name:
    Type: String
    Description: The name of the service, job, or workflow being deployed.
  DiscoveryServiceARN:
    Type: String
    Description: The ARN of the Cloud Map discovery service.

Resources:
  ApiVpcLink:
    Type: AWS::ApiGatewayV2::VpcLink
    Properties:
      Name: !Sub '${App}-${Env}-${Name}'
      SubnetIds:
        !Split [',', Fn::ImportValue: !Sub '${App}-${Env}-PrivateSubnets']
      SecurityGroupIds:
        - Fn::ImportValue: !Sub '${App}-${Env}-EnvironmentSecurityGroup'

  ApiGatewayV2Api:
    Type: 'AWS::ApiGatewayV2::Api'
    Properties:
      Name: !Sub '${Name}.${Env}.${App}.api'
      ProtocolType: 'HTTP'
      CorsConfiguration:
        AllowHeaders:
          - '*'
        AllowMethods:
          - '*'
        AllowOrigins:
          - '*'

  ApiGatewayV2Stage:
    Type: 'AWS::ApiGatewayV2::Stage'
    Properties:
      StageName: '$default'
      ApiId: !Ref ApiGatewayV2Api
      AutoDeploy: true

  ApiGatewayV2Integration:
    Type: 'AWS::ApiGatewayV2::Integration'
    Properties:
      ApiId: !Ref ApiGatewayV2Api
      ConnectionId: !Ref ApiVpcLink
      ConnectionType: 'VPC_LINK'
      IntegrationMethod: 'ANY'
      IntegrationType: 'HTTP_PROXY'
      IntegrationUri: !Sub '${DiscoveryServiceARN}'
      TimeoutInMillis: 30000
      PayloadFormatVersion: '1.0'

  ApiGatewayV2Route:
    Type: 'AWS::ApiGatewayV2::Route'
    Properties:
      ApiId: !Ref ApiGatewayV2Api
      RouteKey: '$default'
      Target: !Sub 'integrations/${ApiGatewayV2Integration}'
```

## 10단계: Copilot 서비스 배포

서비스를 배포할 때 Copilot은 다음 작업을 실행합니다:

- Vapor Docker 이미지를 빌드합니다
- AWS 계정의 Amazon Elastic Container Registry(ECR)에 이미지를 배포합니다
- AWS 계정에 AWS CloudFormation 템플릿을 생성하고 배포합니다. CloudFormation이 애플리케이션에 정의된 모든 서비스를 생성합니다.

```bash
copilot svc deploy --name api --app todo --env dev
```

## 11단계: MongoDB Atlas 네트워크 접근 구성

MongoDB Atlas는 IP 접근 목록을 사용하여 특정 소스 IP 주소 목록으로 데이터베이스 접근을 제한합니다. 애플리케이션에서 컨테이너의 트래픽은 애플리케이션 네트워크의 NAT Gateway의 퍼블릭 IP 주소에서 시작됩니다. 이 IP 주소의 트래픽을 허용하도록 MongoDB Atlas를 구성해야 합니다.

NAT Gateway의 IP 주소를 얻으려면 다음 AWS CLI 명령을 실행합니다:

```bash
aws ec2 describe-nat-gateways --filter "Name=tag-key, Values=copilot-application" --query 'NatGateways[?State == `available`].NatGatewayAddresses[].PublicIp' --output table
```

출력:

```bash
---------------------
|DescribeNatGateways|
+-------------------+
|  1.1.1.1          |
|  2.2.2.2          |
+-------------------+
```

IP 주소를 사용하여 MongoDB Atlas 계정에서 각 주소에 대한 네트워크 접근 규칙을 생성합니다.

![아키텍처](/assets/images/server-guides/aws/aws-fargate-vapor-mongo-atlas-network-address.png)

## 12단계: API 사용

API의 엔드포인트를 얻으려면 다음 AWS CLI 명령을 사용합니다:

```bash
aws apigatewayv2 get-apis --query 'Items[?Name==`api.dev.todo.api`].ApiEndpoint' --output table
```

출력:

```bash
------------------------------------------------------------
|                          GetApis                         |
+----------------------------------------------------------+
|  https://[your-api-endpoint]                             |
+----------------------------------------------------------+
```

cURL이나 [Postman](https://www.postman.com/)과 같은 도구를 사용하여 API와 상호 작용합니다:

할 일 항목 추가

```bash
curl --request POST 'https://[your-api-endpoint]/item' --header 'Content-Type: application/json' --data-raw '{"name": "my todo item"}'
```

할 일 항목 검색

```bash
curl https://[your-api-endpoint]/items
```

## 정리

애플리케이션 사용을 마치면 Copilot을 사용하여 삭제합니다. AWS 계정에서 생성된 모든 서비스가 삭제됩니다.

```bash
copilot app delete --name todo
```
