//
//  BookSearchRequest.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

/// 도서 검색 API 요청 파라미터를 담는 구조체입니다.
///
/// - 검색어, 정렬 방식, 페이지, 사이즈 정보를 포함합니다.
struct BookSearchRequest {
  /// 검색어
  let query: String
  /// 정렬 방식
  let sort: SearchSortType
  /// 페이지 번호
  let page: Int
  /// 한 페이지당 결과 개수
  let size: Int
}
