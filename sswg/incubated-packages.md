---
layout: page
title: SSWG 인큐베이션 패키지
---

Swift Server 워크그룹([SSWG](/sswg/))은 프로젝트가 인큐베이션 단계를 거쳐 졸업하고 추천 프로젝트가 되는 [프로세스](/sswg/incubation-process.html)를 운영합니다.

## 졸업 프로젝트

<table>
  <thead>
    <tr>
      <th>프로젝트</th>
      <th>설명</th>
      <th>피치 일자</th>
      <th>승인 일자</th>
    </tr>
  </thead>
  <tbody>
    {% for project in site.data.server-workgroup.projects %}
    {% if project.maturity != "Graduated" %}
      {% continue %}
    {% endif %}
    <tr>
      <td><a href="{{ project.url }}">{{ project.name }}</a></td>
      <td>{{ project.description }}</td>
      <td>{{ project.pitched }}</td>
      <td>{{ project.accepted }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>

## 인큐베이팅 프로젝트

<table>
  <thead>
    <tr>
      <th>프로젝트</th>
      <th>설명</th>
      <th>피치 일자</th>
      <th>승인 일자</th>
    </tr>
  </thead>
  <tbody>
    {% for project in site.data.server-workgroup.projects %}
    {% if project.maturity != "Incubating" %}
      {% continue %}
    {% endif %}
    <tr>
      <td><a href="{{ project.url }}">{{ project.name }}</a></td>
      <td>{{ project.description }}</td>
      <td>{{ project.pitched }}</td>
      <td>{{ project.accepted }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>

## Sandbox 프로젝트

<table>
  <thead>
    <tr>
      <th>프로젝트</th>
      <th>설명</th>
      <th>피치 일자</th>
      <th>승인 일자</th>
    </tr>
  </thead>
  <tbody>
    {% for project in site.data.server-workgroup.projects %}
    {% if project.maturity != "Sandbox" %}
      {% continue %}
    {% endif %}
    <tr>
      <td><a href="{{ project.url }}">{{ project.name }}</a></td>
      <td>{{ project.description }}</td>
      <td>{{ project.pitched }}</td>
      <td>{{ project.accepted }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>

SSWG는 워크그룹이 인큐베이션한 프로젝트를 포함하는 [패키지 컬렉션](/blog/package-collections/)을 게시합니다. 이 컬렉션은 `https://swiftserver.group/collection/sswg.json`에서 이용할 수 있습니다.
