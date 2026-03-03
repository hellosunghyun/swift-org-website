---
layout: page
title: 문서
---

Swift를 처음 접한다면 다음 자료도 참고해 보세요.

<div class="links links-list-nostyle" markdown="1">
- [시작하기 가이드](/getting-started/)
- [developer.apple.com의 Swift 자료](https://developer.apple.com/swift/resources/){:target="_blank" class="link-external"}
</div>

{%- for category in site.data.documentation %}

## {{ category.header }}

  <div>
  {%- for entry in category.pages %}
    <div>
    <a href="{{ entry.url }}">{{ entry.title }}</a>{% if entry.description %}: {{ entry.description }}{% endif %}
    </div>
    <br/>
  {% endfor %}
  </div>
{% endfor %}
