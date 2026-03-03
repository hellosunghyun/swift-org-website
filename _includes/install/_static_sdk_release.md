{% assign tag = site.data.builds.swift_releases.last.tag %}
{% assign tag_downcase = site.data.builds.swift_releases.last.tag | downcase %}
{% assign platform = site.data.builds.swift_releases.last.platforms | where: 'name', 'Static SDK'| first %}

<li class="grid-level-1 featured">
  <h3>Static Linux SDK </h3>
  <p class="description">
    Static Linux SDK - Linux 크로스 컴파일
    <ul>
      <li><a href="https://download.swift.org/{{ tag_downcase }}/static-sdk/{{ tag }}/{{ tag }}_static-linux-{{ platform.version }}.artifactbundle.tar.gz.sig">서명 (PGP)</a>
      </li>
      <li>
        체크섬: <code>{{ platform.checksum }}</code></li>
    </ul>
  </p>
  <a href="https://download.swift.org/{{ tag_downcase }}/static-sdk/{{ tag }}/{{ tag }}_static-linux-{{ platform.version }}.artifactbundle.tar.gz" class="cta-secondary">Linux Static SDK 다운로드</a>
  <a href="/documentation/articles/static-linux-getting-started.html" class="cta-secondary">안내 (Static Linux SDK)</a>
</li>
