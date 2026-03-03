---
layout: page
title: Tarball을 사용한 Linux 설치
---

## Tarball을 사용한 설치

**1. 필수 의존성을 설치합니다:**

{% include linux/table.html %}

**2. 최신 바이너리 릴리스를 다운로드합니다** ([{{ site.data.builds.swift_releases.last.name }}](/download/#releases)).

`swift-<VERSION>-<PLATFORM>.tar.gz` 파일이 툴체인 자체입니다.
`.sig` 파일은 디지털 서명입니다.

**3. PGP 서명을 가져오고 검증합니다:**

이전에 키를 가져온 적이 있다면 이 단계를 건너뛰세요. 이는 검증에는 해당하지 않습니다.

<details class="download" style="margin-bottom: 0;">
  <summary>PGP 키 가져오기 상세</summary>
  <pre class="highlight">
    <code>$ gpg --keyserver hkp://keyserver.ubuntu.com \
          --recv-keys \
          'A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561'\
          'E813 C892 820A 6FA1 3755  B268 F167 DF1A CF9C E069'
    </code>
  </pre>

  <p>또는:</p>

  <div class="highlight">
    <pre class="highlight">
      <code>$ wget -q -O - /keys/all-keys.asc | \
        gpg --import -
      </code>
    </pre>
  </div>
</details>

<details class="download" style="margin-bottom: 0;">
  <summary>PGP 서명 검증</summary>

  <div class="warning">
    <p><code class="language-plaintext highlighter-rouge">gpg</code>가 검증에 실패하고 "BAD signature"를 보고하면
    다운로드한 툴체인을 사용하지 마세요.
    대신 가능한 한 자세한 내용을 포함하여 <a href="mailto:swift-infrastructure@forums.swift.org">swift-infrastructure@forums.swift.org</a>로
    이메일을 보내 주시면 문제를 조사하겠습니다.</p>
  </div>
  <p>Linux용 <code class="language-plaintext highlighter-rouge">.tar.gz</code> 아카이브는
  Swift 오픈 소스 프로젝트의 키 중 하나를 사용하여 GnuPG로 서명됩니다.
  소프트웨어를 사용하기 전에
  반드시 서명을 검증하는 것을 권장합니다.</p>
  <p>먼저 새로운 키 폐기 인증서가 있으면 다운로드하기 위해
  키를 갱신합니다:</p>

  <div class="language-shell highlighter-rouge">
    <div class="highlight">
      <pre class="highlight"><code><span class="nv">$ </span>gpg <span class="nt">--keyserver</span> hkp://keyserver.ubuntu.com <span class="nt">--refresh-keys</span> Swift</code></pre>
    </div>
  </div>
  <p>그런 다음 서명 파일을 사용하여 아카이브가 손상되지 않았는지 확인합니다:</p>
  <div class="language-shell highlighter-rouge">
    <div class="highlight">
      <pre class="highlight">
        <code><span class="nv">$ </span>gpg <span class="nt">--verify</span> swift-&lt;VERSION&gt;-&lt;PLATFORM&gt;.tar.gz.sig
  ...
  gpg: Good signature from <span class="s2">"Swift Automatic Signing Key #4 &lt;swift-infrastructure@forums.swift.org&gt;"</span>
        </code>
      </pre>
    </div>
  </div>
  <p>공개 키가 없어서 <code class="language-plaintext highlighter-rouge">gpg</code>가 검증에 실패한 경우(<code class="language-plaintext highlighter-rouge">gpg: Can't
  check signature: No public key</code>), 아래 <a href="#active-signing-keys">활성 서명 키</a>의 지침에 따라 키를 키링에 가져오세요.
  </p>
  <p>다음과 같은 경고가 표시될 수 있습니다:</p>
  <div class="language-shell highlighter-rouge">
    <div class="highlight">
      <pre class="highlight">
        <code>gpg: WARNING: This key is not certified with a trusted signature!
  gpg: There is no indication that the signature belongs to the owner.
        </code>
      </pre>
    </div>
  </div>
  <p>이 경고는 이 키와 사용자 사이에 신뢰 웹(Web of Trust) 경로가 없음을 의미합니다.
  위의 단계에 따라 신뢰할 수 있는 출처에서 키를 가져왔다면
  이 경고는 무해합니다.</p>

  <p><a href="/keys/active">활성 서명 키</a></p>
  <p><a href="/keys/expired">만료된 서명 키</a></p>
</details>

**4. 다음 명령으로 아카이브를 압축 해제합니다:**

```shell
$ tar xzf swift-<VERSION>-<PLATFORM>.tar.gz
```

아카이브 위치에 `usr/` 디렉토리가 생성됩니다.

**5. 다음과 같이 Swift 툴체인을 PATH에 추가합니다:**

```shell
$ export PATH=/path/to/usr/bin:"${PATH}"
```

이제 `swift repl` 명령으로 REPL을 실행하거나 `swift build`로 Swift 패키지를 빌드할 수 있습니다.
