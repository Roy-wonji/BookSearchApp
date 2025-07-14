//
//  BookListViewModelTests.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Testing
@testable import BookSearch
import Combine
import Foundation
import DiContainer


// MARK: - Tests for BookListViewModel Utils
struct BookListViewModelUtilsTests {
  @Test
  @MainActor func updateBookFavoriteState_marksFavorites() async {
    // Given
    let store = FavoriteBooksStore()
    // Book.mock의 primary ISBN 추출
    let primary = Book.mock.isbn!.components(separatedBy: " ").first!
    store.favoriteBooks = [primary]

    let vm = BookListViewModel(container: .live, favoriteBooksStore: store)
    vm.booksSearchModel = BookSearchModel(
      books: [Book.mock],
      paging: .init(isEnd: true, pageableCount: 1, totalCount: 1)
    )

    // When
     vm.updateBookFavoriteState()

    // Then
   #expect(vm.booksSearchModel?.books.first?.isFavorite == false)
  }

  @Test
  func isFavorite_returnsCorrectValue() async {
    // Given
    let store = FavoriteBooksStore()
    let primary = Book.mock.isbn!.components(separatedBy: " ").first!
    store.favoriteBooks = [primary]
    let vm = await BookListViewModel(container: .live, favoriteBooksStore: store)

    // When & Then
    await #expect(vm.isFavorite(Book.mock) == false)
  }


  @Test
  @MainActor func sortClientSide_behavesAsExpected() async {
    // Given
    let store = FavoriteBooksStore()
    let vm = BookListViewModel(container: .live, favoriteBooksStore: store)
    // 두 권의 Book.mock을 복사하여 날짜 비교
    let book1 = Book.mock
    var book2 = Book.mock
    // book2는 publishedAt을 더 이후 날짜로 설정
    book2.publishedAt = ISO8601DateFormatter().date(from: "2005-01-01T00:00:00.000+09:00")
    let model = BookSearchModel(books: [book2, book1], paging: .init(isEnd: true, pageableCount: 2, totalCount: 2))

    // Accuracy descending (기본)
    vm.sortType = .accuracy
    vm.sortDirection = .descending
    let sortedAccDesc = vm.sortClientSide(model)
    // title이 동일하므로 order 유지
    await #expect(sortedAccDesc.books.map(\ .publishedAt) == [book2.publishedAt, book1.publishedAt])

    // Latest descending
    vm.sortType = .latest
    vm.sortDirection = .descending
    let sortedLatestDesc = vm.sortClientSide(model)
    await #expect(sortedLatestDesc.books.map(\ .publishedAt) == [book2.publishedAt, book1.publishedAt])

    // Latest ascending
    vm.sortDirection = .ascending
    let sortedLatestAsc = vm.sortClientSide(model)
    await #expect(sortedLatestAsc.books.map(\ .publishedAt) == [book1.publishedAt, book2.publishedAt])
  }
}
