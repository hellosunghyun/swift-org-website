<table id="linux-builds" class="downloads">
  <thead>
    <tr>
      <th class="download">다운로드</th>
    </tr>
  </thead>
  <tbody>
    {% for build in include.builds | offset:1 | limit:10 %}
      <tr>
        <td class="download">
          <span class="release">
            <a href="https://download.swift.org/{{ include.branch_dir }}/{{ include.platform_dir }}/{{ build.dir }}/{{ build.download }}" title="다운로드" download>{{ build.date | date: '%B %-d, %Y' }}</a>
            {% if build.download_signature %}
              <a href="https://download.swift.org/{{ include.branch_dir }}/{{ include.platform_dir }}/{{ build.dir }}/{{ build.download_signature }}" title="PGP 서명" class="signature">서명</a>
            {% endif %}
            {% if build.debug_info %}
              <a href="https://download.swift.org/{{ include.branch_dir }}/{{ include.platform_dir }}/{{ build.dir }}/{{ build.debug_info }}" title="디버깅 심볼" class="debug">디버깅 심볼</a>
            {% if build.debug_info_signature %}
              <a href="https://download.swift.org/{{ include.branch_dir }}/{{ include.platform_dir }}/{{ build.dir }}/{{ build.debug_info_signature }}" title="디버깅 심볼 PGP 서명">서명</a>
            {% endif %}
            {% endif %}
          </span>
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>
