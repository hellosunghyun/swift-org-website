---
redirect_from:
  - '/download/'
layout: new-layouts/install
title: Swift 설치 - Windows
---

{% assign windows_dev_builds = site.data.builds.development.windows10 | sort: 'date' | reverse %}
{% assign windows_arm64_dev_builds = site.data.builds.development.windows10-arm64 | sort: 'date' | reverse %}
{% assign windows10_6_3_builds = site.data.builds.swift-6_3-branch.windows10 | sort: 'date' | reverse %}
{% assign windows10_arm64_6_3_builds = site.data.builds.swift-6_3-branch.windows10-arm64 | sort: 'date' | reverse %}
{% assign tag = site.data.builds.swift_releases.last.tag %}
{% assign platform = site.data.builds.swift_releases.last.platforms | where: 'name', 'Windows 10' | first %}

<div class="content">
  <h3 id="winget" class="header-with-anchor">1. WinGet으로 Swift 설치</h3>
  <div class="release-box section">
    <div class="content">
      {% include new-includes/components/code-box.html content = site.data.new-data.install.windows.releases.latest-release.winget %}
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
  <h2 id="alternative-install-options" class="header-with-anchor">대체 설치 방법</h2>
  <div class="releases-grid">
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>수동 설치</h2>
          <p class="body-copy">
            Swift 설치 프로그램(.exe) 다운로드
          </p>
          <div class="link-wrapper">
            {% for arch in platform.archs %}
              <div class="link-single">
                <a href="https://download.swift.org/{{ tag | downcase }}/windows10{% if arch != "x86_64" %}-{{ arch }}{% endif %}/{{ tag }}/{{ tag }}-windows10{% if arch != "x86_64" %}-{{ arch }}{% endif %}.exe" class="body-copy">다운로드 ({{ arch }})</a>
              </div>
            {% endfor %}
            <div class="link-single">
              <a href="/install/windows/manual" class="body-copy">설치 안내</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>컨테이너</h2>
          <p class="body-copy">
            다양한 배포판에서 Swift를 컴파일하고 실행하기 위한 공식 컨테이너 이미지를 사용할 수 있습니다.
          </p>
          <div class="link-wrapper">
            <div class="link-single">
              <a href="https://hub.docker.com/_/swift" class="body-copy">{{ site.data.builds.swift_releases.last.name }}-windowsservercore-ltsc2022</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <h2 id="previous-releases" class="header-with-anchor">이전 릴리스</h2>
  <div>
    <p class="content-copy">이전 Swift 릴리스는 수동 설치 프로그램을 사용하여 Windows에 설치할 수 있으며, <a href="/install/windows/archived">여기에 문서화되어 있습니다</a>.</p>
  </div>
  <div class="release-box section">
    <div class="content">
        <details class="download" style="margin-bottom: 0;">
        <summary>이전 릴리스</summary>
        {% include install/_older-releases.md platform="Windows 10" %}
        </details>
    </div>
  </div>
  <h2 id="development-snapshots" class="header-with-anchor">개발 스냅샷</h2>
  <div>
    <p class="content-copy">Swift 스냅샷은 브랜치에서 자동으로 생성되는 사전 빌드 바이너리입니다. 이 스냅샷은 공식 릴리스가 아닙니다. 자동화된 단위 테스트를 거쳤지만, 공식 릴리스에서 수행하는 전체 테스트를 거치지는 않았습니다.</p>
  </div>
  <div>
    <p class="content-copy">
      <a class="content-link" href="/install/windows/manual/">설치 안내</a>
    </p>
  </div>
  <div class="releases-grid">
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>main</h2>
          <p class="body-copy">
            <small>{{ windows_dev_builds.first.date | date: '%B %-d, %Y' }}</small><br />
            패키지 설치 프로그램(.exe)
          </p>
          <div class="link-wrapper">
            <div class="link-single">
              <a href="https://download.swift.org/development/windows10/{{ windows_dev_builds.first.dir }}/{{ windows_dev_builds.first.download }}" class="body-copy">다운로드 (x86_64)</a>
            </div>
            <div class="link-single">
              <a href="https://download.swift.org/development/windows10-arm64/{{ windows_arm64_dev_builds.first.dir }}/{{ windows_arm64_dev_builds.first.download }}" class="body-copy">다운로드 (arm64)</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="release-box section">
      <div class="content">
        <div class="code-box content-wrapper">
          <h2>release/6.3</h2>
          <p class="body-copy">
            <small>{{ windows10_6_3_builds.first.date | date: '%B %-d, %Y' }}</small><br />
            패키지 설치 프로그램(.exe)
          </p>
          <div class="link-wrapper">
            <div class="link-single">
              <a href="https://download.swift.org/swift-6.3-branch/windows10/{{ windows10_6_3_builds.first.dir }}/{{ windows10_6_3_builds.first.download }}" class="body-copy">다운로드 (x86_64)</a>
            </div>
            <div class="link-single">
              <a href="https://download.swift.org/swift-6.3-branch/windows10-arm64/{{ windows10_arm64_6_3_builds.first.dir }}/{{ windows10_arm64_6_3_builds.first.download }}" class="body-copy">다운로드 (arm64)</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
        <details class="download">
        <summary>이전 스냅샷 (main)</summary>
        {% include install/_older_snapshots.md builds=windows_dev_builds name="windows" platform_dir="windows10" branch_dir="development" %}
        </details>
    </div>
  </div>
  <div class="release-box section">
    <div class="content">
        <details class="download">
        <summary>이전 스냅샷 (release/6.3)</summary>
        {% include install/_older_snapshots.md builds=windows10_6_3_builds name="windows" platform_dir="windows10" branch_dir="swift-6.3-branch" %}
        </details>
    </div>
  </div>
</div>
