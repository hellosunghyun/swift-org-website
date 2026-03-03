## 표준 라이브러리 프리뷰 패키지

**[표준 라이브러리 프리뷰 패키지][preview-package]**는 표준 라이브러리에 새로 추가되는 기능에 대한 조기 접근을 제공합니다. 독립 라이브러리로 구현할 수 있는 새로운 표준 라이브러리 API가 Swift Evolution 프로세스를 통해 승인되면, 개별 패키지로 게시되고 우산 라이브러리 역할을 하는 프리뷰 패키지에 포함됩니다. 현재 프리뷰 패키지에는 다음 개별 패키지가 포함되어 있습니다:

[preview-package]: https://github.com/apple/swift-standard-library-preview/

<table>
<tr>
    <th>패키지</th>
    <th>설명</th>
</tr>
{% for package in site.data.preview_packages %}
<tr>
    <td><a href="{{ package.repo }}">{{ package.name }}</a></td>
    <td>{{ package.description }}</td>
</tr>
{% endfor %}
</table>
