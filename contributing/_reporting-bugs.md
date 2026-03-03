## 버그 보고

버그를 보고하는 것은 누구나 Swift를 개선하는 데 도움을 줄 수 있는 좋은 방법입니다. 오픈 소스 Swift 프로젝트는 버그 추적에 GitHub Issues를 사용합니다.

<div class="info" markdown="1">
Xcode 프로젝트나 Playground에서만 재현할 수 있는 버그이거나
Apple NDA와 관련된 버그인 경우,
대신 Apple의 [버그 리포터][apple-bugtracker]에 보고해 주세요.
</div>

이슈를 열 때 다음 내용을 포함해 주세요:

- **문제에 대한 간결한 설명.**
  크래시인 경우 스택 트레이스를 포함하세요. 그렇지 않으면 기대했던 동작과 실제로 관찰된 동작을 함께 설명해 주세요.

- **재현 가능한 테스트 케이스.**
  테스트 케이스가 문제를 재현하는지 다시 확인하세요. 비교적 작은 샘플(약 50줄 이내)은 설명에 직접 붙여넣는 것이 가장 좋고, 더 큰 샘플은 첨부 파일로 업로드할 수 있습니다. 가능한 한 최소한의 코드로 샘플을 줄여 보세요. 작은 테스트 케이스가 분석하기 더 쉽고 기여자들에게도 더 매력적입니다.

- **문제를 재현하는 환경에 대한 설명.**
  Swift 컴파일러 버전, 배포 대상(명시적으로 설정한 경우), 플랫폼 정보를 포함하세요.

Swift는 매우 활발하게 개발되고 있어 많은 버그 보고서를 받습니다. 새 이슈를 열기 전에 [기존 이슈](https://github.com/swiftlang/swift/issues)를 살펴보면 중복 보고를 줄이는 데 도움이 됩니다.

<div class="warning" markdown="1">
새로운 언어 기능을 요청하는 이슈를 제출하기 전에 [Swift Evolution 프로세스 섹션](#participating-in-the-swift-evolution-process)을 참고하세요.
</div>

[bugtracker]: http://github.com/swiftlang/swift/issues
[apple-bugtracker]: https://bugreport.apple.com
[evolution-repo]: https://github.com/swiftlang/swift-evolution 'GitHub의 Swift evolution 저장소 링크'
