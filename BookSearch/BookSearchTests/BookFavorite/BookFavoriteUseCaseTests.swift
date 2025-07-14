//
//  BookFavoriteUseCaseTests.swift
//  BookSearchTests
//
//  Created by Wonji Suh  on 7/14/25.
//

import Testing
@testable import BookSearch

/// BookFavoriteUseCaseImplementation의 동작을 검증하는 테스트 케이스입니다.
/// - MockBookFavoriteRepository를 주입하여 실제 저장 없이 상태 변화를 검증합니다.
struct BookFavoriteUseCaseTests {
  /// 테스트용 mock 저장소 (BookSearchModel.mock 데이터로 초기화)
  let mockRepo = MockBookFavoriteRepository()

  /// 테스트 대상 유스케이스 (mockRepo를 주입)
  var useCase: BookFavoriteUseCaseImplementation {
    .init(repository: mockRepo)
  }

  /// 테스트에 사용할 기본 도서 (mock 데이터의 첫 번째 책)
  let testBook = BookSearchModel.mock.books.first!

  /// 즐겨찾기 목록이 정상적으로 조회되는지 테스트합니다.
  @Test
  func 즐겨찾기_목록_조회() async throws {
    // when: 유스케이스에서 즐겨찾기 목록을 조회
    let model = await useCase.loadFavoriteBooks()
    // then: mock 데이터와 동일한 개수, 동일한 책이 포함되어야 함
    #expect(model.books.count == BookSearchModel.mock.books.count)
    #expect(model.books.contains(where: { $0.isbn == testBook.isbn }))
  }

  /// 즐겨찾기 토글 시 이미 있는 책이 삭제되는지 테스트합니다.
  @Test
  func 즐겨찾기_토글_삭제() async throws {
    // when: mock에 이미 있는 책을 토글(삭제)
    await useCase.toggleFavorite(testBook)
    let model = await useCase.loadFavoriteBooks()
    // then: 해당 책이 더 이상 즐겨찾기에 없어야 함
    #expect(!model.books.contains(where: { $0.isbn == testBook.isbn }))
  }

  /// 즐겨찾기 토글 시 없는 책이 추가되는지 테스트합니다.
  @Test
  func 즐겨찾기_토글_추가() async throws {
    // given: mock에 없는 ISBN의 새 책
    var newBook = testBook
    newBook.isbn = "NEW-ISBN-123"
    // when: 토글(추가)
    await useCase.toggleFavorite(newBook)
    let model = await useCase.loadFavoriteBooks()
    // then: 해당 ISBN의 책이 즐겨찾기에 포함되어야 함
    #expect(model.books.contains(where: { $0.isbn == "NEW-ISBN-123" }))
  }
}
