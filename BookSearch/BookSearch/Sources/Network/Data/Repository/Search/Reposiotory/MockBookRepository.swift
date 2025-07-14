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
  
  /// 도서 검색 결과를 반환합니다. (항상 nil)
  ///
  /// - Parameter request: 검색 요청 파라미터
  /// - Returns: 항상 nil
  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel? {
    return nil
  }
  
  /// 즐겨찾기 토글 동작 (실제 동작 없음)
  ///
  /// - Parameter book: 즐겨찾기 토글할 도서
  func toggleFavorite(_ book: Book) async {
    return
  }
  
  /// 도서가 즐겨찾기인지 여부를 반환합니다. (항상 false)
  ///
  /// - Parameter book: 확인할 도서
  /// - Returns: 항상 false
  func isFavorite(_ book: Book) async -> Bool {
    return false
  }
  
  /// 즐겨찾기된 도서의 ISBN 집합을 반환합니다. (항상 빈 문자열 포함 Set)
  ///
  /// - Returns: [""] (테스트용)
  func loadFavorites() async -> Set<String> {
    return [""]
  }
}
