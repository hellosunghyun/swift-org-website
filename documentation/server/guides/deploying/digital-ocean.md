---
redirect_from: 'server/guides/deploying/digital-ocean'
layout: page
title: DigitalOcean에 배포하기
---

이 가이드는 DigitalOcean [Droplet](https://www.digitalocean.com/products/droplets/)에서 Ubuntu 가상 머신을 설정하는 과정을 안내합니다. 이 가이드를 따르려면 결제가 설정된 [DigitalOcean](https://www.digitalocean.com) 계정이 필요합니다.

## 서버 생성

생성 메뉴를 사용하여 새 Droplet을 생성합니다.

![Droplet 생성](/assets/images/server-guides/digital-ocean-create-droplet.png)

배포판에서 Ubuntu 18.04 LTS를 선택합니다.

![Ubuntu 배포판](/assets/images/server-guides/digital-ocean-distributions-ubuntu-18.png)

> 참고: Swift가 지원하는 모든 Linux 버전을 선택할 수 있습니다. 공식적으로 지원되는 운영 체제는 [Swift 릴리스](/download/#releases) 페이지에서 확인할 수 있습니다.

배포판을 선택한 후 원하는 플랜과 데이터센터 리전을 선택합니다. 그런 다음 서버가 생성된 후 접근하기 위한 SSH 키를 설정합니다. 마지막으로 Droplet 생성을 클릭하고 새 서버가 가동될 때까지 기다립니다.

새 서버가 준비되면 Droplet의 IP 주소 위에 마우스를 올리고 복사를 클릭합니다.

![Droplet 목록](/assets/images/server-guides/digital-ocean-droplet-list.png)

## 초기 설정

터미널을 열고 SSH를 사용하여 root로 서버에 접속합니다.

```sh
ssh root@<server_ip>
```

DigitalOcean에 [Ubuntu 18.04 초기 서버 설정](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04)에 대한 상세 가이드가 있습니다. 이 가이드에서는 기본 사항만 간략하게 다룹니다.

### 방화벽 설정

방화벽에서 OpenSSH를 허용하고 활성화합니다.

```sh
ufw allow OpenSSH
ufw enable
```

그런 다음 root가 아닌 사용자가 접근할 수 있는 HTTP 포트를 활성화합니다.

```sh
ufw allow 8080
```

### 사용자 추가

애플리케이션을 실행할 `root` 외의 새 사용자를 생성합니다. 이 가이드에서는 보안 강화를 위해 `sudo` 접근 권한이 없는 비root 사용자를 사용합니다.

다음 가이드에서는 사용자 이름이 `swift`라고 가정합니다.

```sh
adduser swift
```

root 사용자의 인증된 SSH 키를 새로 생성된 사용자에게 복사합니다. 이를 통해 새 사용자로 SSH(`scp`)를 사용할 수 있습니다.

```sh
rsync --archive --chown=swift:swift ~/.ssh /home/swift
```

DigitalOcean 가상 머신이 준비되었습니다. [Ubuntu](/server/guides/deploying/ubuntu.html) 가이드를 계속 진행하세요.
