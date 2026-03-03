---
redirect_from: 'server/guides/deploying/aws-sam-lambda'
layout: page
title: Serverless Application Model(SAM)을 사용하여 AWS Lambda에 배포하기
---

이 가이드에서는 [AWS Serverless Application Model(SAM)](https://aws.amazon.com/serverless/sam/) 툴킷을 사용하여 AWS에 서버사이드 Swift 워크로드를 배포하는 방법을 설명합니다. 이 워크로드는 할 일 목록을 추적하는 REST API입니다. [Amazon API Gateway](https://aws.amazon.com/api-gateway/)를 사용하여 API를 배포합니다. API 메서드는 [AWS Lambda](https://aws.amazon.com/lambda/) 함수를 사용하여 [Amazon DynamoDB](https://aws.amazon.com/dynamodb) 데이터베이스에 데이터를 저장하고 검색합니다.

## 아키텍처

![아키텍처](/assets/images/server-guides/aws/aws-lambda-sam-arch.png)

- Amazon API Gateway가 API 요청을 수신합니다
- API Gateway가 PUT 및 GET 이벤트를 처리하기 위해 Lambda 함수를 호출합니다
- Lambda 함수는 [AWS SDK for Swift](https://aws.amazon.com/sdk-for-swift/)와 [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime)을 사용하여 데이터베이스에서 항목을 검색하고 저장합니다

## 사전 요구사항

이 샘플 애플리케이션을 빌드하려면 다음이 필요합니다:

- [AWS 계정](https://console.aws.amazon.com/)
- [AWS Command Line Interface(AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) - CLI를 설치하고 AWS 계정의 자격 증명으로 [구성](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)합니다
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started.html) - AWS에서 서버리스 워크로드를 생성하는 데 사용되는 명령줄 도구
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) - Swift 코드를 Docker 이미지로 컴파일하기 위해 필요

## 1단계: 새 SAM 프로젝트 생성

SAM 프로젝트는 AWS 계정에 리소스(Lambda 함수, API Gateway, DynamoDB 테이블)를 생성합니다. YAML 템플릿에서 리소스를 정의합니다.

프로젝트 폴더와 새 **template.yml** 파일을 생성합니다.

```
mkdir swift-lambda-api && cd swift-lambda-api
touch template.yml
```

**template.yml** 파일을 열고 다음 코드를 추가합니다. 코드의 주석을 검토하여 각 섹션에서 생성되는 내용을 확인하세요.

```yml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Resources:
  # DynamoDB table to store your data
  SwiftAPITable:
    Type: AWS::Serverless::SimpleTable
    Properties:
      PrimaryKey:
        Name: id
        Type: String

  # Lambda function to put items to the database
  PutItemFunction:
    Type: AWS::Serverless::Function
    Properties:
      # package the function as a Docker image
      PackageType: Image
      Policies:
        # allow function to read and write to database table
        - DynamoDBCrudPolicy:
            TableName: !Ref SwiftAPITable
      Environment:
        # store database table name as an environment variable
        Variables:
          TABLE_NAME: !Ref SwiftAPITable
      Events:
        # handles the POST /item method of the REST API
        Api:
          Type: HttpApi
          Properties:
            Method: post
            Path: /item
    Metadata:
      # location of the code and Docker file for function
      DockerContext: ./src/put-item
      Dockerfile: Dockerfile
      DockerBuildArgs:
        TARGET_NAME: put-item

  # Lambda function to retrieve items from database
  GetItemsFunction:
    Type: AWS::Serverless::Function
    Properties:
      # package the function as a Docker image
      PackageType: Image
      Policies:
        # allow function to read and write to database table
        - DynamoDBCrudPolicy:
            TableName: !Ref SwiftAPITable
      Environment:
        # store database table name as an environment variable
        Variables:
          TABLE_NAME: !Ref SwiftAPITable
      Events:
        # handles the GET /items method of the REST API
        Api:
          Type: HttpApi
          Properties:
            Method: get
            Path: /items
    Metadata:
      # location of the code and Docker file for function
      DockerContext: ./src/get-items
      Dockerfile: Dockerfile
      DockerBuildArgs:
        TARGET_NAME: get-items

# print API endpoint and name of database table
Outputs:
  SwiftAPIEndpoint:
    Description: 'API Gateway endpoint URL for your application'
    Value: !Sub 'https://${ServerlessHttpApi}.execute-api.${AWS::Region}.amazonaws.com'
  SwiftAPITable:
    Description: 'DynamoDB Table Name'
    Value: !Ref SwiftAPITable
```

## 2단계: SwiftPM으로 Lambda 함수 초기화

Swift로 작성된 Lambda 함수가 API 이벤트를 처리합니다. _PutItem_ 함수는 _POST_ 요청을 처리하여 데이터베이스에 항목을 추가합니다. _GetItems_ 함수는 _GET_ 요청을 처리하여 데이터베이스에서 항목을 검색합니다.

Swift Package Manager를 사용하여 각 함수에 대한 프로젝트를 초기화합니다. 각 폴더에 *Dockerfile*도 추가합니다.

```bash
mkdir -p src/put-item
cd src/put-item
swift package init --type executable
touch Dockerfile

cd ../..

mkdir -p src/get-items
cd src/get-items
swift package init --type executable
touch Dockerfile
```

## 3단계: Dockerfile 업데이트

Docker를 사용하여 Swift 코드를 컴파일하고 이미지를 Lambda에 배포합니다. 각 함수의 폴더에 생성한 Dockerfile에 다음 코드를 복사합니다.

```Dockerfile
# image used to compile your Swift code
FROM --platform=linux/amd64 public.ecr.aws/docker/library/swift:5.7.2-amazonlinux2 as builder

ARG TARGET_NAME

RUN yum -y install git jq tar zip openssl-devel
WORKDIR /build-lambda
RUN mkdir -p /Sources/$TARGET_NAME/
RUN mkdir -p /Tests/$TARGET_NAME/
ADD /Sources/ ./Sources/
ADD /Tests/ ./Tests/
COPY Package.swift .
RUN cd /build-lambda && swift package clean && swift build --static-swift-stdlib -c release

# image deplpoyed to AWS Lambda with your compiled executable
FROM public.ecr.aws/lambda/provided:al2-x86_64

ARG TARGET_NAME

RUN mkdir -p /var/task/
RUN mkdir -p /var/runtime/
COPY --from=builder /build-lambda/.build/release/$TARGET_NAME /var/task/lambdaExec
RUN chmod 755 /var/task/lambdaExec
RUN ln -s /var/task/lambdaExec /var/runtime/bootstrap
RUN chmod 755 /var/runtime/bootstrap
WORKDIR /var/task
CMD ["/var/task/lambdaExec"]
```

## 4단계: Swift 의존성 업데이트

프로젝트에는 3개의 라이브러리가 필요합니다.

- swift-aws-lambda-runtime
- swift-aws-lambda-events
- aws-sdk-swift

이를 _Package.swift_ 파일에 정의합니다. 각 함수 폴더의 Package.swift 파일 내용을 다음 코드로 교체합니다.

**src/put-item/Sources/put-item/Package.swift**

```swift
// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "put-item",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "0.9.1")
    ],
    targets: [
        .executableTarget(
            name: "put-item",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]),
        .testTarget(
            name: "put-itemTests",
            dependencies: ["put-item"]),
    ]
)
```

**src/get-items/Sources/get-items/Package.swift**

```swift
// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "get-items",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "0.9.1")
    ],
    targets: [
        .executableTarget(
            name: "get-items",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]),
        .testTarget(
            name: "get-itemsTests",
            dependencies: ["get-items"]),
    ]
)
```

## 5단계: Lambda 함수 소스 코드 업데이트

각 Swift 프로젝트의 메인 코드 파일 내용을 다음 코드로 교체합니다.

**src/put-item/Sources/put-item/put_item.swift**

```swift
// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String?
    let itemName: String
}

enum FunctionError: Error {
    case envError
}

@main
struct PutItemFunction: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> Item {

        print("event received:\(event)")

        // create a client to interact with DynamoDB
        let client = try await DynamoDBClient()

        // obtain DynamoDB table name from function's environment variables
        guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
            throw FunctionError.envError
        }

        // decode data from APIGateway POST into a codable struct
        var item = try JSONDecoder().decode(
            Item.self,
            from: event.body!.data(using: .utf8)!
        )

        // generate a unique id for the key of the item
        item.id = UUID().uuidString

        // use SDK to put the item into the database and return the item with key value
        let input = PutItemInput(item: ["id": .s(item.id!), "itemName": .s(item.itemName)], tableName: tableName)

        _ = try await client.putItem(input: input)

        return item
    }
}
```

**src/get-items/Sources/get_items/get_items.swift**

```swift
// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String = ""
    var itemName: String = ""
}

enum FunctionError: Error {
    case envError
}

@main
struct GetItemsFunction: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> [Item] {

        print("event received:\(event)")

        // create a client to interact with DynamoDB
        let client = try await DynamoDBClient()

        // obtain DynamoDB table name from function's environment variables
        guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
            throw FunctionError.envError
        }

        // use SDK to retrieve items from table
        let input = ScanInput(tableName: tableName)
        let response = try await client.scan(input: input)

        // return items in an array
        return response.items!.map() {i in
            var item = Item()

            if case .s(let value) = i["id"] {
                item.id = value
            }

            if case .s(let value) = i["itemName"] {
                item.itemName = value
            }

            return item
        }
    }
}
```

## 6단계: SAM 프로젝트 빌드

SAM 프로젝트를 빌드하면 머신의 Docker를 사용하여 Swift 코드를 Docker 이미지로 컴파일합니다. 프로젝트의 루트 폴더 *(swift-lambda-api)*에서 다음 명령을 실행합니다.

```bash
sam build
```

## 7단계: SAM 프로젝트 배포

SAM 프로젝트를 배포하면 AWS 계정에 Lambda 함수, API Gateway, DynamoDB 데이터베이스가 생성됩니다.

```bash
sam deploy --guided
```

다음 두 가지를 제외한 모든 프롬프트에서 기본 응답을 수락합니다:

```bash
PutItemFunction may not have authorization defined, Is this okay? [y/N]: y
GetItemsFunction may not have authorization defined, Is this okay? [y/N]: y
```

프로젝트는 공개적으로 접근 가능한 API 엔드포인트를 생성합니다. 이는 API에 인가가 없다는 것을 알리는 경고입니다. API에 인가를 추가하는 데 관심이 있다면 [SAM 문서](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-httpapi.html)를 참고하세요.

## 8단계: API 사용

배포가 끝나면 SAM이 API Gateway의 엔드포인트를 표시합니다:

```bash
Outputs
----------------------------------------------------------------------------------------
Key                 SwiftAPIEndpoint
Description         API Gateway endpoint URL for your application
Value               https://[your-api-id].execute-api.[your-aws-region].amazonaws.com
----------------------------------------------------------------------------------------
```

cURL이나 [Postman](https://www.postman.com/)과 같은 도구를 사용하여 API와 상호 작용합니다. **[your-api-endpoint]**를 배포 출력의 SwiftAPIEndpoint 값으로 교체합니다.

할 일 항목 추가

```bash
curl --request POST 'https://[your-api-endpoint]/item' --header 'Content-Type: application/json' --data-raw '{"itemName": "my todo item"}'
```

할 일 항목 검색

```bash
curl https://[your-api-endpoint]/items
```

## 정리

애플리케이션 사용을 마치면 SAM을 사용하여 AWS 계정에서 삭제합니다. 모든 프롬프트에 **Yes(y)**로 응답합니다.

```bash
sam delete
```
