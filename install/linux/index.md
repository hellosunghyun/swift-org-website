---
redirect_from:
  - '/download/'
layout: new-layouts/install
title: Swift 설치 - Linux
---

<div class="content">
  <h3 id="swiftly" class="header-with-anchor">1. Swiftly로 Swift 설치</h3>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html with-tabs = true content = site.data.new-data.install.linux.releases.latest-release.swiftly %}
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.linux.releases.latest-release.container %}
    </div>
  </div>
  <h3 id="editor" class="header-with-anchor">2. 에디터 선택</h3>
  <div class="releases-grid">
    <div class="release-box section">
      <div class="content">
        {% include new-includes/components/code-box.html content = site.data.new-data.install.windows.releases.latest-release.vscode%}
      </div>
    </div>
    <div class="release-box section">
      <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.macos.releases.latest-release.other_editors%}
      </div>
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
<br><br>
<hr>
  <h2 id="development-snapshots" class="header-with-anchor">개발 스냅샷</h2>
  <div>
    <p class="content-copy">Swift 스냅샷은 브랜치에서 자동으로 생성되는 사전 빌드 바이너리입니다. 이 스냅샷은 공식 릴리스가 아닙니다. 자동화된 단위 테스트를 거쳤지만, 공식 릴리스에서 수행하는 전체 테스트를 거치지는 않았습니다.</p>
  </div>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html with-tabs = true content = site.data.new-data.install.linux.dev.latest-dev.swiftly %}
    </div>
  </div>
  <h2 id="swift-sdk-bundles" class="header-with-anchor">Swift SDK 번들</h2>
  <div>
    <p class="content-copy">크로스 컴파일을 위한 추가 컴포넌트</p>
  </div>
  <h3>Static Linux SDK</h3>
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
  <div class="callout">
    <div>
      <p class="content-copy">
        <a class="content-link block" href="/install/linux/amazonlinux/2">대체 설치 방법</a>
      </p>
    </div>
  </div>
</div>
