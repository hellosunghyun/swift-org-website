<table id="osx-builds" class="downloads body-copy">
    <thead>
        <tr>
            <th class="download">릴리스</th>
            <th class="download">날짜</th>
            <th class="download">툴체인</th>
            <th class="download">디버깅 심볼</th>
            <th class="download">Static SDK</th>
        </tr>
    </thead>
    <tbody>
        {% assign releases = site.data.builds.swift_releases | offset:1  %}
        {% for release in releases reversed %}
        {% unless forloop.first %}
    {% include_relative _old-release.html release=release name="Xcode" platform_dir="xcode" %}
{% endunless %}

{% endfor %}

</tbody>

</table>
