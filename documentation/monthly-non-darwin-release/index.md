---
redirect_from: '/monthly-non-darwin-release/'
layout: page
title: 비-Darwin Swift 월간 릴리스
---

릴리스 관리자가 각 월간 릴리스의 머지 윈도우를 공지합니다. 이 머지 윈도우는 약 3주간 열려 있다가 닫힙니다. 머지 윈도우가 닫힌 직후, 릴리스 관리자는 1주일 동안 릴리스를 마무리하여 swift.org에 공개합니다. 관련 날짜는 모두 Swift Forums의 공지에서 사전에 알려드립니다.

머지 윈도우가 열리면 누구나 포럼 게시물에서 공지된 릴리스 브랜치에 대한 Pull Request를 열 수 있습니다. 프로세스를 원활하고 가볍게 유지하기 위해, 릴리스 관리자는 다음 조건을 충족하는 Pull Request만 고려합니다:

- 버그 수정일 것
- 이미 `main`에 머지되었을 것
- 릴리스 브랜치에서 모든 유닛 테스트를 통과할 것
- 변경된 코드를 검증하는 유닛 테스트가 최소 하나 포함될 것

대부분의 버그 수정은 간단한 수정일 것으로 예상되므로, Pull Request 생성은 브랜치를 만든 후 `git cherry-pick -x FIX-COMMIT-FROM-MAIN-SHA`를 실행하는 정도가 될 수 있습니다. 모든 백포트가 충돌 없는 cherry pick이 되지는 않겠지만, 커뮤니티가 함께 협력하여 가장 시급한 버그 수정을 적시에 전달하기를 바랍니다. 도트 릴리스를 위한 변경 사항은 비-Darwin 플랫폼에만 집중해야 합니다.

## 릴리스 브랜치 Pull Request

릴리스 브랜치가 분리된 후 Pull Request가 포함되려면, 다음 요건을 갖추어야 합니다:

- 대상 브랜치의 릴리스 버전 번호가 포함된 지정자로 시작하는 제목
- 설명에 [이 양식](https://github.com/swiftlang/.github/blob/main/PULL_REQUEST_TEMPLATE/release.md?plain=1)이 작성되어 있어야 합니다. 해당하지 않는 항목은 빈 칸으로 두거나 해당 없음을 표시할 수 있지만, 항목 자체를 완전히 생략해서는 안 됩니다.

[swiftlang](https://github.com/swiftlang) 저장소에서 브라우저로 Pull Request를 작성할 때 이 템플릿으로 전환하려면, 현재 URL에 `template=release.md` 쿼리 파라미터를 추가하고 새로고침하세요. 예시:

```
-https://github.com/swiftlang/swift/compare/main...my-branch?quick_pull=1
+https://github.com/swiftlang/swift/compare/main...my-branch?quick_pull=1&template=release.md
```

릴리스 브랜치에 들어가는 **모든 변경 사항**은 해당 릴리스 관리자가 승인하는 **Pull Request를 통해야 합니다**.

다음 도트 릴리스에 포함되어야 할 중요한 버그 수정이 있지만 제때 수정할 여력이 없다면, Swift Forums를 활용하여 도움을 요청하세요. Swift 커뮤니티에는 기꺼이 도와줄 분들이 많으며, 때로는 버그에 대한 관심을 환기하는 것만으로도 수정이 이루어집니다. 커뮤니티의 대부분이 Swift에 풀타임으로 일하고 있지 않다는 점을 항상 기억하고, 서로 배려해 주세요.

마찬가지로, Pull Request를 열었다면 GitHub Pull Request에서 릴리스 관리자를 할당하여 바로 확인할 수 있도록 할 수 있습니다. 릴리스 관리자는 머지 윈도우 기간 내내 패치를 머지합니다. 그러나 머지 윈도우가 닫히면 다음 머지 윈도우가 열릴 때까지 더 이상의 Pull Request는 고려되지 않습니다.
