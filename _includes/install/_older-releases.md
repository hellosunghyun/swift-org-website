<table id="osx-builds" class="downloads body-copy">
    <thead>
        <tr>
            <th class="download">릴리스</th>
            <th class="download">날짜</th>
            <th class="download">툴체인</th>
            <th class="download">Docker</th>
            {% if include.platform != "Windows 10" %}
            <th class="download">Static SDK</th>
            {% endif %}
        </tr>
    </thead>
    <tbody>
        {% assign releases = site.data.builds.swift_releases | offset:1  %}
        {% for release in releases reversed %}
        {% unless forloop.first %}
            {% include install/_old-release.html release=release platform=include.platform %}
        {% endunless %}

{% endfor %}

</tbody>

</table>
{% if include.platform == "Windows 10" %}
<sup>1</sup> Swift {{ include.release.name }} {{ windows_platform.first.name }} 툴체인은 <a href="https://github.com/compnerd">Saleem Abdulrasool</a>이 제공합니다. Saleem은 Swift Windows 포트의 플랫폼 챔피언이며, 이것은 Swift 프로젝트의 공식 빌드입니다. <br><br>
{% endif %}
