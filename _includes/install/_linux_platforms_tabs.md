## 최신 릴리스

<ul class="grid-level-0 grid-layout-1-column">
<li class="grid-level-1 featured">
    <h3>Swiftly (권장)</h3>
  <p class="description">
    Swiftly 설치 관리자는 Swift와 그 의존성을 관리합니다. 여러 버전 간 전환과 업데이트 다운로드를 지원합니다.
  </p>
  <h4>터미널에서 다음을 실행하세요:</h4>
  <div class="language-plaintext highlighter-rouge"><div class="highlight"><button>Copy</button><pre class="highlight"><code>curl -O "https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz" &amp;&amp; \
tar zxf "swiftly-$(uname -m).tar.gz" &amp;&amp; \
./swiftly init --quiet-shell-followup &amp;&amp; \
. ${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh &amp;&amp; \
hash -r
</code></pre></div></div>
  <h4>라이선스: <a href="https://raw.githubusercontent.com/swiftlang/swiftly/refs/heads/main/LICENSE.txt">Apache-2.0</a> | PGP: <a href="https://download.swift.org/swiftly/linux/swiftly-0.4.0-dev-x86_64.tar.gz.sig">서명</a></h4>
  <a href="/install/linux/swiftly" class="cta-secondary">안내</a>
</li>
</ul>
<ul class="grid-level-0 grid-layout-1-column">
<li class="grid-level-1">
    <h3>컨테이너</h3>
    <p class="description">
      컨테이너 환경을 선호한다면, 다양한 배포판에서 Swift를 컴파일하고 실행할 수 있는 공식 컨테이너 이미지를 다운로드할 수 있습니다.
    </p>
    <a href="https://hub.docker.com/_/swift" class="cta-secondary external">Docker Hub</a>
    <a href="/install/linux/docker" class="cta-secondary">안내</a>
  </li>
</ul>

## 대체 설치 옵션

<p id="platforms">Linux 플랫폼을 선택하세요:</p>

<div class="interactive-tabs os">
  <div class="tabs">
    <a href="/install/linux/amazonlinux/2#versions" aria-pressed="{{ include.amazonlinux }}">Amazon Linux</a>
    <a href="/install/linux/debian/12#versions" aria-pressed="{{ include.debian }}">Debian</a>
    <a href="/install/linux/fedora/39#versions" aria-pressed="{{ include.fedora }}">Fedora</a>
    <a href="/install/linux/ubi/9#versions" aria-pressed="{{ include.ubi }}">Red Hat</a>
    <a href="/install/linux/ubuntu#versions" aria-pressed="{{ include.ubuntu }}">Ubuntu</a>
  </div>
</div>

<hr>
