## 더 깊이 알아보기

더 깊이 파고들 준비가 되셨나요? 다양한 Swift 기능을 다루는 엄선된 리소스를 소개합니다.

<ul class="grid-level-0 grid-layout-2-column">
  {% for resource in site.data.go_further %}
  <li class="grid-level-1">
      {% if resource.thumbnail_url %}
        <img class="hero" src="{{ resource.thumbnail_url }}"/>
      {% elsif resource.content_type == "article" %}
        <img class="hero" src="/assets/images/getting-started/article-thumbnail.jpg"/>
      {% endif %}

      <h3>
        {{ resource.title }}
      </h3>

      <p class="description">
        {{ resource.description | markdownify }}
      </p>

      <a href="{{ resource.content_url }}" class="cta-secondary{% if resource.external %} external" target="_blank"{% else %}"{% endif %}>
        {% if resource.content_type == "video" %}
        영상 보기
        {% elsif resource.content_type == "article" %}
        글 읽기
        {% elsif resource.content_type == "book" %}
        책 읽기
        {% else %}
        리소스 보기
        {% endif %}
      </a>

  </li>
  {% endfor %}
</ul>

더 찾아보시겠습니까? [문서](/documentation/)에서 [API 디자인 가이드라인](/documentation/api-design-guidelines/)을 포함해 Swift 프로젝트와 관련된 리소스, 참고 자료, 가이드라인을 찾을 수 있습니다.
