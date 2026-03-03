---
layout: new-layouts/base
title: Swift 프로그래밍 언어
---

<div class="animation-container">
    <canvas id="purple-swoop" width="1248" height="1116"></canvas>
    <canvas id="white-swoop-1" width="1248" height="1116"></canvas>
    <canvas id="orange-swoop-top" width="1248" height="1116"></canvas>
    <canvas id="orange-swoop-bottom" width="1248" height="1116"></canvas>
    <canvas id="white-swoop-2" width="1248" height="1116"></canvas>
    <canvas id="bird" width="1248" height="1116"></canvas>
</div>
<section id="what-is-swift" class="section">
    <div class="hero-content">
        <h1>Swift는 강력하고 유연한<br /> 멀티플랫폼 프로그래밍 언어입니다.</h1>
        <div class="sub-text"><h2>빠르고. 표현력 있고. 안전합니다.</h2></div>
        <a href="/install/" data-text="설치">설치</a>
        <p>Linux, macOS, Windows용 도구</p>
        <h2>Swift로 만들기</h2>
    </div>
    <nav aria-label="Swift 시작하기">
        <ul class="primary-links">
            {% for item in site.data.new-data.landing.get-started-primary %}
            <li>
                <a href="{{ item.link }}" data-text="{{ item.data-text }}">
                    <i class="{{ item.icon }}"></i>
                    <div>
                        <h3 class="title">{{ item.title }}</h3>
                        <p class="subtitle">{{ item.subtitle }}</p>
                    </div>
                </a>
            </li>
            {% endfor %}
        </ul>
        <ul class="secondary-links">
            {% for item in site.data.new-data.landing.get-started-secondary %}
            <li>
                <a href="{{ item.link }}" data-text="{{ item.data-text }}">
                    <h4 class="title">{{ item.title }}</h4>
                </a>
            </li>
            {% endfor %}
        </ul>
    </nav>
    <div class="swoop swoop-0 swoop-anim"></div>
</section>
{% assign pillar1_callouts = site.data.new-data.landing.callouts | slice: 0, 3 %}
{% assign pillar2_callouts = site.data.new-data.landing.callouts | slice: 3, 2 %}
{% assign pillar3_callouts = site.data.new-data.landing.callouts | slice: 5, 1 %}

<section id="pillar-1" class="section pillar">
    <div class="pillar-wrapper content-wrapper">
        <p class="pillar-intro">
            Swift는 임베디드 기기와 커널부터 앱, 클라우드 인프라까지 아우르는 유일한 언어입니다. 간결하고 표현력이 뛰어나며, 놀라운 성능과 안전성을 갖추고 있습니다. C 및 C++와의 상호 운용성도 탁월합니다.
        </p>
        <br />
        <p class="pillar-intro">
            접근성, 속도, 안전성, 그리고 Swift가 가진 모든 강점의<br class="hide-small"/> 조합이야말로 Swift를 특별하게 만드는 이유입니다.
        </p>
    </div>
    {% for callout in pillar1_callouts %}
{% include new-includes/components/callout.html
    title=callout.title
    subtitle=callout.subtitle
    text=callout.text
    code=callout.code
    index=forloop.index
%}
    {% endfor %}

    <div class="swoop swoop-1 swoop-anim"></div>

</section>

<section id="pillar-2" class="section pillar">
    {% for callout in pillar2_callouts %}
{% include new-includes/components/callout.html
    title=callout.title
    subtitle=callout.subtitle
    text=callout.text
    code=callout.code
    index=forloop.index
%}
    {% endfor %}
    <div class="swoop swoop-2 swoop-anim"></div>
</section>

<section id="pillar-3" class="section pillar">
    {% for callout in pillar3_callouts %}
{% include new-includes/components/callout.html
    title=callout.title
    subtitle=callout.subtitle
    text=callout.text
    code=callout.code
    index=forloop.index
    links=callout.links
%}
    {% endfor %}
</section>
