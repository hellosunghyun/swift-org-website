---
redirect_from:
  - '/download/'
layout: new-layouts/install
title: Swift 설치 - macOS
---

{% assign xcode_dev_builds = site.data.builds.development.xcode | sort: 'date' | reverse %}
{% assign xcode_6_3_builds = site.data.builds.swift-6_3-branch.xcode | sort: 'date' | reverse %}

<div class="content">
  <h3 id="swiftly" class="header-with-anchor">1. Swiftly로 Swift 설치</h3>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html with-tabs = true content = site.data.new-data.install.macos.releases.latest-release.swiftly%}
    </div>
  </div>
  <h3 id="editor" class="header-with-anchor">2. 에디터 선택</h3>
  <div class="releases-grid">
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.macos.releases.latest-release.xcode%}
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.windows.releases.latest-release.vscode%}
    </div>
  </div>
</div>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.macos.releases.latest-release.other_editors%}
    </div>
  </div>
  <h3 id="build-a-command-line-tool" class="header-with-anchor">3. 커맨드라인 도구 빌드</h3>
<div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.windows.releases.latest-release.build-a-package%}
    </div>
  </div>
  <h2 id="swift-sdk-bundles" class="header-with-anchor">Swift SDK 번들</h2>
  <div>
    <p class="content-copy">크로스 컴파일을 위한 추가 컴포넌트</p>
  </div>
  <div class="releases-grid">
      <div class="release-box section">
      <div class="content">
        {% include new-includes/components/static-linux-sdk.html %}
      </div>
    </div>
    <div class="release-box section">
      <div class="content">
        {% include new-includes/components/wasm-sdk.html %}
      </div>
    </div>
  </div>
  <h3 id="alternative-install-options" class="header-with-anchor">대체 툴체인 설치 방법</h3>
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>패키지 설치 프로그램</h2>
          <p class="body-copy">
            Swiftly가 자동화하는 툴체인 패키지 설치 프로그램(.pkg)을 별도로 다운로드할 수 있습니다.
          </p>
          <div class="link-wrapper">
            <a href="https://download.swift.org/{{ site.data.builds.swift_releases.last.tag | downcase }}/xcode/{{ site.data.builds.swift_releases.last.tag }}/{{ site.data.builds.swift_releases.last.tag }}-osx.pkg" class="body-copy">툴체인 다운로드</a>
          </div>
          <div class="link-single">
            <a href="/install/macos/package_installer" class="body-copy">설치 안내</a>
          </div>
        </div>
      </div>
    </div>
  <div class="release-box section">
    <div class="content">
        <details class="download" style="margin-bottom: 0;">
        <summary>이전 릴리스</summary>
        {% include_relative _older-releases.md %}
        </details>
    </div>
  </div>
  <br><br>
  <hr>
  <h2 id="development-snapshots" class="header-with-anchor">개발 스냅샷</h2>
  <div>
    <p class="content-copy">Swift 스냅샷은 브랜치에서 자동으로 생성되는 사전 빌드 바이너리입니다. 이 스냅샷은 공식 릴리스가 아닙니다. 자동화된 단위 테스트를 거쳤지만, 공식 릴리스에서 수행하는 전체 테스트를 거치지는 않았습니다.</p>
    <p class="content-copy">개발 스냅샷을 설치하는 가장 쉬운 방법은 Swiftly 도구를 사용하는 것입니다. 자세한 내용은 <a href="/install/macos/swiftly">설치 안내 페이지</a>를 참고하세요.</p>
  </div>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html with-tabs = true content = site.data.new-data.install.linux.dev.latest-dev.swiftly %}
    </div>
  </div>
  <h3>툴체인</h3>
  <div>
    <p class="content-copy">
      <a class="content-link" href="/install/macos/package_installer">설치 안내</a>
    </p>
  </div>
  <div class="releases-grid">
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>main</h2>
          <p class="body-copy">
            <small>{{ xcode_dev_builds.first.date | date: '%B %-d, %Y' }}</small><br />
            툴체인 패키지 설치 프로그램(.pkg)
          </p>
          <div class="link-wrapper">
            <a href="https://download.swift.org/development/xcode/{{ xcode_dev_builds.first.dir }}/{{ xcode_dev_builds.first.debug_info }}" class="body-copy">디버깅 심볼</a>
          </div>
          <div class="link-wrapper">
            <a href="https://download.swift.org/development/xcode/{{ xcode_dev_builds.first.dir }}/{{ xcode_dev_builds.first.download }}" class="body-copy">툴체인 다운로드</a>
          </div>
        </div>
      </div>
    </div>
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>release/6.3</h2>
          <p class="body-copy">
            <small>{{ xcode_6_3_builds.first.date | date: '%B %-d, %Y' }}</small><br />
            툴체인 패키지 설치 프로그램(.pkg)
          </p>
          <div class="link-wrapper">
            <a href="https://download.swift.org/swift-6.3-branch/xcode/{{ xcode_6_3_builds.first.dir }}/{{ xcode_6_3_builds.first.debug_info }}" class="body-copy">디버깅 심볼</a>
          </div>
          <div class="link-wrapper">
            <a href="https://download.swift.org/swift-6.3-branch/xcode/{{ xcode_6_3_builds.first.dir }}/{{ xcode_6_3_builds.first.download }}" class="body-copy">툴체인 다운로드</a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
        <details class="download" style="margin-bottom: 0;">
        <summary>이전 스냅샷 (main)</summary>
        {% include_relative _older-development-snapshots.md %}
        </details>
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
        <details class="download" style="margin-bottom: 0;">
        <summary>이전 스냅샷 (release/6.3)</summary>
        {% include_relative _older-6_3-snapshots.md %}
        </details>
    </div>
  </div>
  <h2 id="swift-sdk-buindles-dev" class="header-with-anchor">Swift SDK 번들</h2>
  <div>
    <p class="content-copy">크로스 컴파일을 위한 추가 컴포넌트</p>
  </div>
  <h3>Static Linux용 Swift SDK</h3>
  <div>
    <p class="content-copy">
      <a class="content-link" href="/documentation/articles/static-linux-getting-started.html">설치 안내</a>
    </p>
  </div>
  {% include new-includes/components/static-linux-sdk-dev.html %}
   <h3>WebAssembly용 Swift SDK</h3>
  <div>
    <p class="content-copy">
      <a class="content-link" href="/documentation/articles/wasm-getting-started.html">설치 안내</a>
    </p>
  </div>
  {% include new-includes/components/wasm-sdk-dev.html %}
  <h3>Android용 Swift SDK</h3>
  <div>
    <p class="content-copy">
      <a class="content-link" href="/documentation/articles/swift-sdk-for-android-getting-started.html">설치 안내</a>
    </p>
  </div>
  {% include new-includes/components/android-sdk-dev.html %}
</div>
