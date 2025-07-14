//
//  BookFavoriteViewModelTests.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Testing
@testable import BookSearch
import DiContainer

// 테스트 헬퍼 구조체
struct BookFavoriteViewModelTestHelper {
  /// Mock 저장소와 UseCase를 DIContainer에 명시적으로 등록
  @MainActor
  func makeMockContainer() -> DependencyContainer {
    let container = DependencyContainer()
    container.register(BookFavoriteRepositoryProtocol.self) {
      MockBookFavoriteRepository()
    }
    container.register(BookFavoriteUseCaseProtocol.self) {
      let repo = container.resolveOrDefault(
        BookFavoriteRepositoryProtocol.self,
        default: MockBookFavoriteRepository()
      )
      return BookFavoriteUseCaseImplementation(repository: repo)
    }
    return container
  }

  /// ViewModel 생성 시 반드시 Mock DIContainer를 주입
  @MainActor
  func makeViewModel() -> BookFavoriteViewModel {
    let store = FavoriteBooksStore()
    let container = makeMockContainer()
    return BookFavoriteViewModel(
      container: container,
      favoriteBooksStore: store
    )
  }

  /// 여러 ISBN(공백 구분) 문자열을 각 ISBN 단위로 분리해서 비교
  func containsBook(_ books: [Book], isbn: String) -> Bool {
    let targetISBNs = isbn.components(separatedBy: " ")
    return books.contains { book in
      guard let bookIsbn = book.isbn else { return false }
      let bookISBNs = bookIsbn.components(separatedBy: " ")
      return !Set(targetISBNs).isDisjoint(with: Set(bookISBNs))
    }
  }
}

// 실제 테스트 코드
struct BookFavoriteViewModelTests {
  let helper = BookFavoriteViewModelTestHelper()
  let testBook = BookSearchModel.mock.books.first!

  @Test
  func 초기_로딩_후_목록_정상_조회() async throws {
      // 1) Keychain 초기화 및 mock 즐겨찾기 목록 저장
      try? KeychainHelper.delete(.bookSearchModel)
      try KeychainHelper.save(BookSearchModel.mock, for: .bookSearchModel)

      // 2) ViewModel 생성 (init 내부의 Task가 loadFavorites를 호출)
      let vm = await helper.makeViewModel()

      // 3) Task가 완료될 시간 대기
      try await Task.sleep(nanoseconds: 300_000_000)

      // 4) 즐겨찾기 목록이 BookSearchModel.mock과 동일한지 검증
      await #expect(vm.favoriteBookList.books.count == BookSearchModel.mock.books.count)

      // 5) Store에도 mock의 첫 번째 ISBN이 반영되었는지 검증
      let primary = BookSearchModel
          .mock
          .books
          .first!
          .isbn!
          .components(separatedBy: " ")
          .first!

      await #expect(vm.favoriteBooksStore.favoriteBooks.contains(primary))
  }
  @Test
  func 즐겨찾기_토글_시_목록_변화() async throws {
    let vm = await helper.makeViewModel()
    try? await Task.sleep(nanoseconds: 300_000_000)
    // 즐겨찾기 삭제
    await vm.send(.toggleFavorite(testBook))
    try? await Task.sleep(nanoseconds: 300_000_000)
    await #expect(!helper.containsBook(vm.favoriteBookList.books, isbn: testBook.isbn ?? ""))
    // 즐겨찾기 추가
    await vm.send(.toggleFavorite(testBook))
    try? await Task.sleep(nanoseconds: 300_000_000)
    await #expect(helper.containsBook(vm.favoriteBookList.books, isbn: testBook.isbn ?? ""))
  }

  @Test
  func 검색_기능_동작() async throws {
    let vm = await helper.makeViewModel()
    try? await Task.sleep(nanoseconds: 300_000_000)
    let keyword = String(testBook.title.prefix(2))
    await MainActor.run { vm.query = keyword }
    await #expect(vm.favoriteBookList.books.allSatisfy { $0.title.contains(keyword) })
  }

  @Test
  func 정렬_기능_동작() async throws {
    let vm = await helper.makeViewModel()
    try? await Task.sleep(nanoseconds: 300_000_000)
    await MainActor.run { vm.sortType = .price(.ascending) }
    let sorted = await vm.favoriteBookList.books
     #expect(sorted == sorted.sorted { ($0.salePrice ?? 0) < ($1.salePrice ?? 0) })
  }

  @Test
  func isFavorite_정상_동작() async throws {
    let vm = await helper.makeViewModel()
    try? await Task.sleep(nanoseconds: 300_000_000)
    let isFav = await MainActor.run { vm.isFavorite(testBook) }
     #expect(isFav)
    await vm.send(.toggleFavorite(testBook))
    try? await Task.sleep(nanoseconds: 300_000_000)
    let isFav2 = await MainActor.run { vm.isFavorite(testBook) }
     #expect(!isFav2)
  }
}
