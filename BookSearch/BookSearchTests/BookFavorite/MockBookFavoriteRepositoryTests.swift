//
//  MockBookFavoriteRepositoryTests.swift
//  BookSearchTests
//
//  Created by Wonji Suh  on 7/14/25.
//

import Testing
@testable import BookSearch

/// MockBookFavoriteRepository의 동작을 검증하는 테스트 케이스입니다.
/// - BookSearchModel.mock 데이터를 활용하여 즐겨찾기 목록의 상태 변화와 조회 기능을 테스트합니다.
struct MockBookFavoriteRepositoryTests {
  /// 테스트에 사용할 기본 도서 (mock 데이터의 첫 번째 책)
  let testBook = BookSearchModel.mock.books.first!

  /// 1. 초기 즐겨찾기 목록이 mock 데이터와 동일하게 반환되는지 확인합니다.
  @Test
  func 초기_즐겨찾기_목록_조회() async throws {
    // given: mock 데이터로 초기화된 저장소
    let repo = MockBookFavoriteRepository()
    // when: 즐겨찾기 목록을 조회
    let model = await repo.loadFavoriteBooks()
    // then: mock 데이터와 동일한 개수, 동일한 책이 포함되어 있어야 함
    #expect(model.books.count == BookSearchModel.mock.books.count)
    #expect(model.books.contains(where: { $0.isbn == testBook.isbn }))
  }

  /// 2. 즐겨찾기 토글 시 이미 있는 책이 삭제되는지 테스트합니다.
  @Test
  func 즐겨찾기_토글_삭제() async throws {
    // given: mock 데이터로 초기화된 저장소
    let repo = MockBookFavoriteRepository()
    // when: 이미 mock에 있는 책을 토글(삭제)
    await repo.toggleFavorite(testBook)
    let model = await repo.loadFavoriteBooks()
    // then: 해당 책이 즐겨찾기 목록에서 사라져야 함
    #expect(!model.books.contains(where: { $0.isbn == testBook.isbn }))
  }

  /// 3. 즐겨찾기 토글 시 없는 책이 추가되는지 테스트합니다.
  @Test
  func 즐겨찾기_토글_추가() async throws {
    // given: mock에 없는 ISBN의 새 책
    var newBook = testBook
    newBook.isbn = "NEW-ISBN-123"
    let repo = MockBookFavoriteRepository()
    // when: 토글(추가)
    await repo.toggleFavorite(newBook)
    let model = await repo.loadFavoriteBooks()
    // then: 해당 ISBN의 책이 즐겨찾기 목록에 포함되어야 함
    #expect(model.books.contains(where: { $0.isbn == "NEW-ISBN-123" }))
  }

  /// 4. isFavorite 메서드가 즐겨찾기 여부를 올바르게 반환하는지 테스트합니다.
  @Test
  func isFavorite_존재_여부() async throws {
    // given: mock 데이터로 초기화된 저장소
    let repo = MockBookFavoriteRepository()
    // then: mock에 있는 책의 ISBN은 true, 없는 ISBN은 false 반환
    #expect(repo.isFavorite(testBook.isbn ?? ""))
    #expect(!repo.isFavorite("없는ISBN"))
  }
}
