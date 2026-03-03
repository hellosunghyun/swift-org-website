---
layout: page
title: SwiftUI로 iOS 앱 만들기
---

> 이 가이드의 소스 코드는 [GitHub](https://github.com/0xTim/swift-org-swiftui-tutorial)에서 확인할 수 있습니다.

이 튜토리얼에서는 Swift와 SwiftUI를 사용해 사용자에게 새로운 활동을 추천하는 간단한 앱을 만들어 봅니다. 이 과정에서 텍스트, 이미지, 버튼, 도형, 스택, 프로그램 상태 등 SwiftUI 앱의 기본 구성 요소들을 살펴보게 됩니다.

시작하려면 [Mac App Store에서 Xcode를 다운로드](https://apps.apple.com/app/xcode/id497799835?mt=12)해야 합니다. Xcode는 무료이며, Swift와 이 튜토리얼에 필요한 모든 도구가 포함되어 있습니다.

설치가 완료되면 Xcode를 실행하고 Create a new Xcode Project를 선택하세요. 상단의 iOS 탭을 선택한 다음 App 템플릿을 선택하고 Next를 누르세요.

**팁:** iOS 16을 대상으로 하지만, 이 코드는 macOS Ventura 이후 버전에서도 잘 동작합니다.

새 프로젝트를 만들 때 Xcode가 몇 가지 정보를 요청합니다:

- Product Name에 "WhyNotTry"를 입력합니다.
- Organization Identifier에는 com.example을 입력합니다. 실제 앱에서는 보통 자신의 도메인 이름(예: org.swift)을 입력합니다.
- Interface가 SwiftUI로 선택되어 있는지 확인합니다.
- Core Data와 Include Tests 체크박스는 해제하세요. 이 튜토리얼에서는 사용하지 않습니다.

![New Xcode Project]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/new-project.png)

Next를 누르면 Xcode가 프로젝트를 저장할 위치를 묻습니다. 어디든 상관없지만, 데스크탑이 가장 편할 수 있습니다. 저장하면 Xcode가 새 프로젝트를 만들고 ContentView.swift 파일을 편집할 수 있도록 열어 줍니다. 모든 코드를 이 파일에 작성할 것이며, 기본 SwiftUI 코드가 이미 들어 있습니다.

![Initial SwiftUI project]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/initial-view.png)

Xcode가 만든 예시 코드는 `ContentView`라는 새로운 뷰를 생성합니다. 뷰는 SwiftUI가 앱의 사용자 인터페이스를 화면에 표시하는 방식이며, 여기에 커스텀 레이아웃과 로직을 추가할 수 있습니다.

Xcode의 오른쪽에는 코드의 실시간 미리보기가 표시됩니다. 왼쪽의 코드를 수정하면 미리보기에 즉시 반영됩니다. 미리보기가 보이지 않으면 [이 안내](https://developer.apple.com/documentation/swiftui/previews-in-xcode)를 참고해서 활성화하세요.

예를 들어, 기본 `body` 코드를 다음과 같이 바꿔 보세요:

```swift
var body: some View {
    Text("Hello, SwiftUI!")
}
```

![Hello SwiftUI]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/hello-swift-ui.png)

미리보기가 즉시 업데이트되는 것을 볼 수 있습니다. 작업하면서 빠르게 프로토타이핑할 수 있어 매우 편리합니다. 이것은 `body`라는 연산 프로퍼티로, SwiftUI가 사용자 인터페이스를 표시할 때마다 호출합니다.

## 정적 UI 만들기

이 앱에서는 농구, 골프, 하이킹 같은 새로운 운동 활동을 사용자에게 보여줍니다. 좀 더 보기 좋게 만들기 위해, 각 활동을 이름과 아이콘으로 표시하고 뒤에 색상 배경을 추가하겠습니다.

사용자 인터페이스의 주요 부분은 현재 추천 활동을 보여주는 원입니다. `Circle`이라고 쓰기만 하면 원을 그릴 수 있으므로, `Text("Hello, SwiftUI!")` 뷰를 다음으로 교체하세요:

```swift
Circle()
```

![SwiftUI Circle]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/swiftui-circle.png)

미리보기에서 큰 검은 원이 화면 너비를 가득 채우는 것을 볼 수 있습니다. 시작은 좋지만 아직 부족합니다. 색상을 넣고, 양쪽에 여백을 추가해서 답답해 보이지 않게 만들어야 합니다.

두 가지 모두 `Circle` 뷰의 메서드를 호출하여 해결할 수 있습니다. SwiftUI에서는 이를 *뷰 수정자(view modifier)*라고 부르는데, 원의 모양이나 동작을 수정하기 때문입니다. 여기서는 `fill()` 수정자로 원에 색을 칠하고, `padding()` 수정자로 주변에 여백을 추가합니다:

```swift
Circle()
    .fill(.blue)
    .padding()
```

![SwiftUI Circle with Color and Padding]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/swiftui-circle-color.png)

`.blue` 색상은 `.red`, `.white`, `.green` 등 여러 내장 옵션 중 하나입니다. 이 색상들은 모두 외형 인식(appearance aware)이 적용되어 있어, 기기가 다크 모드인지 라이트 모드인지에 따라 미묘하게 다르게 보입니다.

파란 원 위에 추천 활동을 나타내는 아이콘을 올려놓겠습니다. iOS에는 *SF Symbols*라는 수천 개의 무료 아이콘이 포함되어 있으며, [무료 앱을 다운로드하면 모든 옵션을 확인](https://developer.apple.com/sf-symbols/)할 수 있습니다. 각 아이콘은 여러 두께(weight)로 제공되고, 크기를 부드럽게 조절할 수 있으며, 다수는 색상도 변경할 수 있습니다.

여기서는 간단하게 원 위에 아이콘 하나만 올려놓겠습니다. 이를 위해 하나의 뷰를 다른 뷰 위에 배치하는 `overlay()` 수정자를 사용합니다. 코드를 다음과 같이 수정하세요:

```swift
Circle()
    .fill(.blue)
    .padding()
    .overlay(
        Image(systemName: "figure.archery")
    )
```

![SwiftUI Circle with Icon]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/swiftui-circle-icon.png)

큰 파란 원 위에 작은 검은 양궁 아이콘이 보일 것입니다. 방향은 맞지만 보기에는 좋지 않습니다.

양궁 아이콘을 훨씬 크고, 배경 위에서 더 잘 보이게 만들어야 합니다. 이를 위해 두 가지 수정자가 더 필요합니다: 아이콘 크기를 조절하는 `font()`과 색상을 바꾸는 `foregroundColor()`입니다. 아이콘 크기를 조절하는 데 font 수정자를 사용하는 이유는, 이런 SF Symbols이 텍스트와 함께 자동으로 크기가 조절되기 때문입니다. 덕분에 매우 유연하게 쓸 수 있습니다.

`Image` 코드를 다음과 같이 수정하세요:

```swift
Image(systemName: "figure.archery")
    .font(.system(size: 144))
    .foregroundColor(.white)
```

![SwiftUI Circle with Icon Sized]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/swiftui-circle-icon-sized.png)

**팁:** `font()` 수정자는 144포인트 시스템 폰트를 요청하며, 모든 기기에서 충분히 크게 표시됩니다.

이제 훨씬 나아 보일 것입니다.

다음으로, 이미지 아래에 텍스트를 추가하여 사용자에게 추천 내용을 명확히 알려줍시다. 이미 `Text` 뷰와 `font()` 수정자를 살펴봤으므로, `Circle` 코드 아래에 다음 코드를 추가하세요:

```swift
Text("Archery!")
    .font(.title)
```

고정된 폰트 크기 대신, SwiftUI의 내장 Dynamic Type 크기 중 하나인 `.title`을 사용합니다. 이렇게 하면 사용자 설정에 따라 폰트가 커지거나 작아지므로, 일반적으로 좋은 선택입니다.

모든 것이 제대로 되었다면 코드가 다음과 같을 것입니다:

```swift
var body: some View {
    Circle()
        .fill(.blue)
        .padding()
        .overlay(
            Image(systemName: "figure.archery")
                .font(.system(size: 144))
                .foregroundColor(.white)
        )

    Text("Archery!")
        .font(.title)
}
```

![Circle With Title Text]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/circle-with-title.png)

하지만 Xcode 미리보기에서 보이는 결과는 예상과 다를 수 있습니다: 아이콘은 이전과 같지만 텍스트가 보이지 않습니다. 왜 그럴까요?

문제는 SwiftUI에 사용자 인터페이스에 두 개의 뷰(원과 텍스트)가 있다고 알려주었지만, 어떻게 배치할지를 지정하지 않았기 때문입니다. 나란히 놓을 건지? 위아래로 쌓을 건지? 아니면 다른 레이아웃으로 할 건지?

원하는 방식을 선택할 수 있지만, 여기서는 세로 레이아웃이 더 적합할 것입니다. SwiftUI에서는 `VStack`이라는 새로운 뷰 타입으로 이를 구현하며, 기존 코드를 _감싸는_ 형태로 배치합니다:

```swift
VStack {
    Circle()
        .fill(.blue)
        .padding()
        .overlay(
            Image(systemName: "figure.archery")
                .font(.system(size: 144))
                .foregroundColor(.white)
        )

    Text("Archery!")
        .font(.title)
}
```

이제 앞서 기대했던 레이아웃이 보일 것입니다: 양궁 아이콘 아래에 "Archery!" 텍스트가 표시됩니다.

![Circle With Title Text in a VStack]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/circle-with-title-vstack.png)

훨씬 낫습니다!

사용자 인터페이스의 첫 번째 버전을 마무리하기 위해, 상단에 제목을 추가하겠습니다. 이미 뷰를 위아래로 배치하는 `VStack`이 있지만, 나중에 화면의 일부에 애니메이션을 추가할 것이므로 제목은 그 안에 넣고 싶지 않습니다.

다행히 SwiftUI에서는 스택을 자유롭게 중첩할 수 있으므로, `VStack` 안에 또 다른 `VStack`을 넣어 원하는 동작을 구현할 수 있습니다. 코드를 다음과 같이 변경하세요:

```swift
VStack {
    Text("Why not try…")
        .font(.largeTitle.bold())

    VStack {
        Circle()
            .fill(.blue)
            .padding()
            .overlay(
                Image(systemName: "figure.archery")
                    .font(.system(size: 144))
                    .foregroundColor(.white)
            )

        Text("Archery!")
            .font(.title)
    }
}
```

새 텍스트에 큰 제목 폰트를 적용하고, 굵게(bold) 표시하여 화면의 제목으로서 더 잘 보이게 합니다.

![Why Not Try Title Added]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/why-not-try-title.png)

이제 두 개의 `VStack`이 있습니다: 원과 "Archery!" 텍스트를 담는 안쪽 VStack, 그리고 안쪽 VStack 주위에 제목을 추가하는 바깥쪽 VStack입니다. 이 구조는 나중에 애니메이션을 추가할 때 매우 유용할 것입니다!

## 생동감 불어넣기

양궁이 아무리 재미있다 해도, 이 앱은 항상 같은 활동을 보여주는 것이 아니라 랜덤으로 활동을 추천해야 합니다. 이를 위해 뷰에 두 개의 새 프로퍼티를 추가합니다: 하나는 가능한 활동 목록을 저장하고, 다른 하나는 현재 추천 중인 활동을 나타냅니다.

SF Symbols에는 흥미로운 활동이 많아서, 여기에 잘 맞는 몇 가지를 골랐습니다. `ContentView` 구조체에는 이미 SwiftUI 코드를 담고 있는 `body` 프로퍼티가 있지만, 새 프로퍼티는 그 밖에 추가해야 합니다. 코드를 다음과 같이 변경하세요:

```swift
struct ContentView: View {
    var activities = ["Archery", "Baseball", "Basketball", "Bowling", "Boxing", "Cricket", "Curling", "Fencing", "Golf", "Hiking", "Lacrosse", "Rugby", "Squash"]

    var selected = "Archery"

    var body: some View {
        // ...
    }
}
```

**중요:** `activities`와 `selected` 프로퍼티가 구조체 _안에_ 있다는 점에 주목하세요. 이는 프로그램에서 자유롭게 떠다니는 변수가 아니라 `ContentView`에 속한다는 것을 의미합니다.

이렇게 하면 다양한 활동 이름으로 구성된 배열이 만들어지고, 기본값으로 양궁이 선택됩니다. 이제 문자열 보간(string interpolation)을 사용하여 선택된 활동을 UI에 표시할 수 있습니다. `selected` 변수를 문자열 안에 직접 넣을 수 있습니다.

활동 이름은 간단합니다:

```swift
Text("\(selected)!")
    .font(.title)
```

이미지의 경우 조금 더 복잡합니다. `figure.` 접두사 뒤에 활동 이름을 소문자로 붙여야 하기 때문입니다. `figure.Archery`가 아니라 `figure.archery`여야 SF Symbol이 제대로 로드됩니다.

`Image` 코드를 다음과 같이 변경하세요:

```swift
Image(systemName: "figure.\(selected.lowercased())")
```

이 변경으로 UI는 `selected` 프로퍼티에 설정된 값을 표시하게 되므로, 프로퍼티에 새 문자열을 넣으면 모든 것이 바뀌는 것을 확인할 수 있습니다:

```swift
var selected = "Baseball"
```

![Showing Baseball]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/baseball.png)

물론 매번 코드를 수정하는 것이 아니라 _동적으로_ 변경되어야 하므로, 안쪽 `VStack` 아래에 버튼을 추가하여 누를 때마다 선택된 활동이 바뀌도록 하겠습니다. 이 버튼은 여전히 바깥쪽 `VStack` 안에 있으므로, 제목과 활동 아이콘 아래에 배치됩니다.

다음 코드를 추가하세요:

```swift
Button("Try again") {
    // change activity
}
.buttonStyle(.borderedProminent)
```

![Try Again Button]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/try-again-button.png)

따라서 구조는 다음과 같아야 합니다:

```swift
VStack {
    // "Why not try…" text

    // Inner VStack with icon and activity name

    // New button code
}
```

새 버튼 코드는 세 가지 일을 합니다:

1. 버튼의 레이블로 표시할 제목을 전달하여 `Button`을 생성합니다.
2. `// change activity` 주석은 버튼을 누를 때 실행될 코드가 들어갈 자리입니다.
3. `buttonStyle()` 수정자는 SwiftUI에 이 버튼을 눈에 띄게 만들라고 지시하여, 흰색 텍스트가 있는 파란 사각형으로 표시됩니다.

버튼의 액션에 주석만 있으면 재미없으니, `selected`를 `activities` 배열에서 랜덤으로 선택한 요소로 설정하겠습니다. 배열에서 랜덤 요소를 고르려면 이름 그대로인 `randomElement()` 메서드를 호출하면 됩니다. 주석을 다음으로 교체하세요:

```swift
selected = activities.randomElement()
```

이 코드가 맞아 _보이지만_, 실제로는 컴파일러 오류가 발생합니다. Swift에게 배열에서 랜덤 요소를 골라 `selected` 프로퍼티에 넣으라고 했지만, Swift는 배열에 요소가 있는지 확신할 수 없습니다. 배열이 비어 있을 수 있고, 그러면 반환할 랜덤 요소가 없기 때문입니다.

![Random Element Error]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/random-element-error.png)

Swift에서는 이를 *옵셔널(optional)*이라고 합니다: `randomElement()`는 일반 문자열이 아니라 *옵셔널 문자열*을 반환합니다. 이는 문자열이 없을 수도 있다는 의미이므로, `selected` 프로퍼티에 바로 할당하는 것이 안전하지 않습니다.

배열이 절대 비지 않을 것이라는 걸 알고 있지만(항상 활동이 들어 있을 테니), 혹시 미래에 배열이 비게 될 경우를 대비해 Swift에 합리적인 기본값을 제공할 수 있습니다:

```swift
selected = activities.randomElement() ?? "Archery"
```

이렇게 하면 일부 문제가 해결되지만, Xcode는 여전히 오류를 표시할 것입니다. 현재 문제는 SwiftUI가 경고 없이 뷰 구조체 내에서 바로 프로그램 상태를 변경하는 것을 허용하지 않는다는 점입니다. SwiftUI는 변경될 수 있는 모든 상태를 미리 표시해 두어야 변화를 감시할 수 있습니다.

![Non-@State mutating]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/non-state-mutating.png)

이는 변경될 뷰 프로퍼티 앞에 `@State`를 붙여서 해결합니다:

```swift
@State var selected = "Baseball"
```

이것을 *프로퍼티 래퍼(property wrapper)*라고 합니다. `selected` 프로퍼티를 추가 로직으로 감싸는 것입니다. `@State` 프로퍼티 래퍼는 뷰 상태를 자유롭게 변경할 수 있게 해주면서, 동시에 프로퍼티 변경을 자동으로 감시하여 사용자 인터페이스가 최신 값으로 유지되도록 합니다.

이제 두 오류가 모두 수정되었으니, Cmd+R을 눌러 iOS 시뮬레이터에서 앱을 빌드하고 실행할 수 있습니다. 기본으로 야구가 표시되지만, "Try again"을 누를 때마다 바뀌는 것을 확인할 수 있습니다.

<img class="device-aspect-ratio" src="{{site.url}}/assets/images/getting-started-guides/swiftui-ios/running-in-simulator.png" alt="Running The App in the Simulator">

## 마무리 다듬기

프로젝트를 마치기 전에, 몇 가지 개선 사항을 추가하겠습니다.

첫째, 간단한 것부터: Apple은 로컬 뷰 상태에 항상 `private` 접근 제어를 붙이는 것을 권장합니다. 큰 프로젝트에서는 한 뷰의 로컬 상태를 다른 뷰에서 실수로 읽는 코드를 작성할 수 없게 되어, 코드를 이해하기가 쉬워집니다.

`selected` 프로퍼티를 다음과 같이 수정합니다:

```swift
@State private var selected = "Baseball"
```

둘째, 항상 파란 배경 대신 매번 랜덤 색상을 선택할 수 있습니다. 이를 위해 두 단계가 필요합니다. 먼저 선택할 수 있는 모든 색상을 담은 새 프로퍼티를 추가합니다. `activities` 프로퍼티 옆에 넣으세요:

```swift
var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red]
```

이제 원의 `fill()` 수정자를 배열에서 `randomElement()`를 사용하도록 변경하고, 배열이 비어 있을 경우 `.blue`를 기본값으로 사용합니다:

```swift
Circle()
    .fill(colors.randomElement() ?? .blue)
```

셋째, 활동 `VStack`과 "Try again" 버튼 사이에 `Spacer`라는 새 SwiftUI 뷰를 추가하여 분리할 수 있습니다. Spacer는 자동으로 늘어나는 유연한 공간이므로, 활동 아이콘을 화면 상단으로, 버튼을 하단으로 밀어줍니다.

둘 사이에 다음과 같이 삽입하세요:

```swift
VStack {
    // current Circle/Text code
}

Spacer()

Button("Try again") {
    // ...
}
```

Spacer를 여러 개 추가하면 공간이 균등하게 나뉩니다. "Why not try…" 텍스트 앞에 두 번째 Spacer를 넣어 보면 무슨 뜻인지 알 수 있습니다. SwiftUI가 텍스트 위와 활동 이름 아래에 동일한 양의 공간을 만듭니다.

![View With Spacers]({{site.url}}/assets/images/getting-started-guides/swiftui-ios/spacers.png)

넷째, 활동 전환이 더 부드러우면 좋겠습니다. SwiftUI에서는 변경 사항을 `withAnimation()` 함수로 감싸서 애니메이션을 적용할 수 있습니다:

```swift
Button("Try again") {
    withAnimation {
        selected = activities.randomElement() ?? "Archery"
    }
}
.buttonStyle(.borderedProminent)
```

이렇게 하면 버튼을 누를 때 부드러운 페이드로 활동이 전환됩니다. 원한다면 `withAnimation()` 호출에 원하는 애니메이션을 전달하여 커스터마이즈할 수 있습니다:

```swift
withAnimation(.easeInOut(duration: 1)) {
    // ...
}
```

개선되었지만, 더 잘할 수 있습니다!

페이드가 발생하는 이유는 SwiftUI가 배경색, 아이콘, 텍스트가 변경되는 것을 감지하고, 기존 뷰를 제거한 후 새 뷰로 교체하기 때문입니다. 앞서 안쪽 `VStack`을 만들어 세 개의 뷰를 담도록 한 이유가 여기서 드러납니다: 이 뷰들을 하나의 그룹으로 식별할 수 있도록 하고, 그 그룹의 식별자가 시간에 따라 변경될 수 있다고 SwiftUI에 알려줄 것입니다.

이를 위해 먼저 뷰 안에 프로그램 상태를 더 정의해야 합니다. 이것이 안쪽 `VStack`의 식별자가 되며, 프로그램 실행 중에 변경되므로 `@State`를 사용합니다. `selected` 옆에 다음 프로퍼티를 추가하세요:

```swift
@State private var id = 1
```

**팁:** 이것도 로컬 뷰 상태이므로, `private`으로 표시하는 것이 좋은 습관입니다.

다음으로, 버튼을 누를 때마다 이 식별자가 변경되도록 SwiftUI에 알려줍니다:

```swift
Button("Try again") {
    withAnimation(.easeInOut(duration: 1)) {
        selected = activities.randomElement() ?? "Archery"
        id += 1
    }
}
.buttonStyle(.borderedProminent)
```

마지막으로, SwiftUI의 `id()` 수정자를 사용해 이 식별자를 안쪽 `VStack` 전체에 연결합니다. 식별자가 변경되면 SwiftUI는 `VStack` 전체를 새로운 것으로 간주합니다. 이렇게 하면 안에 있는 개별 뷰가 아니라, 기존 `VStack`이 제거되고 새 `VStack`이 추가되는 애니메이션이 적용됩니다. 더 나아가 `transition()` 수정자로 추가/제거 전환 방식도 제어할 수 있으며, 다양한 내장 전환 효과를 사용할 수 있습니다.

안쪽 `VStack`에 다음 두 수정자를 추가합니다. `id` 프로퍼티를 사용해 전체 그룹을 식별하고, 추가/제거 전환을 슬라이드 효과로 애니메이션합니다:

```swift
.transition(.slide)
.id(id)
```

Cmd+R을 눌러 앱을 마지막으로 한 번 실행해 보세요. "Try Again"을 누르면 이전 활동이 화면에서 부드럽게 사라지고, 새 활동으로 교체되는 것을 볼 수 있습니다. "Try Again"을 반복해서 빠르게 누르면 애니메이션이 겹치기도 합니다!

<video class="device-aspect-ratio" autoplay loop muted>
  <source src="{{site.url}}/assets/videos/getting-started-guides/swiftui-app/demo.mp4" type="video/mp4">
</video>

## 다음 단계

이 튜토리얼에서 텍스트, 이미지, 버튼, 스택, 애니메이션, 그리고 시간에 따라 변하는 값을 표시하기 위한 `@State` 사용 등 SwiftUI의 기본 사항을 많이 다루었습니다. SwiftUI는 이보다 훨씬 더 많은 것이 가능하며, 필요하다면 복잡한 크로스 플랫폼 앱도 만들 수 있습니다.

SwiftUI를 계속 배우고 싶다면 다양한 무료 자료가 있습니다. 예를 들어 [Apple은 필수 주제, 드로잉과 애니메이션, 앱 디자인 등을 다루는 다양한 튜토리얼을 제공](https://developer.apple.com/tutorials/swiftui)합니다. Swift.org에서도 인기 있는 다른 튜토리얼 링크를 게시할 예정입니다. Swift는 크고 따뜻한 커뮤니티이며, 여러분이 함께하는 것을 환영합니다!

> 이 가이드의 소스 코드는 [GitHub](https://github.com/0xTim/swift-org-swiftui-tutorial)에서 확인할 수 있습니다.
