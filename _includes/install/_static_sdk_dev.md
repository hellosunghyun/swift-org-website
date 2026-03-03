{% assign static_sdk_dev_builds = site.data.builds.development.static_sdk | sort: 'date' | reverse %}
{% assign static_sdk_6_1_builds = site.data.builds.swift-6_1-branch.static_sdk | sort: 'date' | reverse %}

  <h3> Static Linux SDK </h3>
<ul class="grid-level-0 grid-layout-2-column">
    <li class="grid-level-1">
    <h3>main</h3>
    <p class="description" style="font-size: 14px;">
      <time datetime="{{ static_sdk_dev_builds.first.date | date_to_xmlschema }}" title="{{ static_sdk_dev_builds.first.date | date: '%B %-d, %Y %l:%M %p (%Z)' }}">{{ static_sdk_dev_builds.first.date | date: '%B %-d, %Y' }}</time>
    </p>
    <p class="description">
      Static Linux SDK - Linux 크로스 컴파일
      <ul>
        <li><a href="https://download.swift.org/development/static-sdk/{{ static_sdk_dev_builds.first.dir }}/{{ static_sdk_dev_builds.first.download_signature }}">서명 (PGP)</a>
        </li>
        <li>
          체크섬: <code>{{ static_sdk_dev_builds.first.checksum }}</code></li>
      </ul>
    </p>
    <a href="https://download.swift.org/development/static-sdk/{{ static_sdk_dev_builds.first.dir }}/{{ static_sdk_dev_builds.first.download }}" class="cta-secondary">Linux Static SDK 다운로드</a>
  </li>
  <li class="grid-level-1">
    <h3>release/6.1</h3>
    <p class="description" style="font-size: 14px;">
      <time datetime="{{ static_sdk_6_1_builds.first.date | date_to_xmlschema }}" title="{{ static_sdk_6_1_builds.first.date | date: '%B %-d, %Y %l:%M %p (%Z)' }}">{{ static_sdk_6_1_builds.first.date | date: '%B %-d, %Y' }}</time>
    </p>
    <p class="description">
      Static Linux SDK - Linux 크로스 컴파일
      <ul>
        <li><a href="https://download.swift.org/swift-6.1-branch/static-sdk/{{ static_sdk_6_1_builds.first.dir }}/{{ static_sdk_6_1_builds.first.download_signature }}">서명 (PGP)</a></li>
        <li>체크섬: <code>{{ static_sdk_6_1_builds.first.checksum }}</code></li>
      </ul>
    </p>
    <a href="https://download.swift.org/swift-6.1-branch/static-sdk/{{ static_sdk_6_1_builds.first.dir }}/{{ static_sdk_6_1_builds.first.download }}" class="cta-secondary">Linux Static SDK 다운로드</a>
  </li>
</ul>
<a href="/documentation/articles/static-linux-getting-started.html" class="cta-secondary">안내 (Static Linux SDK)</a>
