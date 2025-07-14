//
//  BookFavoriteUseCaseProtocol.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

/// 즐겨찾기 도서 관련 유스케이스 인터페이스 프로토콜입니다.
///
/// - 즐겨찾기 목록 조회, 즐겨찾기 토글 기능을 제공합니다.
protocol BookFavoriteUseCaseProtocol {
  /// 즐겨찾기 도서 목록을 비동기적으로 로드합니다.
  ///
  /// - Returns: 즐겨찾기 도서 모델(BookSearchModel)
  func loadFavoriteBooks() async -> BookSearchModel
  
  /// 도서의 즐겨찾기 상태를 토글(추가/삭제)합니다.
  ///
  /// - Parameter book: 즐겨찾기 상태를 변경할 도서
  func toggleFavorite(_ book: Book) async
}
