---
redirect_from: 'server/guides/linux-perf'
layout: page
title: Linux perf
---

## `perf`란?

Linux [`perf` 도구](https://perf.wiki.kernel.org/index.php/Main_Page)는 다양한 용도로 사용할 수 있는 매우 강력한 도구입니다:

- CPU 바운드 프로세스(또는 전체 시스템)를 샘플링하여 애플리케이션의 어떤 부분이 CPU 시간을 소비하는지 분석
- CPU 성능 카운터(PMU) 접근
- 애플리케이션의 특정 함수가 실행될 때 트리거되는 "user probes"(uprobes)

일반적으로 `perf`는 특정 이벤트가 발생할 때 스레드의 콜 스택을 카운트하거나 기록할 수 있습니다. 이러한 이벤트는 다음에 의해 트리거될 수 있습니다:

- 시간(예: 초당 1000회), 시간 프로파일링에 유용합니다. 사용 예시는 [CPU 성능 디버깅 가이드](/documentation/server/guides/performance.html)를 참고하세요.
- 시스템 호출, 시스템 호출이 어디서 발생하는지 확인하는 데 유용합니다.
- 다양한 시스템 이벤트, 예를 들어 컨텍스트 스위치가 발생하는 시점을 알고 싶을 때 유용합니다.
- CPU 성능 카운터, 성능 문제를 CPU의 마이크로아키텍처 세부 사항(예: 분기 예측 실패)으로 추적할 수 있는 경우 유용합니다. 예시는 [SwiftNIO의 고급 성능 분석 가이드](https://github.com/apple/swift-nio/blob/main/docs/advanced-performance-analysis.md)를 참고하세요.
- 그 외 다양한 이벤트

## `perf` 설정

안타깝게도 `perf`를 설정하는 방법은 환경에 따라 다릅니다. 아래에서 다양한 환경별 `perf` 설정 방법을 확인할 수 있습니다.

### `perf` 설치

기술적으로 `perf`는 Linux 커널 소스의 일부이며, Linux 커널 버전과 정확히 일치하는 `perf` 버전을 사용하는 것이 이상적입니다. 하지만 대부분의 경우 "비슷한" 버전의 `perf`로도 충분합니다. 확실하지 않다면 커널보다 약간 오래된 `perf` 버전을 사용하는 것이 더 새로운 버전보다 낫습니다.

- Ubuntu

  ```
  apt-get update && apt-get -y install linux-tools-generic
  ```

  커널 버전별로 다른 `perf`를 패키징하는 Ubuntu에 대한 자세한 정보는 아래를 참고하세요.

- Debian

  ```
  apt-get update && apt-get -y install linux-perf
  ```

- Fedora/RedHat 계열

  ```
  yum install -y perf
  ```

`perf` 설치가 제대로 되었는지 `perf stat -- sleep 0.1`(이미 `root`인 경우) 또는 `sudo perf stat -- sleep 0.1`로 확인할 수 있습니다.

##### 커널 버전을 일치시킬 수 없는 Ubuntu에서의 `perf`

Ubuntu(및 커널 버전별로 `perf`를 패키징하는 다른 배포판)에서 `linux-tools-generic`을 설치한 후 오류가 발생할 수 있습니다. 오류 메시지는 다음과 비슷합니다:

```
$ perf stat -- sleep 0.1
WARNING: perf not found for kernel 5.10.25

  You may need to install the following packages for this specific kernel:
    linux-tools-5.10.25-linuxkit
    linux-cloud-tools-5.10.25-linuxkit

  You may also want to install one of the following packages to keep up to date:
    linux-tools-linuxkit
    linux-cloud-tools-linuxkit
```

가장 좋은 해결 방법은 `perf`가 안내하는 대로 위 패키지 중 하나를 설치하는 것입니다. Docker 컨테이너에서는 커널 버전과 일치시켜야 하므로 불가능할 수 있습니다(특히 Docker for Mac은 VM을 사용하므로 더 어렵습니다). 예를 들어 제안된 `linux-tools-5.10.25-linuxkit`은 실제로 사용할 수 없습니다.

대안으로 다음 방법을 시도할 수 있습니다:

- 이미 `root`이고 셸 `alias`를 선호하는 경우(현재 셸에서만 유효)

  ```
  alias perf=$(find /usr/lib/linux-tools/*/perf | head -1)
  ```

- 일반 사용자이고 `/usr/local/bin/perf`에 링크하는 것을 선호하는 경우

  ```
  sudo ln -s "$(find /usr/lib/linux-tools/*/perf | head -1)" /usr/local/bin/perf
  ```

이후 `perf stat -- sleep 0.1`(이미 `root`인 경우) 또는 `sudo perf stat -- sleep 0.1`이 정상 작동해야 합니다.

### 베어 메탈

베어 메탈 Linux 머신에서는 `perf`를 설치하기만 하면 모든 기능이 완전히 작동합니다.

### Docker(베어 메탈 Linux에서 실행)

`docker run --privileged`로 컨테이너를 시작해야 하며(프로덕션에서는 실행하지 마세요), 그러면 perf에 대한 전체 접근 권한(PMU 포함)을 얻을 수 있습니다.

`perf`가 올바르게 작동하는지 확인하려면 예를 들어 `perf stat -- sleep 0.1`을 실행하세요. 일부 정보 옆에 `<not supported>`가 표시되는지 여부는 CPU의 성능 카운터(PMU)에 접근할 수 있는지에 따라 달라집니다. 베어 메탈의 Docker에서는 정상 작동하므로 `<not supported>`가 표시되지 않아야 합니다.

### Docker for Mac

Docker for Mac은 베어 메탈의 Docker와 비슷하지만, 실제로는 Linux VM에서 호스팅되는 Docker 컨테이너를 실행하므로 복잡성이 추가됩니다. 따라서 커널 버전을 일치시키기 어렵습니다.

위의 설치 지침을 따르면 `perf`가 작동하지만, CPU의 성능 카운터(PMU)에 접근할 수 없으므로 일부 이벤트가 `<not supported>`로 표시됩니다.

```
$ perf stat -- sleep 0.1

 Performance counter stats for 'sleep 0.1':

              0.44 msec task-clock                #    0.004 CPUs utilized
                 1      context-switches          #    0.002 M/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.129 M/sec
   <not supported>      cycles
   <not supported>      instructions
   <not supported>      branches
   <not supported>      branch-misses

       0.102869000 seconds time elapsed

       0.000000000 seconds user
       0.001069000 seconds sys
```

### VM 환경

가상 머신에서는 베어 메탈과 마찬가지로 `perf`를 설치합니다. 모든 기능이 정상 작동하거나, Docker for Mac과 비슷한 결과가 나올 수 있습니다.

하이퍼바이저가 지원(및 허용)해야 하는 것은 "PMU 패스스루" 또는 "PMU 가상화"입니다. VMware Fusion은 vPMC라고 하는 PMU 가상화를 지원합니다(VM 설정 -> Processors & Memory -> Advanced -> Allow code profiling applications in this VM). Mac에서는 이 설정이 안타깝게도 macOS Catalina까지만 지원되며([Big Sur에서는 지원되지 않습니다](https://kb.vmware.com/s/article/81623)).

`libvirt`를 사용하여 하이퍼바이저와 VM을 관리하는 경우, `sudo virsh edit your-domain`을 실행하고 `<cpu .../>` XML 태그를 다음으로 교체하여

    <cpu mode='host-passthrough' check='none'/>

PMU가 게스트로 패스스루되도록 허용할 수 있습니다. 다른 하이퍼바이저의 경우, 인터넷 검색으로 PMU 패스스루를 활성화하는 방법을 대부분 찾을 수 있습니다.
