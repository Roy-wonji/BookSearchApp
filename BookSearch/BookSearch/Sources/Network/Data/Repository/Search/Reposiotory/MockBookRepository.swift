//
//  MockBookRepository.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

/// 도서 검색/즐겨찾기 저장소의 Mock(테스트용) 구현체입니다.
///
/// - 실제 데이터 저장 없이 항상 기본값 또는 테스트용 응답만 반환합니다.
/// - 단위 테스트, 프리뷰 등에 활용됩니다.
final class MockBookRepository: BookSearchRepositoryProtocol {

  /// 메모리 내 즐겨찾기 ISBN 집합
  private(set) var favoriteISBNs: Set<String>

  /// 메모리 내 즐겨찾기 도서 목록
  private(set) var favoriteBooks: [Book]

  /// 도서 검색 결과 Mock (옵션)
  private let searchModel: BookSearchModel?

  /// 초기화 시 기본 즐겨찾기 도서 목록, 검색 결과 주입 가능
  init(
    initialBooks: [Book] = [],
    searchModel: BookSearchModel? = nil
  ) {
    self.favoriteBooks = initialBooks
    self.favoriteISBNs = Set(initialBooks.compactMap { $0.isbn })
    self.searchModel = searchModel
  }

  /// 도서 검색 결과를 반환합니다. (Mock 데이터 또는 nil)
  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel? {
    return searchModel
  }

  /// 즐겨찾기 토글 동작 (메모리 내에서 토글 처리)
  func toggleFavorite(_ book: Book) async {
    guard let isbn = book.isbn else { return }
    if favoriteISBNs.contains(isbn) {
      // 삭제
      favoriteISBNs.remove(isbn)
      favoriteBooks.removeAll { $0.isbn == isbn }
    } else {
      // 추가
      favoriteISBNs.insert(isbn)
      var fav = book
      fav.isFavorite = true
      favoriteBooks.append(fav)
    }
  }

  /// 도서가 즐겨찾기인지 여부를 반환합니다.
  func isFavorite(_ book: Book) async -> Bool {
    guard let isbn = book.isbn else { return false }
    return favoriteISBNs.contains(isbn)
  }

  /// 즐겨찾기된 도서의 ISBN 집합을 반환합니다.
  func loadFavorites() async -> Set<String> {
    return favoriteISBNs
  }

  /// 테스트/프리뷰용: 즐겨찾기 도서 목록 반환
  func loadFavoriteBooks() async -> [Book] {
    return favoriteBooks
  }

  /// 테스트용: 즐겨찾기 상태를 강제로 세팅
  func setFavorites(_ books: [Book]) {
    self.favoriteBooks = books
    self.favoriteISBNs = Set(books.compactMap { $0.isbn })
  }

  /// 테스트용: 모든 즐겨찾기 초기화
  func clearFavorites() {
    self.favoriteBooks = []
    self.favoriteISBNs = []
  }
}
