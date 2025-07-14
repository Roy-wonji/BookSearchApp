//
//  BookSearchUseCaseProtocol.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

/// 도서 검색 및 즐겨찾기 관련 유스케이스 인터페이스 프로토콜입니다.
///
/// - 도서 검색, 즐겨찾기 토글, 즐겨찾기 여부 확인, 즐겨찾기 목록 조회 기능을 제공합니다.
protocol BookSearchUseCaseProtocol {
  /// 도서 검색을 실행합니다.
  ///
  /// - Parameter request: 검색 요청 파라미터
  /// - Returns: BookSearchModel(검색 결과) 또는 nil
  /// - Throws: 네트워크/디코딩 등 오류 발생 시 에러
  func execute(request: BookSearchRequest) async throws -> BookSearchModel?

  /// 도서의 즐겨찾기 상태를 토글(추가/삭제)합니다.
  ///
  /// - Parameter book: 즐겨찾기 상태를 변경할 도서
  func toggleFavorite(_ book: Book) async

  /// 도서가 즐겨찾기인지 여부를 반환합니다.
  ///
  /// - Parameter book: 확인할 도서
  /// - Returns: 즐겨찾기 여부 (true/false)
  func isFavorite(_ book: Book) async -> Bool

  /// 즐겨찾기된 도서의 ISBN 집합을 반환합니다.
  ///
  /// - Returns: 즐겨찾기된 도서의 ISBN Set
  func loadFavorites() async -> Set<String>
}
