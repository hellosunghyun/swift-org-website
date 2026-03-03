---
layout: page
date: 2024-06-04 15:13:07
title: Swift 개발을 위한 Neovim 설정
author: [etcwilde]
---

[Neovim](https://neovim.io)은 인기 있는 터미널 기반 텍스트 에디터인 *Vim*의 현대적인 재구현입니다.
Neovim은 *Vim*이 원래 _Vi_ 에디터에 가져온 개선 사항에 더해 비동기 연산과 강력한 Lua 바인딩 같은 새로운 기능을 추가하여 빠른 편집 환경을 제공합니다.

이 문서는 Swift 개발을 위한 Neovim 설정 과정을 안내하며, 다양한 플러그인에 대한 설정을 제공하여 Swift 편집 환경을 구축합니다.
설정 파일은 단계별로 구성하며, 문서 끝에 완전히 조립된 최종 버전이 있습니다.
이 문서는 Neovim 사용법 튜토리얼이 아니며 _Neovim_, _Vim_, _Vi_ 같은 모달 텍스트 에디터에 어느 정도 익숙하다고 가정합니다.
또한 컴퓨터에 Swift 도구체인이 이미 설치되어 있다고 가정합니다. 아직 설치하지 않았다면 [Swift 설치 안내](https://www.swift.org/install)를 참고하세요.

이 문서에서는 Ubuntu 22.04를 기준으로 설명하지만, 설정 자체는 최신 버전의 Neovim과 Swift 도구체인을 사용할 수 있는 모든 운영체제에서 작동합니다.

기본 설정 및 구성 내용:

1. Neovim 설치.
2. 플러그인을 관리하기 위한 `lazy.nvim` 설치.
3. SourceKit-LSP 서버 설정.
4. *nvim-cmp*를 사용한 Language-Server 기반 코드 완성 설정.
5. *LuaSnip*을 사용한 스니펫 설정.

다음 섹션이 설정 과정을 안내합니다:

- [사전 요구 사항](#prerequisites)
- [패키지 관리](#packaging-with-lazynvim)
- [Language Server 지원](#language-server-support)
  - [파일 업데이트](#file-updating)
- [코드 완성](#code-completion)
- [스니펫](#snippets)
- [완성된 설정 파일](#files)

> 팁: Neovim, Swift, 패키지 관리자가 이미 설치되어 있다면 [Language Server 지원](#language-server-support) 설정으로 바로 건너뛸 수 있습니다.

> 참고: [사전 요구 사항](#prerequisites) 섹션을 건너뛰는 경우, Neovim 버전이 v0.9.4 이상인지 확인하세요. 그렇지 않으면 일부 Language Server Protocol(LSP) Lua API에서 문제가 발생할 수 있습니다.

## 사전 요구 사항

시작하려면 Neovim을 설치해야 합니다. Neovim이 제공하는 Lua API는 빠르게 발전하고 있습니다. Language Server Protocol(LSP) 통합 지원의 최신 개선 사항을 활용하려면 비교적 최신 버전의 Neovim이 필요합니다.

필자는 `x86_64` 머신에서 Ubuntu 22.04를 사용하고 있습니다. 안타깝게도 Ubuntu 22.04 `apt` 저장소에 포함된 Neovim 버전은 우리가 사용할 많은 API를 지원하기에 너무 오래되었습니다.

이 설치에서는 `snap`을 사용하여 Neovim v0.9.4를 설치했습니다.
Ubuntu 24.04에는 충분히 새로운 버전의 Neovim이 포함되어 있으므로 일반적인 `apt install neovim` 명령으로 설치할 수 있습니다.
다른 운영체제와 Linux 배포판에서 Neovim을 설치하려면 [Neovim 설치 페이지](https://github.com/neovim/neovim/blob/master/INSTALL.md)를 참고하세요.

```console
 $  sudo snap install nvim --classic
 $  nvim --version
NVIM v0.9.4
Build type: RelWithDebInfo
LuaJIT 2.1.1692716794
Compilation: /usr/bin/cc -O2 -g -Og -g -Wall -Wextra -pedantic -Wno-unused-pa...

   system vimrc file: "$VIM/sysinit.vim"
  fall-back for $VIM: "/usr/share/nvim"

Run :checkhealth for more info
```

## 시작하기

Neovim과 Swift가 경로에 정상적으로 설치되었습니다. `vimrc` 파일로 시작할 수도 있지만, Neovim은 vimscript에서 Lua로 전환하는 중입니다. Lua는 실제 프로그래밍 언어이므로 문서를 찾기 쉽고, 더 빠르게 실행되며, 설정을 메인 런루프에서 분리하여 에디터가 빠르게 반응합니다.
vimscript로 `vimrc`를 계속 사용할 수도 있지만, 여기서는 Lua를 사용합니다.

메인 Neovim 설정 파일은 `~/.config/nvim`에 위치합니다. 다른 Lua 파일은 `~/.config/nvim/lua`에 넣습니다. `init.lua`를 만들어 봅시다:

```console
 $  mkdir -p ~/.config/nvim/lua && cd ~/.config/nvim
 $  nvim init.lua
```

> 참고: 아래 예제에는 문서를 쉽게 확인할 수 있도록 플러그인의 GitHub 링크가 포함되어 있습니다. 플러그인 자체를 탐색해 볼 수도 있습니다.

## *lazy.nvim*으로 패키지 관리

모든 것을 수동으로 설정할 수도 있지만, 패키지 관리자를 사용하면 패키지를 최신 상태로 유지하고 새 컴퓨터에 설정을 복사할 때 모든 것이 올바르게 설치되도록 보장합니다. Neovim에는 내장 플러그인 관리자도 있지만, [_lazy.nvim_](https://github.com/folke/lazy.nvim)이 잘 작동합니다.

*lazy.nvim*이 아직 설치되지 않은 경우 설치하고, 런타임 경로에 추가한 다음, 패키지를 설정하는 부트스트래핑 스크립트부터 시작합니다.

`init.lua` 상단에 다음을 작성합니다:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
```

이 코드는 *lazy.nvim*이 존재하지 않으면 클론하고 런타임 경로에 추가합니다. 이제 *lazy.nvim*을 초기화하고 플러그인 스펙을 찾을 위치를 지정합니다.

```lua
require("lazy").setup("plugins")
```

이렇게 하면 *lazy.nvim*이 `lua/` 디렉토리 아래의 `plugins/` 디렉토리에서 각 플러그인을 찾도록 설정됩니다. 플러그인과 관련 없는 자체 설정을 넣을 장소도 필요하므로 `config/`에 넣겠습니다. 지금 디렉토리를 만듭니다.

```console
 $  mkdir lua/plugins lua/config
```

_lazy.nvim_ 설정에 대한 자세한 내용은 [lazy.nvim Configuration](https://lazy.folke.io/configuration)을 참고하세요.

![_lazy.nvim_ 패키지 관리자](/assets/images/zero-to-swift-nvim/Lazy.png)

설정이 정확히 이렇게 보이지는 않을 것입니다.
*lazy.nvim*만 설치했으므로 현재 설정에는 이것만 표시됩니다.
별로 흥미로워 보이지 않아서 몇 가지 추가 플러그인을 넣어 더 보기 좋게 만들었습니다.

작동하는지 확인하려면:

- Neovim을 실행합니다.

  먼저 module plugins에 대한 스펙이 없다는 오류가 표시됩니다. 이는 플러그인이 아직 없기 때문입니다.

- Enter를 누르고 `:Lazy`를 입력합니다.

  *lazy.nvim*이 설치된 플러그인을 나열합니다. 지금은 "lazy.nvim" 하나만 있어야 합니다. 이는 *lazy.nvim*이 자기 자신을 추적하고 업데이트하는 것입니다.

- _lazy.nvim_ 메뉴를 통해 플러그인을 관리할 수 있습니다.
  - `I`를 누르면 새 플러그인을 설치합니다.
  - `U`를 누르면 설치된 플러그인을 업데이트합니다.
  - `X`를 누르면 *lazy.nvim*이 설치했지만 설정에서 더 이상 추적하지 않는 플러그인을 삭제합니다.

## Language Server 지원

Language Server는 에디터 요청에 응답하여 언어별 지원을 제공합니다. Neovim에는 Language Server Protocol(LSP) 지원이 내장되어 있으므로 LSP를 위한 외부 패키지가 필요 없지만, 각 LSP 서버에 대한 설정을 수동으로 추가하는 것은 많은 작업입니다. Neovim에는 LSP 서버를 설정하는 패키지인 [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)이 있습니다.

`lua/plugins/lsp.lua` 아래에 새 파일을 만듭니다. 다음 코드를 추가합니다.

```lua
return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.sourcekit.setup {}
        end,
    }
}
```

이렇게 하면 SourceKit-LSP를 통한 LSP 지원이 활성화되지만 키바인딩이 없어 실용적이지 않습니다. 키바인딩을 설정해 봅시다.

`sourcekit` 서버 설정 아래의 `config` 함수에 LSP 서버가 연결될 때 실행되는 자동 명령을 설정합니다. 키바인딩은 모든 LSP 서버에 적용되어 언어 간 일관된 경험을 제공합니다.

```lua
config = function()
    local lspconfig = require('lspconfig')
    lspconfig.sourcekit.setup {}

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP Actions',
        callback = function(args)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap = true, silent = true})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {noremap = true, silent = true})
        end,
    })
end,
```

![LSP 기반 실시간 오류 메시지](/assets/images/zero-to-swift-nvim/LSP-Error.png)

[피보나치 수열](https://oeis.org/A000045)을 비동기적으로 계산하는 작은 예제 Swift 패키지를 만들었습니다.
`fibonacci` 함수의 참조 위에서 `shift` + `k`를 누르면 함수 시그니처와 함께 해당 함수의 문서가 표시됩니다.
LSP 통합은 코드에 오류가 있다는 것도 보여주고 있습니다.

### 파일 업데이트

SourceKit-LSP는 에디터가 특정 파일이 변경될 때 서버에 알려주는 것에 점점 더 의존하고 있습니다. 이 필요성은 *동적 등록*을 통해 전달됩니다.
무엇을 의미하는지 이해할 필요는 없지만, Neovim은 동적 등록을 구현하지 않습니다. 패키지 매니페스트를 업데이트하거나 `compile_commands.json` 파일에 새 파일을 추가했을 때 Neovim을 재시작하지 않으면 LSP가 작동하지 않는 것을 알아챌 것입니다.

대신, SourceKit-LSP에 이 기능이 필요하다는 것을 알고 있으므로 정적으로 활성화하겠습니다. `sourcekit` 설정 구성을 업데이트하여 `didChangeWatchedFiles` 기능을 수동으로 설정합니다.

```lua
lspconfig.sourcekit.setup {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
```

이 문제에 대해 더 자세히 알고 싶다면 다음 이슈의 대화에서 자세히 설명하고 있습니다:

- [LSP: Implement dynamicRegistration](https://github.com/neovim/neovim/issues/13634)
- [add documentFormattingProvider to server capabilities response](https://github.com/microsoft/vscode-eslint/pull/1307)

## 코드 완성

![Foundation 모듈을 완성하는 LSP 기반 자동완성](/assets/images/zero-to-swift-nvim/LSP-Autocomplete.png)

코드 완성 메커니즘으로 [_nvim-cmp_](https://github.com/hrsh7th/nvim-cmp)를 사용하겠습니다.
파일을 편집하지 않을 때는 코드 완성이 필요 없으므로 삽입 모드에 들어갈 때 지연 로드되도록 *lazy.nvim*에 설정합니다.

```lua
-- lua/plugins/codecompletion.lua
return {
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
    },
}
```

다음으로 코드 완성 결과를 제공할 완성 소스를 설정합니다.
*nvim-cmp*는 완성 소스를 포함하지 않으며, 추가 플러그인으로 제공됩니다.
이 설정에서는 LSP 기반 결과, 파일 경로 완성, 현재 버퍼의 텍스트를 사용합니다. 더 많은 소스는 _nvim-cmp_ Wiki의 [소스 목록](https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources)을 참고하세요.

먼저 *lazy.nvim*에 새 플러그인과 *nvim-cmp*의 의존성을 알려줍니다.
이렇게 하면 *nvim-cmp*가 로드될 때 *lazy.nvim*이 각 플러그인을 초기화합니다.

```lua
-- lua/plugins/codecompletion.lua
return {
    {
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
        },
    },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    { "hrsh7th/cmp-buffer", lazy = true },
}
```

이제 *nvim-cmp*가 코드 완성 소스를 활용하도록 설정해야 합니다.
다른 많은 플러그인과 달리 *nvim-cmp*는 내부 동작을 많이 숨기므로 설정 방식이 약간 다릅니다. 특히 키바인딩 설정 부분에서 차이를 느낄 것입니다. 자체 설정 함수 내에서 모듈을 require하고 setup 함수를 명시적으로 호출합니다.

```lua
{
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
    },
    config = function()
        local cmp = require('cmp')
        local opts = {
            -- Where to get completion results from
            sources = cmp.config.sources {
                { name = "nvim_lsp" },
                { name = "buffer"},
                { name = "path" },
            },
            -- Make 'enter' key select the completion
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = true })
            }),
        }
        cmp.setup(opts)
    end,
},
```

`tab` 키로 완성을 선택하는 것도 인기 있는 옵션이므로 설정해 봅시다.

```lua
mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<tab>"] = cmp.mapping(function(original)
        if cmp.visible() then
            cmp.select_next_item() -- run completion selection if completing
        else
            original()      -- run the original behavior if not completing
        end
    end, {"i", "s"}),
    ["<S-tab>"] = cmp.mapping(function(original)
        if cmp.visible() then
            cmp.select_prev_item()
        else
            original()
        end
    end, {"i", "s"}),
}),
```

완성 메뉴가 표시된 상태에서 `tab`을 누르면 다음 완성 항목이 선택되고 `shift` + `tab`은 이전 항목을 선택합니다. 메뉴가 표시되지 않으면 tab은 기존에 정의된 동작으로 대체됩니다.

## 스니펫

스니펫은 짧은 텍스트를 원하는 것으로 확장하여 워크플로우를 개선하는 좋은 방법입니다. 스니펫 플러그인으로 [_LuaSnip_](https://github.com/L3MON4D3/LuaSnip)을 사용하겠습니다.

플러그인 디렉토리에 스니펫 플러그인을 설정하는 새 파일을 만듭니다.

```lua
-- lua/plugins/snippets.lua
return {
    {
        'L3MON4D3/LuaSnip',
        conifg = function(opts)
            require('luasnip').setup(opts)
            require('luasnip.loaders.from_snipmate').load({ paths = "./snippets" })
        end,
    },
}
```

이제 스니펫 확장을 *nvim-cmp*에 연결합니다. 먼저 *LuaSnip*을 *nvim-cmp*의 의존성으로 추가하여 _nvim-cmp_ 전에 로드되도록 합니다. 그런 다음 tab 키 확장 동작에 연결합니다.

```lua
{
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('cmp')
        local opts = {
            -- Where to get completion results from
            sources = cmp.config.sources {
                { name = "nvim_lsp" },
                { name = "buffer"},
                { name = "path" },
            },
            mapping = cmp.mapping.preset.insert({
                -- Make 'enter' key select the completion
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                -- Super-tab behavior
                ["<tab>"] = cmp.mapping(function(original)
                    if cmp.visible() then
                        cmp.select_next_item() -- run completion selection if completing
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump() -- expand snippets
                    else
                        original()      -- run the original behavior if not completing
                    end
                end, {"i", "s"}),
                ["<S-tab>"] = cmp.mapping(function(original)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.jump(-1)
                    else
                        original()
                    end
                end, {"i", "s"}),
            }),
            snippets = {
                expand = function(args)
                    luasnip.lsp_expand(args)
                end,
            },
        }
        cmp.setup(opts)
    end,
},
```

이제 tab 키가 super-tab 방식으로 다양하게 오버로드되었습니다.

- 완성 창이 열려 있으면 tab을 누르면 목록의 다음 항목이 선택됩니다.
- 스니펫 위에서 tab을 누르면 스니펫이 확장되고, 계속 tab을 누르면 커서가 다음 선택 지점으로 이동합니다.
- 코드 완성도 스니펫 확장도 아닌 경우 일반 `tab` 키처럼 동작합니다.

이제 스니펫을 작성해야 합니다. *LuaSnip*은 인기 있는 [TextMate](https://macromates.com/textmate/manual/snippets), [Visual Studio Code](https://code.visualstudio.com/docs/editor/userdefinedsnippets) 스니펫 형식의 부분 집합과 자체 [Lua 기반](https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua) API를 포함한 여러 스니펫 형식을 지원합니다.

다음은 유용하다고 느낀 스니펫들입니다:

```snipmate
snippet pub "public access control"
  public $0

snippet priv "private access control"
  private $0

snippet if "if statement"
  if $1 {
    $2
  }$0

snippet ifl "if let"
  if let $1 = ${2:$1} {
    $3
  }$0

snippet ifcl "if case let"
  if case let $1 = ${2:$1} {
    $3
  }$0

snippet func "function declaration"
  func $1($2) $3{
    $0
  }

snippet funca "async function declaration"
  func $1($2) async $3{
    $0
  }

snippet guard
  guard $1 else {
    $2
  }$0

snippet guardl
  guard let $1 else {
    $2
  }$0

snippet main
  @main public struct ${1:App} {
    public static func main() {
      $2
    }
  }$0
```

언급할 만한 또 다른 인기 있는 스니펫 플러그인은 [UltiSnips](https://github.com/SirVer/ultisnips)로, 스니펫 정의 시 인라인 Python을 사용하여 매우 강력한 스니펫을 작성할 수 있습니다.

# 결론

모든 것이 올바르게 설정되면 Neovim에서의 Swift 개발은 견고한 경험을 제공합니다. 탐색할 수 있는 수천 개의 플러그인이 있으며, 이 문서는 Neovim에서 Swift 개발 환경을 구축하는 단단한 기반을 제공합니다.

# 파일

다음은 최종 형태의 설정 파일입니다.

```lua
-- init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  ui = {
    icons = {
      cmd = "",
      config = "",
      event = "",
      ft = "",
      init = "",
      keys = "",
      plugin = "",
      runtime = "",
      require = "",
      source = "",
      start = "",
      task = "",
      lazy = "",
    },
  },
})

vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full" -- don't insert, show options

-- line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- textwrap at 80 cols
vim.opt.tw = 80

-- set solarized colorscheme.
-- NOTE: Uncomment this if you have installed solarized, otherwise you'll see
--       errors.
-- vim.cmd.background = "dark"
-- vim.cmd.colorscheme("solarized")
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
```

```lua
-- lua/plugins/codecompletion.lua
return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local opts = {
        sources = cmp.config.sources {
          { name = "nvim_lsp", },
          { name = "path", },
          { name = "buffer", },
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<tab>"] = cmp.mapping(function(original)
            print("tab pressed")
            if cmp.visible() then
              print("cmp expand")
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              print("snippet expand")
              luasnip.expand_or_jump()
            else
              print("fallback")
              original()
            end
          end, {"i", "s"}),
          ["<S-tab>"] = cmp.mapping(function(original)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.jump(-1)
            else
              original()
            end
          end, {"i", "s"}),

        })
      }
      cmp.setup(opts)
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
}
```

```lua
-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
    lspconfig.sourcekit.setup {
      capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = "LSP Actions",
        callback = function(args)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {noremap = true, silent = true})
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {noremap = true, silent = true})
        end,
      })
    end,
  },
}
```

```lua
-- lua/plugins/snippets.lua
return {
  {
    'L3MON4D3/LuaSnip',
    lazy = false,
    config = function(opts)
      local luasnip = require('luasnip')
      luasnip.setup(opts)
      require('luasnip.loaders.from_snipmate').load({ paths = "./snippets"})
    end,
  }
}
```

```snipmate
# snippets/swift.snippets

snippet pub "public access control"
  public $0

snippet priv "private access control"
  private $0

snippet if "if statement"
  if $1 {
    $2
  }$0

snippet ifl "if let"
  if let $1 = ${2:$1} {
    $3
  }$0

snippet ifcl "if case let"
  if case let $1 = ${2:$1} {
    $3
  }$0

snippet func "function declaration"
  func $1($2) $3{
    $0
  }

snippet funca "async function declaration"
  func $1($2) async $3{
    $0
  }

snippet guard
  guard $1 else {
    $2
  }$0

snippet guardl
  guard let $1 else {
    $2
  }$0

snippet main
  @main public struct ${1:App} {
    public static func main() {
      $2
    }
  }$0
```
