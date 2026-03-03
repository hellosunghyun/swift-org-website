---
layout: page
date: 2023-11-08 12:00:00
title: Swift에서 C/C++ 라이브러리 래핑하기
author: [etcwilde, ktoso, yim-lee]
---

C/C++로 작성된 훌륭한 라이브러리가 많이 있습니다. 이러한 라이브러리를 Swift로 다시 작성하지 않고도 Swift 코드에서 활용할 수 있습니다. 이 문서에서는 이를 달성하는 몇 가지 방법과 Swift에서 C/C++를 다룰 때의 모범 사례를 설명합니다.

## 패키지

1. 필요한 경우 `Package.swift`, `Sources` 디렉토리 등이 포함된 새 Swift 패키지를 만듭니다.
2. `Sources` 아래에 C/C++ 라이브러리용 새 모듈/디렉토리를 만듭니다. 이 섹션에서는 `CMyLib`이라는 이름을 사용합니다.
   - 모듈 이름에 `C` 접두사를 붙이는 것이 관례입니다. 예: `CDataStaxDriver`.
3. C/C++ 라이브러리의 소스 코드 디렉토리를 `Sources/CMyLib` 아래에 Git 서브모듈로 추가합니다.
   - 올바르게 설정되었다면 Swift 패키지 루트 디렉토리에 다음과 같은 내용의 `.gitmodules` 파일이 있어야 합니다:

   ```
   [submodule "my-lib"]
       	path = Sources/CMyLib/my-lib
       	url = https://github.com/examples/my-lib.git
   ```

4. `Package.swift`를 수정하여 `CMyLib`을 타겟으로 추가하고 소스 및 헤더 파일 위치를 지정합니다.

   ```swift
   .target(
     name: "CMyLib",
     dependencies: [],
     exclude: [
         // 'CMyLib' 하위의 제외할 파일 및/또는
         // 디렉토리의 상대 경로. 예:
         // "./my-lib/src/CMakeLists.txt",
         // "./my-lib/tests",
     ],
     sources: [
         // 'CMyLib' 하위의 소스 파일 및/또는
         // 디렉토리의 상대 경로. 예:
         // "./my-lib/src/foo.c",
         // "./my-lib/src/baz",
     ],
     cSettings: [
         // .headerSearchPath("./my-lib/src"),
     ]
   ),
   ```

   C++ 라이브러리의 경우 `cSettings` 대신 `cxxSettings`를 사용합니다. 타겟 정의에 사용할 수 있는 추가 옵션과 매개변수는 SwiftPM API 문서를 참고하세요.

5. `swift build`로 Swift 패키지를 컴파일해 봅니다. 필요에 따라 `Package.swift`를 조정합니다.

### 모듈 맵

모듈 맵은 사용자 정의 모듈 맵이 없는 한 Clang 타겟(예: `CMyLib`)에 대해 자동으로 생성됩니다. (즉, 헤더 디렉토리에 `module.modulemap` 파일이 존재하지 않는 경우)

모듈 맵 생성 규칙은 [여기](https://github.com/swiftlang/swift-package-manager/blob/main/Sources/PackageLoading/ModuleMapGenerator.swift)에서 확인할 수 있습니다.

### C/C++ 라이브러리 빌드로 생성된 파일 포함하기

일부 C/C++ 라이브러리는 빌드 과정에서 추가로 필요한 파일(예: 설정 파일)을 생성합니다. 이러한 파일을 Swift 패키지에 포함하려면:

1. C/C++ 라이브러리의 루트 디렉토리(예: `Sources/CMyLib/my-lib`)로 이동한 후 빌드합니다.
   - 위 3단계에서 언급했듯이 이 디렉토리는 Git 서브모듈용 디렉토리입니다. <u>이 디렉토리에서는 수정을 하지 않아야 합니다.</u> C/C++ 라이브러리 빌드로 생성된 출력 파일/디렉토리는 `.gitignore`에 추가해야 합니다.
2. `Sources/CMyLib/` 아래에 필요한 파일을 보관할 디렉토리를 만듭니다. (예: `Sources/CMyLib/extra`)
3. C/C++ 빌드 출력에서 생성된 필요한 파일을 이전 단계에서 만든 디렉토리로 복사합니다.
4. `Package.swift`를 업데이트합니다. 2단계에서 만든 디렉토리 경로(즉, `extra`) 또는 개별 파일 경로(예: `./extra/config.h`)를 타겟(즉, `CMyLib`)의 `sources` 배열(소스 파일용) 또는 `.headerSearchPath`(헤더용)에 추가합니다.

### C/C++ 라이브러리의 파일 덮어쓰기

C/C++ 라이브러리에 포함된 것 대신 사용자 정의 구현을 사용하려면:

1. `Sources/CMyLib` 아래에 사용자 정의 코드 파일을 보관할 디렉토리를 만듭니다. (예: `Sources/CMyLib/custom`)
2. 이전 단계에서 만든 디렉토리에 사용자 정의 코드 파일을 추가합니다.
   - 필요한 경우 소스와 헤더 파일을 위한 별도의 하위 디렉토리를 만듭니다.
3. `Package.swift`를 업데이트합니다:
   - 1단계에서 만든 디렉토리 경로(즉, `custom`) 또는 개별 파일 경로(예: `./custom/my_impl.c`)를 타겟(즉, `CMyLib`)의 `sources` 배열(소스 파일용) 또는 `.headerSearchPath`(헤더용)에 추가합니다.
   - C/C++ 라이브러리의 파일 경로를 타겟(즉, `CMyLib`)의 exclude 배열에 추가합니다. (예: `./my-lib/impl.c`)

## CMake

이 예제는 C 라이브러리를 Swift로 가져오는 방법을 다룹니다. 라이브러리를 가져오고, Swift가 import할 수 있도록 modulemap을 제공한 다음, 라이브러리에 링크해야 합니다. C++의 경우에도 메커니즘은 대체로 동일하며, 단일 프로젝트의 일부로 빌드된 C++ 라이브러리와 양방향으로 상호운용하는 예제는 [Swift-CMake 예제 저장소](https://github.com/apple/swift-cmake-examples/tree/main/3_bidirectional_cxx_interop)의 양방향 cxx interop 프로젝트에서 확인할 수 있습니다.

### 라이브러리 가져오기

Swift 라이브러리와 함께 C 라이브러리를 빌드하지 않는 경우, 라이브러리 복사본을 어떻게든 가져와야 합니다.

- ExternalProject
  - 빌드 시점에 실행되며 설정 유연성이 가장 제한적이지만, C/C++ 라이브러리의 빌드를 프로젝트 빌드와 격리합니다.
  - 프로젝트와 의존성 간의 결합도가 낮고, 프로젝트가 실행될 환경에 라이브러리가 설치되어 있지 않을 가능성이 높거나, 의존성 빌드에 대한 어느 정도의 설정 유연성이 필요할 때 적합합니다.
  - 자세한 내용은 [External Project](https://cmake.org/cmake/help/latest/module/ExternalProject.html)에서 확인할 수 있습니다.

```cmake
include(ExternalProject)
ExternalProject_Add(ZLIB
    GIT_REPOSITORY "https://www.github.com/madler/zlib.git"
    GIT_TAG "09155eaa2f9270dc4ed1fa13e2b4b2613e6e4851" # v1.3
    GIT_SHALLOW TRUE

    UPDATE_COMMAND ""

    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
)
ExternalProject_Get_Property(ZLIB INSTALL_DIR)
add_library(zlib STATIC IMPORTED GLOBAL)
set_target_properties(zlib PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
  IMPORTED_LOCATION "${INSTALL_DIR}/lib/libz.a"
)

add_executable(example example.c)
target_link_libraries(example PRIVATE zlib)
```

이 예제는 GitHub에서 zlib v1.3을 다운로드하고 빌드합니다. 고정된 태그를 설정했으므로 CMake가 업데이트를 시도할 필요가 없습니다. 커밋 해시의 내용은 절대 변경되지 않기 때문입니다. External Project로 생성된 `ZLIB` 타겟은 CMake "유틸리티" 라이브러리이므로 직접 링크할 수 없습니다. 대신 `ZLIB_DIR`을 빌드 디렉토리로 설정한 후 `find_package`를 사용하여 찾거나, 이미 위치를 알고 있으므로 임포트된 정적 라이브러리를 만들 수 있습니다. `INTERFACE_INCLUDE_DIRECTORIES`를 zlib 헤더를 설치한 위치로, `IMPORTED_LOCATION`을 정적 아카이브로 설정하면 코드에서 링크할 수 있는 타겟이 됩니다. 그러면 CMake가 임포트된 `zlib` 타겟에 링크하는 모든 타겟에 대해 컴파일러에 헤더 검색 경로와 정적 아카이브 링크를 알려줍니다.

- `FetchContent`
  - 설정 시점에 실행되며 병합된 빌드 그래프를 생성합니다. 라이브러리의 구현 세부사항인 외부 구성요소를 가져올 때 가장 적합합니다. 빌드 그래프가 병합되므로 변수 이름과 타겟은 적절하게 네임스페이스를 지정해야 충돌이 발생하지 않습니다.
  - 프로젝트와 의존성 간의 결합도가 높을 때 적합합니다. 빌드 그래프가 병합되므로 의존성 전체가 아닌 개별 빌드 타겟에 의존할 수 있어 빌드 성능이 향상될 수 있습니다.
  - 자세한 내용은 [FetchContent](https://cmake.org/cmake/help/latest/module/FetchContent.html)에서 확인할 수 있습니다.

- `find_package`
  - sysroot에서 라이브러리와 헤더를 찾습니다. 기본적으로 CMake는 OS의 루트를 sysroot로 사용하지만, 크로스 컴파일을 위해 다른 sysroot로 격리할 수 있습니다.
  - 기본 시스템이나 sysroot에서 시스템 의존성을 가져오거나, `<PackageName>_ROOT`를 사용하여 미리 빌드된 프로젝트를 사용하는 옵션을 배포자에게 제공할 때 적합합니다.
  - 자세한 내용은 [find_package](https://cmake.org/cmake/help/latest/command/find_package.html)에서 확인할 수 있습니다.

CMake를 사용하여 기존 C 라이브러리를 Swift로 래핑하는 예제에서는 `find_package`, 사용자 정의 module-map 파일, 가상 파일시스템(VFS) 오버레이를 사용하며, SQLite 코드베이스의 일부를 Swift가 import할 수 있는 형태로 마이그레이션하는 헬퍼 레이어도 사용합니다.

### 시작하기

기본적인 CMake 설정부터 시작합니다:

```cmake
cmake_minimum_required(VERSION 3.26)
project(SQLiteImportExample LANGUAGES Swift C)
```

Swift와 C를 사용하고 CMake 버전 3.26 이상이 필요한 "SQLiteImportExample"이라는 CMake 프로젝트를 만듭니다.

이 예제에서는 SQLite를 직접 빌드하지 않고 시스템이나 제공된 sysroot에서 가져옵니다.

```cmake
find_package(SQLite3 REQUIRED)
```

`FindSQLite3.cmake` 패키지 파일에 따라 SQLite3를 찾도록 CMake에 지시합니다. 필수 의존성으로 표시했으므로 패키지의 일부를 찾지 못하면 CMake가 빌드 설정을 중단합니다.

찾으면 CMake는 다음 변수를 정의합니다:

- `SQLite3_INCLUDE_DIRS` — `sqlite3.h`가 있는 파일 경로
- `SQLite3_LIBRARIES` — sqlite 사용자가 링크해야 할 라이브러리
- `SQLite3_VERSION` — 찾은 sqlite3 버전
- `SQLite3_FOUND` — SQLite가 발견되었음을 `find_package`에 알리는 데 사용됩니다. `REQUIRED` 패키지로 표시하지 않은 경우 나중에 이 변수를 확인하여 발견 여부를 파악하고, 발견되지 않으면 `ExternalProject`를 사용하여 별도로 빌드할 수 있습니다.

CMake는 `SQLite::SQLite3` 빌드 타겟도 정의하며, 이를 사용하여 빌드 그래프를 통해 의존성과 검색 위치 정보를 쉽게 전파할 수 있습니다. SQLite3 패키지에 대한 문서는 [FindSQLite3](https://cmake.org/cmake/help/latest/module/FindSQLite3.html)에서 확인할 수 있습니다.

### Swift로 SQLite 가져오기

Swift는 헤더 파일을 직접 import할 수 없습니다. SwiftPM이나 Xcode 같은 도구는 브리징 헤더용 modulemap을 자동으로 생성할 수 있지만, CMake 같은 도구는 그렇지 않습니다. modulemap을 직접 작성하면 C 라이브러리가 Swift로 import되는 방식을 더 세밀하게 제어할 수 있습니다. 모듈 맵 파일 작성 방법에 대한 자세한 내용은 [Module Map Language](https://clang.llvm.org/docs/Modules.html#module-map-language) 명세에서 확인할 수 있습니다.

이 예제에서는 `sqlite3.h` 헤더 파일만 Swift에 노출하면 됩니다.

`sqlite3.modulemap` 파일의 내용은 다음과 같습니다:

```c
module CSQLite {
  header "sqlite3.h"
}
```

모듈 이름은 Swift에서 이 모듈을 import할 때 사용하는 이름입니다. 이 예제에서 해당하는 Swift import 문은 `import CSQLite`입니다.

`link "sqlite3"`과 같은 추가 지시문을 포함하여 자동 링크 메커니즘이 sqlite3 라이브러리에 자동으로 링크하도록 지시할 수 있지만, 프로그램에 sqlite 라이브러리에 링크하도록 지시하면 CMake가 자동으로 처리하므로 이 목적에는 불필요합니다.

이제 modulemap 파일을 올바른 위치에 배치해야 합니다. modulemap 파일은 `sqlite.h` 파일 옆에 있어야 하지만, `sqlite.h`의 위치에 따라 접근이 불가능할 수 있습니다. 여기서 가상 파일시스템이 사용됩니다. 가상 파일시스템(VFS)은 컴파일러 관점에서 본 파일시스템 뷰입니다. VFS 오버레이 파일을 사용하면 물리적 드라이브에 실제로 배치하지 않고도 컴파일러 관점에서 파일 이름을 변경하고 파일시스템 어디에나 파일을 배치할 수 있습니다.

VFS 오버레이의 입력 형식은 YAML입니다(JSON은 YAML의 부분 집합이므로 원하면 JSON 객체로 표현할 수도 있습니다). 단점은 이 파일이 루트, 즉 오버라이드하려는 위치에 대한 절대 경로를 요구한다는 것입니다. 작성 위치에 따라 이식이 불가능할 수 있으므로 하드코딩이 작동하지 않을 수 있습니다. 하지만 CMake를 사용하여 시스템에 맞는 오버레이를 동적으로 생성할 수 있습니다. 다음 템플릿을 프로젝트에 추가하고 `sqlite-vfs-overlay.yaml`이라고 합니다.

```yaml
---
version: 0
case-sensitive: false
use-external-names: false
roots:
  - name: '@SQLite3_INCLUDE_DIR@'
    type: directory
    contents:
      - name: module.modulemap
        type: file
        external-contents: '@SQLite3_MODULEMAP_FILE@'
```

하지만 파일이 불완전합니다. 다음 CMake와 오버레이 템플릿을 조합하여 환경에 맞는 최종 오버레이 파일을 생성합니다.

```cmake
# Swift로 SQLite를 import하기 위해 사용자 정의 modulemap을 주입하는 VFS 오버레이 설정
set(SQLite3_MODULEMAP_FILE "${CMAKE_CURRENT_SOURCE_DIR}/sqlite3.modulemap")
configure_file(sqlite-vfs-overlay.yaml "${CMAKE_CURRENT_BINARY_DIR}/sqlite3-overlay.yaml")

target_compile_options(SQLite::SQLite3 INTERFACE
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-vfsoverlay ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-overlay.yaml>"
)
```

결과적으로 `sqlite.h`가 있는 디렉토리에 사용자 정의 modulemap 파일을 주입하면서 `sqlite.3.modulemap`을 `module.modulemap`으로 이름을 변경하는 VFS 오버레이 파일이 생성됩니다. SQLite3 라이브러리를 사용하는 모든 Swift 프로그램은 modulemap을 찾기 위해 관련 VFS 오버레이 파일을 사용해야 합니다. `target_compile_options`를 사용하여 추가합니다. `SQLite::SQLite3`는 임포트된 라이브러리이므로 SQLite 자체의 빌드에는 영향을 줄 수 없어서 `INTERFACE` 옵션으로 추가하여 의존하는 모든 타겟에 전파되도록 합니다.

이 프로젝트에 CMake를 실행하면 SQLite가 없다는 보고(이 경우 사용하려면 설치해야 함)가 나오거나 빌드 디렉토리 상단에 `sqlite3-overlay.yaml`이 생성됩니다.

```yaml
---
version: 0
case-sensitive: false
use-external-names: false
roots:
  - name: '/usr/include'
    type: directory
    contents:
      - name: module.modulemap
        type: file
        external-contents: '/home/ewilde/sqlite-import-example/sqlite3.modulemap'
```

이것은 `sqlite3.h`가 `/usr/include`에 있고 프로젝트 소스가 홈 디렉토리의 디렉토리에 있는 Linux 시스템에서 생성된 결과입니다.

이것으로 import 설정은 충분합니다. 정리하면, 프로젝트에 총 네 개의 파일이 있습니다:

- `sqlite3.modulemap`은 Swift에 어떤 C 헤더 파일이 어떤 import 모듈과 연결되는지 알려줍니다.
- `sqlite-vfs-overlay.yaml`은 실제 시스템을 변경하지 않고 sqlite3 modulemap 파일을 import에 적합한 위치에 주입하도록 Swift에 지시합니다.
- `CMakeLists.txt`는 VFS 오버레이 설정과 프로젝트 빌드를 관리합니다.
- `hello.swift`는 C SQLite 라이브러리를 호출합니다.

```c
// sqlite3.modulemap
module CSQLite {
  header "sqlite3.h"
}
```

```yaml
# sqlite-vfs-overlay.yaml
---
version: 0
case-sensitive: false
use-external-names: false
roots:
  - name: '@SQLite3_INCLUDE_DIR@'
    type: directory
    contents:
      - name: module.modulemap
        type: file
        external-contents: '@SQLite3_MODULEMAP_FILE@'
```

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.26)
project(SQLiteImportExample LANGUAGES Swift C)

find_package(SQLite3 REQUIRED)

# Setup the VFS-overlay to inject the custom modulemap file
set(SQLite3_MODULEMAP_FILE "${CMAKE_CURRENT_SOURCE_DIR}/sqlite3.modulemap")
configure_file(sqlite-vfs-overlay.yaml
               "${CMAKE_CURRENT_BINARY_DIR}/sqlite3-overlay.yaml")
target_compile_options(SQLite::SQLite3 INTERFACE
  "$<$<COMPILE_LANGUAGE:Swift>:SHELL:-vfsoverlay ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-overlay.yaml>")

add_executable(Hello hello.swift)
target_link_libraries(Hello PRIVATE SQLite::SQLite3)
```

```swift
// hello.swift
import CSQLite

public class Database {
    var dbCon: OpaquePointer!

    public struct Flags: OptionSet {
        public let rawValue: Int32

        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }

        public static let readonly = Flags(rawValue: SQLITE_OPEN_READONLY)
        public static let readwrite = Flags(rawValue: SQLITE_OPEN_READWRITE)
        public static let create = Flags(rawValue: SQLITE_OPEN_CREATE)
        public static let deleteOnClose = Flags(rawValue: SQLITE_OPEN_DELETEONCLOSE)
    }

    public init?(filename: String, flags: Flags = [.create, .readwrite]) {
        guard sqlite3_open_v2(filename, &dbCon, flags.rawValue, nil) == SQLITE_OK,
              dbCon != nil else {
            return nil
        }
    }

    deinit {
        sqlite3_close_v2(dbCon)
    }
}

guard let database = Database(filename: ":memory:") else {
    fatalError("Failed to load database for some reason")
}
```

## C/C++ 사용하기

### 래핑된 C/C++ 타입의 수명 관리

초기화와 이후 특정 형태의 "destroy" 호출로 수명이 지정된 C/C++ 타입을 래핑할 때, Swift에서는 두 가지 방법으로 접근할 수 있습니다. 이 상황은 `resource_init()`과 `resource_destroy(the_resource)` API를 가진 C 타입을 래핑할 때 특히 흔합니다.

첫 번째 방법은 Swift 클래스를 사용하여 리소스를 래핑하고 클래스의 `init`/`deinit`으로 수명을 관리하는 것입니다. 다음은 RocksDB의 C 관리 설정 객체를 래핑하는 예입니다:

```swift
public final class WriteOptions {
    let underlying: OpaquePointer!

    public init() {
        underlying = rocksdb_writeoptions_create()
    }

    deinit {
        rocksdb_writeoptions_destroy(underlying)
    }
}
```

두 번째 방법은 "복사 불가능" 타입(다른 언어에서 move-only 타입으로 알려진 것)을 사용하는 것입니다. 복사 불가능 타입을 사용하여 유사한 `WriteOptions` 래퍼를 선언하면 다음과 같습니다:

```swift
public struct WriteOptions: ~Copyable {
    let underlying: OpaquePointer!

    public init() {
        underlying = rocksdb_writeoptions_create()
    }

    deinit {
        rocksdb_writeoptions_destroy(underlying)
    }
}
```

복사 불가능 타입의 단점은 현재 모든 컨텍스트에서 사용할 수 없다는 것입니다. 예를 들어 Swift 5.9에서는 복사 불가능 타입을 필드로 저장하거나 클로저를 통해 전달할 수 없습니다(클로저가 여러 번 사용될 수 있어 복사 불가능 타입이 보장해야 하는 고유성이 깨지기 때문입니다). 장점은 클래스와 달리 복사 불가능 타입에는 참조 카운팅이 수행되지 않는다는 것입니다.
