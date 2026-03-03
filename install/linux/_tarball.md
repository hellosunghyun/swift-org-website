## Tarball을 사용한 설치

0. 필수 의존성을 설치합니다:

{% include linux/table.html %}

0. 최신 바이너리 릴리스를 다운로드합니다 ([{{ site.data.builds.swift_releases.last.name }}](/download/#releases)).

   `swift-<VERSION>-<PLATFORM>.tar.gz` 파일이 툴체인 자체입니다.
   `.sig` 파일은 디지털 서명입니다.

1. Swift 패키지를 **처음 다운로드하는 경우**, PGP 키를 키링에 가져옵니다:

{% assign all_keys_file = 'all-keys.asc' %}
{% assign automatic_signing_key_file = 'automatic-signing-key-4.asc' %}
{% assign automatic_signing_key_file_3 = 'automatic-signing-key-3.asc' %}
{% assign automatic_signing_key_file_2 = 'automatic-signing-key-2.asc' %}
{% assign automatic_signing_key_file_1 = 'automatic-signing-key-1.asc' %}

```shell
$ gpg --keyserver hkp://keyserver.ubuntu.com \
      --recv-keys \
      '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD' \
      '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F' \
      'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6' \
      '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235' \
      '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4' \
      'A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561' \
      '8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA' \
      'E813 C892 820A 6FA1 3755  B268 F167 DF1A CF9C E069'
```

또는:

```shell
$ wget -q -O - https://swift.org/keys/{{ all_keys_file }} | \
  gpg --import -
```

이전에 키를 가져온 적이 있다면 이 단계를 건너뛰세요.

0. PGP 서명을 검증합니다.

   Linux용 `.tar.gz` 아카이브는 Swift 오픈 소스 프로젝트의
   키 중 하나를 사용하여 GnuPG로 서명됩니다.
   소프트웨어를 사용하기 전에
   반드시 서명을 검증하는 것을 권장합니다.

   먼저 새로운 키 폐기 인증서가 있으면 다운로드하기 위해
   키를 갱신합니다:

   ```shell
   $ gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
   ```

   그런 다음 서명 파일을 사용하여 아카이브가 손상되지 않았는지 확인합니다:

   ```shell
   $ gpg --verify swift-<VERSION>-<PLATFORM>.tar.gz.sig
   ...
   gpg: Good signature from "Swift Automatic Signing Key #4 <swift-infrastructure@forums.swift.org>"
   ```

   공개 키가 없어서 `gpg`가 검증에 실패한 경우(`gpg: Can't
check signature: No public key`),
   아래 [활성 서명 키](#active-signing-keys)의 지침에 따라
   키를 키링에 가져오세요.

   다음과 같은 경고가 표시될 수 있습니다:

   ```shell
   gpg: WARNING: This key is not certified with a trusted signature!
   gpg:          There is no indication that the signature belongs to the owner.
   ```

   이 경고는 이 키와 사용자 사이에 신뢰 웹(Web of Trust) 경로가 없음을 의미합니다. 위의 단계에 따라 신뢰할 수 있는 출처에서 키를 가져왔다면 이 경고는 무해합니다.

   <div class="warning" markdown="1">
   `gpg`가 검증에 실패하고 "BAD signature"를 보고하면
   다운로드한 툴체인을 사용하지 마세요.
   대신 가능한 한 자세한 내용을 포함하여 <swift-infrastructure@forums.swift.org>로
   이메일을 보내 주시면 문제를 조사하겠습니다.
   </div>

1. 다음 명령으로 아카이브를 압축 해제합니다:

   ```shell
   $ tar xzf swift-<VERSION>-<PLATFORM>.tar.gz
   ```

   아카이브 위치에 `usr/` 디렉토리가 생성됩니다.

2. 다음과 같이 Swift 툴체인을 PATH에 추가합니다:

   ```shell
   $ export PATH=/path/to/usr/bin:"${PATH}"
   ```

   이제 `swift` 명령으로 REPL을 실행하거나 Swift 프로젝트를 빌드할 수 있습니다.

### 활성 서명 키

Swift 프로젝트는 스냅샷 빌드용 키와 공식 릴리스용 키를 별도로 사용합니다. 4096비트 RSA 키를 사용합니다.

다음 키가 툴체인 패키지 서명에 사용됩니다:

- `Swift Automatic Signing Key #4 <swift-infrastructure@forums.swift.org>`

  다운로드
  : <https://swift.org/keys/{{ automatic_signing_key_file }}>

  지문
  : `E813 C892 820A 6FA1 3755  B268 F167 DF1A CF9C E069`

  Long ID
  : `F167DF1ACF9CE069`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        'E813 C892 820A 6FA1 3755  B268 F167 DF1A CF9C E069'
  ```

  또는

  ```shell
  $ wget -q -O - https://swift.org/keys/{{ automatic_signing_key_file }} | \
   gpg --import -
  ```

- `Swift 5.x Release Signing Key <swift-infrastructure@swift.org>`

다운로드
: <https://swift.org/keys/release-key-swift-5.x.asc>

지문
: `A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561`

Long ID
: `925CC1CCED3D1561`

키를 가져오려면 다음을 실행하세요:

```shell
$ gpg --keyserver hkp://keyserver.ubuntu.com \
      --recv-keys \
      'A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561'
```

또는:

```shell
$ wget -q -O - https://swift.org/keys/release-key-swift-5.x.asc | \
  gpg --import -
```

### 만료된 서명 키

- `Swift Automatic Signing Key #3 <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/{{ automatic_signing_key_file_3 }}>

  지문
  : `8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA`

  Long ID
  : `FAF6989E1BC16FEA`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        '8A74 9566 2C3C D4AE 18D9  5637 FAF6 989E 1BC1 6FEA'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/{{ automatic_signing_key_file_3 }} | \
    gpg --import -
  ```

- `Swift Automatic Signing Key #2 <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/{{ automatic_signing_key_file_2 }}>

  지문
  : `8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4`

  Long ID
  : `7638F1FB2B2B08C4`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        '8513 444E 2DA3 6B7C 1659  AF4D 7638 F1FB 2B2B 08C4'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/{{ automatic_signing_key_file_2 }} | \
    gpg --import -
  ```

- `Swift Automatic Signing Key #1 <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/{{ automatic_signing_key_file_1 }}>

  지문
  : `7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD`

  Long ID
  : `D441C977412B37AD`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        '7463 A81A 4B2E EA1B 551F  FBCF D441 C977 412B 37AD'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/{{ automatic_signing_key_file_1 }} | \
    gpg --import -
  ```

- `Swift 2.2 Release Signing Key <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/release-key-swift-2.2.asc>

  지문
  : `1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F`

  Long ID
  : `9F597F4D21A56D5F`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        '1BE1 E29A 084C B305 F397  D62A 9F59 7F4D 21A5 6D5F'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/release-key-swift-2.2.asc | \
    gpg --import -
  ```

- `Swift 3.x Release Signing Key <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/release-key-swift-3.x.asc>

  지문
  : `A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6`

  Long ID
  : `63BC1CFE91D306C6`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        'A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/release-key-swift-3.x.asc | \
    gpg --import -
  ```

- `Swift 4.x Release Signing Key <swift-infrastructure@swift.org>`

  다운로드
  : <https://swift.org/keys/release-key-swift-4.x.asc>

  지문
  : `5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235`

  Long ID
  : `EF5430F071E1B235`

  키를 가져오려면 다음을 실행하세요:

  ```shell
  $ gpg --keyserver hkp://keyserver.ubuntu.com \
        --recv-keys \
        '5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235'
  ```

  또는:

  ```shell
  $ wget -q -O - https://swift.org/keys/release-key-swift-4.x.asc | \
    gpg --import -
  ```
