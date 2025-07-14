# BookSearch

즐겨찾기 기능과 검색 기능을 갖춘 SwiftUI 기반 iOS 북 검색 앱

---

## 📋 요구 사항

* Xcode 15.x 이상
* iOS 16.0 이상 지원
* Swift 5.7 이상

---

## 🚀 빌드 및 실행 방법

1. 이 저장소를 클론합니다.

   ```bash
   git clone https://github.com/YourOrg/BookSearch.git
   cd BookSearch
   ```
2. 의존성을 설치합니다.

   * **Swift Package Manager**: Xcode에서 프로젝트 열 때 자동 Resolve
   * **CocoaPods** (선택):

     ```bash
     pod install
     open BookSearch.xcworkspace
     ```
3. Xcode에서 `BookSearch.xcodeproj` 또는 `BookSearch.xcworkspace`를 열고, 시뮬레이터나 연결된 디바이스를 선택한 뒤 ⌘R로 빌드·실행하세요.

---

## 🧰 사용 프레임워크 & 라이브러리

* **SwiftUI**: 화면 구성
* **Combine** / **@MainActor**: 비동기·상태 관리
* **KeychainHelper**: 즐겨찾기 Keychain 저장
* **Dependency Injection**: `DiContainer` 기반 모듈화
* **AsyncProvider<SearchService>**: 네트워크 요청 추상화
* **Coordinator 패턴**: 화면 전환 관리
* **GitHub Actions** + **Bitbucket API**: CI/CD 자동 동기화

---

## 📂 프로젝트 구조

```
BookSearch/
├─ Config/                   # 개발·릴리즈 환경설정
├─ Resources/                # Assets, Font, Info.plist
├─ Sources/
│  ├─ Common/                # KeychainHelper, TabBarModifier 등
│  ├─ Feature/
│  │  ├─ Favorite/           # 즐겨찾기 탭 (View, ViewModel, Coordinator)
│  │  └─ Search/             # 검색 탭 (View, ViewModel, Coordinator)
│  ├─ Data/                  # Model, DTO, Repository
│  ├─ Domain/                # Entity, UseCase
│  ├─ Network/               # API 서비스, Provider
│  └─ AppEntry               # AppDelegate, App entry point
└─ README.md
```

---

## 🔑 주요 구현 포인트

1. **즐겨찾기(Keychain)**

   * `KeychainHelper`로 Codable 객체 저장/불러오기/삭제
   * Repository에서 Keychain 기반 `toggleFavorite()`, `loadFavoriteBooks()` 구현
   * ViewModel에서 in-memory → UI → Keychain 순으로 동기화

2. **MVVM + Coordinator**

   * ViewModel(`@Published` + `send(_:)`)
   * Coordinator(`NavigationStack`)로 화면 전환 분리
   * `DiContainer`로 모듈화된 DI 구성

3. **네트워크 계층**

   * `AsyncProvider<SearchService>` 통한 추상화
   * DTO → Domain 매핑


4. **UI/UX**

   * `HideableTabBarViewModifier`로 탭바 숨김 지원
   * 페이징 및 client-side 정렬

---

