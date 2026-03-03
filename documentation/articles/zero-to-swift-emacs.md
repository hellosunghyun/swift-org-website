---
layout: page
date: 2024-06-05 12:00:00
title: Swift 개발을 위한 Emacs 설정
author: [al45tair]
---

Emacs는 Digital Equipment Corporation의 TECO 에디터용 매크로 패키지에서 시작된 고도로 커스터마이징 가능한 텍스트 에디터입니다. Emacs 유사 에디터와 파생 프로그램이 오랜 세월에 걸쳐 다양하게 존재해 왔지만, 이 가이드는 [GNU Emacs](https://www.gnu.org/software/emacs/)에 초점을 맞춥니다.

이 가이드는 Swift 개발을 위해 Emacs를 새로 설치하고 설정하는 과정을 안내합니다. 특정 운영체제를 가정하지 않지만, 필요한 경우 플랫폼별 힌트를 제공합니다. 또한 Emacs 사용법 자체를 가르치는 것은 이 가이드의 범위 밖입니다. Emacs를 배우고 싶다면 다음 자료를 참고하세요: [Emacs Tour](https://www.gnu.org/software/emacs/tour/).

이 가이드에서는 Swift가 이미 설치되어 있다고 가정합니다. 아직 설치하지 않았다면 계속하기 전에 [Swift 웹사이트의 플랫폼별 설치 안내](/install)를 따르세요.

## Emacs 설치

[GNU Emacs 웹사이트](https://www.gnu.org/software/emacs/download.html)에 일반적인 설치 안내가 있습니다. 아래에는 일부 주요 플랫폼에 대한 구체적인 설치 방법을 안내합니다.

### macOS

[Emacs for Mac OS X](https://emacsformacosx.com) 웹사이트에서 표준 Mac 디스크 이미지로 유니버설 바이너리를 제공합니다. 해당 사이트에서 이미지를 다운로드하고 열어서 `Applications` 폴더로 드래그하면 macOS 개발용 네이티브 Emacs를 가장 쉽게 설치할 수 있습니다.

### Microsoft Windows

[가까운 GNU 미러](http://ftpmirror.gnu.org/emacs/windows) 또는 [GNU FTP 메인 서버](http://ftp.gnu.org/gnu/emacs/windows/)에서 Windows용 GNU Emacs를 다운로드할 수 있습니다. `emacs-<version>-installer.exe` 실행 파일을 실행하면 Emacs를 설치하고 바로가기를 설정해 줍니다.

### Debian 기반 Linux (Ubuntu 포함)

터미널에서 다음 명령을 입력합니다:

```console
$ sudo apt-get install emacs
```

GUI 사용 계획이 없는 서버 시스템이나 컨테이너에서는:

```console
$ sudo apt-get install emacs-nox
```

### RedHat 기반 Linux (RHEL, CentOS, Fedora)

터미널에서 다음 명령을 입력합니다:

```console
$ sudo dnf install emacs
```

(이전 빌드에서는 `dnf` 대신 `yum`을 사용해야 할 수 있지만, 사용 가능하다면 `dnf`가 더 최신이고 나은 옵션입니다.)

## Emacs 설정

Emacs 베테랑이라면 Lisp 패키지를 수동으로 다운로드하고 설치하던 것을 기억하겠지만, 요즘은 패키지 관리자를 사용하는 것이 좋습니다. 인기 있는 Emacs 패키지 저장소인 [MELPA](https://melpa.org)도 함께 설정하겠습니다. Emacs를 열고 `C-x C-f ~/.emacs`를 입력한 후 엔터를 누릅니다. 그런 다음 `.emacs` 파일에 다음을 추가합니다:

```lisp
;;; Add MELPA as a package source
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
```

`~/.emacs`를 새 컴퓨터에 복사하기만 해도 모든 것이 바로 동작하도록 [`use-package`](https://github.com/jwiegley/use-package)도 설정하겠습니다. 다음을 추가합니다:

```lisp
;;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
```

이제 `sourcekit-lsp`를 찾을 수 있어야 합니다. Swift 설치 위치에 따라 달라지므로 이를 위한 Lisp 함수를 추가합니다:

```lisp
;;; Locate sourcekit-lsp
(defun find-sourcekit-lsp ()
  (or (executable-find "sourcekit-lsp")
      (and (eq system-type 'darwin)
           (string-trim (shell-command-to-string "xcrun -f sourcekit-lsp")))
      "/usr/local/swift/usr/bin/sourcekit-lsp"))
```

다음으로 유용한 패키지를 설치합니다:

```lisp
;;; Packages we want installed for Swift development

;; .editorconfig file support
(use-package editorconfig
    :ensure t
    :config (editorconfig-mode +1))

;; Swift editing support
(use-package swift-mode
    :ensure t
    :mode "\\.swift\\'"
    :interpreter "swift")

;; Rainbow delimiters makes nested delimiters easier to understand
(use-package rainbow-delimiters
    :ensure t
    :hook ((prog-mode . rainbow-delimiters-mode)))

;; Company mode (completion)
(use-package company
    :ensure t
    :config
    (global-company-mode +1))

;; Used to interface with swift-lsp.
(use-package lsp-mode
    :ensure t
    :commands lsp
    :hook ((swift-mode . lsp)))

;; lsp-mode's UI modules
(use-package lsp-ui
    :ensure t)

;; sourcekit-lsp support
(use-package lsp-sourcekit
    :ensure t
    :after lsp-mode
    :custom
    (lsp-sourcekit-executable (find-sourcekit-lsp) "Find sourcekit-lsp"))
```

외관을 더 깔끔하고 현대적으로 만들기 위해 몇 가지 패키지를 추가합니다. 테마를 설치하거나 글꼴을 변경하는 것도 가능합니다 — Emacs의 커스터마이징 가능성은 거의 무한합니다:

```lisp
;; Powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

;; Spaceline
(use-package spaceline
  :ensure t
  :after powerline
  :config
  (spaceline-emacs-theme))
```

마지막으로, Emacs를 시작할 때마다 스플래시 화면이 보이지 않도록 비활성화하고 툴바도 비활성화합니다:

```lisp
;;; Don't display the start screen
(setq inhibit-startup-screen t)

;;; Disable the toolbar
(tool-bar-mode -1)
```

`C-x C-s`를 입력하여 새 `.emacs` 파일을 저장한 다음 Emacs를 재시작합니다.

## 결론

Emacs에서 Swift 코드를 편집할 수 있도록 설정을 완료했습니다. 구문 강조와 SourceKit-LSP 통합은 물론, 프로젝트별로 탭 너비와 포맷팅 기본 설정을 쉽게 지정할 수 있는 `.editorconfig` 파일 사용과 같은 현대적인 모범 사례도 지원합니다.

## 파일

전체 설정이 담긴 완성된 `.emacs` 파일입니다:

```lisp
;;; Add MELPA as a package source
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;; Locate sourcekit-lsp
(defun find-sourcekit-lsp ()
  (or (executable-find "sourcekit-lsp")
      (and (eq system-type 'darwin)
           (string-trim (shell-command-to-string "xcrun -f sourcekit-lsp")))
      "/usr/local/swift/usr/bin/sourcekit-lsp"))

;;; Packages we want installed for Swift development

;; .editorconfig file support
(use-package editorconfig
    :ensure t
    :config (editorconfig-mode +1))

;; Swift editing support
(use-package swift-mode
    :ensure t
    :mode "\\.swift\\'"
    :interpreter "swift")

;; Rainbow delimiters makes nested delimiters easier to understand
(use-package rainbow-delimiters
    :ensure t
    :hook ((prog-mode . rainbow-delimiters-mode)))

;; Company mode (completion)
(use-package company
    :ensure t
    :config
    (global-company-mode +1))

;; Used to interface with swift-lsp.
(use-package lsp-mode
    :ensure t
    :commands lsp
    :hook ((swift-mode . lsp)))

;; lsp-mode's UI modules
(use-package lsp-ui
    :ensure t)

;; sourcekit-lsp support
(use-package lsp-sourcekit
    :ensure t
    :after lsp-mode
    :custom
    (lsp-sourcekit-executable (find-sourcekit-lsp) "Find sourcekit-lsp"))

;; Powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

;; Spaceline
(use-package spaceline
  :ensure t
  :after powerline
  :config
  (spaceline-emacs-theme))

;;; Don't display the start screen
(setq inhibit-startup-screen t)

;;; Disable the toolbar
(tool-bar-mode -1)
```
