---
redirect_from: 'server/guides/deployment'
layout: page
title: 서버 또는 퍼블릭 클라우드에 배포하기
---

다음 가이드는 퍼블릭 클라우드 제공업체에 배포하는 데 도움이 됩니다:

- [AWS Lambda (Serverless Application Model (SAM) 사용)](/documentation/server/guides/deploying/aws-sam-lambda.html)
- [AWS Fargate (Vapor 및 MongoDB Atlas 사용)](/documentation/server/guides/deploying/aws-copilot-fargate-vapor-mongo.html)
- [AWS EC2](/documentation/server/guides/deploying/aws.html)
- [DigitalOcean](/documentation/server/guides/deploying/digital-ocean.html)
- [Heroku](/documentation/server/guides/deploying/heroku.html)
- [Kubernetes & Docker](/documentation/server/guides/packaging.html#docker)
- [GCP](/documentation/server/guides/deploying/gcp.html)
- _Azure 등 다른 인기 퍼블릭 클라우드에 대한 가이드가 있으신가요? 여기에 추가해 주세요!_

자체 서버(예: 베어메탈, VM 또는 Docker)에 배포하는 경우 Swift 애플리케이션을 배포용으로 패키징하는 여러 전략이 있습니다. 자세한 내용은 [패키징 가이드](/server/guides/packaging.html)를 참조하세요.

## 디버그 가능한 구성으로 배포하기 (Linux 프로덕션)

- `--privileged`/`--security-opt seccomp=unconfined` 컨테이너를 사용하거나 VM 또는 베어메탈에서 실행 중이라면, `./my-program` 대신 다음 명령으로 바이너리를 실행하여 크래시 시 '크래시 리포트'와 유사한 결과를 얻을 수 있습니다:

        lldb --batch -o "break set -n main --auto-continue 1 -C \"process handle SIGPIPE -s 0\"" -o run -k "image list" -k "register read" -k "bt all" -k "exit 134" ./my-program

- `--privileged`(또는 `--security-opt seccomp=unconfined`) 컨테이너가 없어 `lldb`를 사용할 수 없거나 lldb를 사용하고 싶지 않다면, [`swift-backtrace`](https://github.com/swift-server/swift-backtrace) 같은 라이브러리를 사용하여 크래시 시 스택 트레이스를 얻는 것을 고려해 보세요.
