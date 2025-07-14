//
//  MockBookFavoriteRepository.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

/// 즐겨찾기 도서 저장소의 Mock(테스트용) 구현체입니다.
///
/// - 실제 데이터 저장 없이 항상 초기값 또는 기본 응답만 반환합니다.
/// - 단위 테스트, 프리뷰 등에 활용됩니다.
final class MockBookFavoriteRepository: BookFavoriteRepositoryProtocol {
  
  /// 도서가 즐겨찾기인지 여부를 반환합니다. (항상 false)
  ///
  /// - Parameter bookId: 도서의 고유 ID(ISBN 등)
  /// - Returns: 항상 false
  func isFavorite(_ bookId: String) -> Bool {
    return false
  }
  
  /// 즐겨찾기 도서 목록을 반환합니다. (항상 빈 모델)
  ///
  /// - Returns: BookSearchModel(.initModel)
  func loadFavoriteBooks() async -> BookSearchModel {
    return .initModel
  }
  
  /// 즐겨찾기 토글 동작 (실제 동작 없음)
  ///
  /// - Parameter book: 즐겨찾기 토글할 도서
  func toggleFavorite(_ book: Book) async {
    return
  }
}
