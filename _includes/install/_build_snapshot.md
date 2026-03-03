## 개발 스냅샷

Swift 스냅샷은 브랜치에서 자동으로 생성되는 사전 빌드 바이너리입니다. 이 스냅샷은 공식 릴리스가 아닙니다. 자동화된 유닛 테스트를 거쳤지만, 공식 릴리스에 적용되는 전체 테스트를 통과한 것은 아닙니다.

{% assign platform_name_url = include.platform | remove: '.' | remove: ' ' | downcase %}
{% assign development_builds_2 = include.development_builds_2 | sort: 'date' | reverse %}
{% assign development_builds = include.development_builds | sort: 'date' | reverse %}

{% if include.aarch64 %}
{% assign aarch64_development_builds_2 = include.aarch64_development_builds_2 | sort: 'date' | reverse %}
{% assign aarch64_development_builds = include.aarch64_development_builds | sort: 'date' | reverse %}
{% endif %}

<ul class="grid-level-0 grid-layout-2-column">
  <li class="grid-level-1">
    <h3>{{ include.development }}</h3>
    <p class="description" style="font-size: 14px;">
      <time datetime="{{ development_builds.first.date | date_to_xmlschema }}" title="{{ development_builds.first.date | date: '%B %-d, %Y %l:%M %p (%Z)' }}">{{ development_builds.first.date | date: '%B %-d, %Y' }}</time>
    </p>
    <h4>Tarball (tar.gz)</h4>
    {% if include.aarch64 %}
    <ul class="grid-level-0 grid-layout-2-column">
      <a href="https://download.swift.org/{{ include.branch_dir }}/{{ platform_name_url }}/{{ development_builds.first.dir }}/{{ development_builds.first.download }}" class="cta-secondary">다운로드 (x86_64)</a>
      <a href="https://download.swift.org/{{ include.branch_dir }}/{{ platform_name_url }}-aarch64/{{ aarch64_development_builds.first.dir }}/{{ aarch64_development_builds.first.download }}" class="cta-secondary">다운로드 (aarch64)</a>
    </ul>
    {% else %}
    <a href="https://download.swift.org/{{ include.branch_dir }}/{{ platform_name_url }}/{{ development_builds.first.dir }}/{{ development_builds.first.download }}" class="cta-secondary">다운로드 (x86_64)</a>
    {% endif %}
    <h4>Docker</h4>
    <a href="https://hub.docker.com/r/swiftlang/swift/tags" class="cta-secondary external">{{ include.docker_tag }}</a>
    <p class="description">
      <ul>
        서명 (PGP): <a href="https://download.swift.org/{{ include.branch_dir }}/{{ platform_name_url }}/{{ development_builds.first.dir }}/{{ development_builds.first.download_signature }}">x86_64</a>{% if include.aarch64 %} | <a href="https://download.swift.org/{{ include.branch_dir }}/{{ platform_name_url }}-aarch64/{{ aarch64_development_builds.first.dir }}/{{ aarch64_development_builds.first.download_signature }}">aarch64</a>{% endif %}
      </ul>
    </p>
  </li>
  <li class="grid-level-1">
    <h3>{{ include.development_2 }}</h3>
    <p class="description" style="font-size: 14px;">
      <time datetime="{{ development_builds_2.first.date | date_to_xmlschema }}" title="{{ development_builds_2.first.date | date: '%B %-d, %Y %l:%M %p (%Z)' }}">{{ development_builds_2.first.date | date: '%B %-d, %Y' }}</time>
    </p>
    <h4>Tarball (tar.gz)</h4>
      {% if include.aarch64 %}
      <ul class="grid-level-0 grid-layout-2-column">
        <a href="https://download.swift.org/{{ include.branch_dir_2 }}/{{ platform_name_url }}/{{ development_builds_2.first.dir }}/{{ development_builds_2.first.download }}" class="cta-secondary">다운로드 (x86_64)</a>
        <a href="https://download.swift.org/{{ include.branch_dir_2 }}/{{ platform_name_url }}-aarch64/{{ aarch64_development_builds_2.first.dir }}/{{ aarch64_development_builds_2.first.download }}" class="cta-secondary">다운로드 (aarch64)</a>
      </ul>
      {% else %}
      <a href="https://download.swift.org/{{ include.branch_dir_2 }}/{{ platform_name_url }}/{{ development_builds_2.first.dir }}/{{ development_builds_2.first.download }}" class="cta-secondary">다운로드 (x86_64)</a>
      {% endif %}
      <h4>Docker</h4>
      <a href="https://hub.docker.com/r/swiftlang/swift/tags" class="cta-secondary external">{{ include.docker_tag_2 }}</a>
      <p class="description">
        <ul>
          서명 (PGP): <a href="https://download.swift.org/{{ include.branch_dir_2 }}/{{ platform_name_url }}/{{ development_builds_2.first.dir }}/{{ development_builds_2.first.download_signature }}">x86_64</a> | <a href="https://download.swift.org/{{ include.branch_dir_2 }}/{{ platform_name_url }}-aarch64/{{ aarch64_development_builds_2.first.dir }}/{{ aarch64_development_builds_2.first.download_signature }}">aarch64</a>
        </ul>
      </p>
  </li>
</ul>
<ul class="grid-level-0 grid-layout-2-column">
  <a href="/install/linux/tarball" class="cta-secondary">안내 (Tarball)</a>
  <a href="/install/linux/docker" class="cta-secondary">안내 (Docker)</a>
</ul>
{% include install/_static_sdk_dev.md %}
<details class="download" style="margin-bottom: 0;">
  <summary>이전 스냅샷 ({{ include.development }})</summary>
  {% include install/_older_snapshots.md builds=development_builds name=include.platform platform_dir=platform_name_url branch_dir=include.branch_dir %}
</details>
<details class="download" style="margin-bottom: 0;">
  <summary>이전 스냅샷 ({{ include.development_2 }})</summary>
  {% include install/_older_snapshots.md builds=development_builds_2 name=include.platform platform_dir=platform_name_url branch_dir=include.branch_dir_2 %}
</details>
