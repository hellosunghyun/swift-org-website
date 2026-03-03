---
layout: page
title: Swift.org 보안
---

## 보안 프로세스

커뮤니티 보호를 위해, Swift.org는 조사가 완료되고 필요한 업데이트가 일반적으로 제공될 때까지 보안 문제를 공개, 논의, 확인하지 않습니다.

최근 보안 업데이트는 아래 [보안 업데이트](#security-updates) 섹션에 나열되어 있습니다.

Swift.org 보안 문서는 가능한 경우 취약점을 [CVE-ID](https://www.cve.org/About/Overview)로 참조합니다.

### 보안 또는 개인정보 취약점 신고

Swift.org 프로젝트에서 보안 또는 개인정보 취약점을 발견했다고 생각되면 알려주세요.
보안 연구원, 개발자, 사용자 등 누구의 신고든 환영합니다.

보안 또는 개인정보 취약점을 신고하려면 다음 정보를 포함하여 [cve@forums.swift.org](mailto:cve@forums.swift.org)로 이메일을 보내주세요:

- 영향을 받는 것으로 판단되는 특정 프로젝트와 소프트웨어 버전.
- 관찰된 동작과 예상했던 동작에 대한 설명.
- 문제를 재현하는 데 필요한 단계별 목록 및/또는 단계를 따라가기 어려운 경우 영상 시연.

이메일로 민감한 정보를 보낼 때는 [Swift.org의 CVE PGP 키](/keys/cve-signing-key-1.asc)를 사용하여 암호화해 주세요.

신고 접수를 확인하는 이메일 답장을 받게 되며, 추가 정보가 필요한 경우 연락드리겠습니다.

### Swift.org의 신고 처리 방법

커뮤니티 보호를 위해, Swift.org는 조사가 완료되고 필요한 업데이트가 일반적으로 제공될 때까지 보안 문제를 공개, 논의, 확인하지 않습니다.

Swift.org는 보안 권고 사항과 security-announce 메일링 리스트를 사용하여 프로젝트의 보안 수정 사항에 대한 정보를 게시하고, 보안 문제를 신고한 개인이나 조직을 공개적으로 인정합니다.

## 보안 업데이트

{% assign cve_list = site.data.security.cve | sort: "date" %}

<ul>
  {% for cve in cve_list %}
  <li>
    <a href="https://cve.mitre.org/cgi-bin/cvename.cgi?name={{ cve.id }}">{{ cve.id }}</a>
    <p>
    {{ cve.description }}
    </p>
  </li>
  {% endfor %}
</ul>
