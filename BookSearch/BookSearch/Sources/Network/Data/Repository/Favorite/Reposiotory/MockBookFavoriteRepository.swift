//
//  MockBookFavoriteRepository.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

/// 즐겨찾기 도서 저장소의 Mock(테스트용) 구현체입니다.
///
/// - 실제 데이터 저장 없이 메모리 내에서만 동작합니다.
/// - BookSearchModel.mock을 활용해 mock 데이터를 반환합니다.
/// - 단위 테스트, 프리뷰 등에 활용할 수 있습니다.
final class MockBookFavoriteRepository: BookFavoriteRepositoryProtocol {

  /// 내부 즐겨찾기 모델 (초기값: BookSearchModel.mock)
  private var favoriteModel: BookSearchModel

  /// 생성자에서 mock 모델을 주입할 수 있습니다.
  /// 기본값은 BookSearchModel.mock입니다.
  init(mockModel: BookSearchModel = .mock) {
    self.favoriteModel = mockModel
  }

  /// 도서가 즐겨찾기인지 여부를 반환합니다.
  ///
  /// - Parameter bookId: 도서의 고유 ID(ISBN 등)
  /// - Returns: 해당 도서가 mock 즐겨찾기 목록에 있으면 true, 아니면 false
  func isFavorite(_ bookId: String) -> Bool {
    favoriteModel.books.contains { $0.isbn == bookId }
  }

  /// 즐겨찾기 도서 목록을 반환합니다.
  ///
  /// - Returns: BookSearchModel.mock 또는 주입된 mock 모델
  func loadFavoriteBooks() async -> BookSearchModel {
    favoriteModel
  }

  /// 즐겨찾기 토글 동작 (mock 데이터에 추가/삭제)
  ///
  /// - Parameter book: 즐겨찾기 토글할 도서
  func toggleFavorite(_ book: Book) async {
    guard let isbn = book.isbn else { return }
    var books = favoriteModel.books
    if let idx = books.firstIndex(where: { $0.isbn == isbn }) {
      // 이미 있으면 삭제
      books.remove(at: idx)
    } else {
      // 없으면 추가
      var fav = book
      fav.isFavorite = true
      books.append(fav)
    }
    // paging 정보도 갱신
    favoriteModel = BookSearchModel(
      books: books,
      paging: PagingInfo(
        isEnd: true,
        pageableCount: books.count,
        totalCount: books.count
      )
    )
  }
}
