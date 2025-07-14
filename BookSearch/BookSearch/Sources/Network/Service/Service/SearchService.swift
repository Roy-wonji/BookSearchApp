//
//  SearchService.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

/// 도서 검색 관련 API 서비스 enum입니다.
///
/// - 검색 요청 케이스를 정의합니다.
enum SearchService {
  /// 도서 검색 API 요청
  case search(request: BookSearchRequest)
}

// MARK: - BaseTargetType 채택

extension SearchService: BaseTargetType {
  /// 도메인 구분값
  var domain: BookSeachDomain {
    return .search
  }
  
  /// API URL 경로
  var urlPath: String {
    switch self {
    case .search:
      return SearchAPI.searchBook.apiDescription
    }
  }
  
  /// 요청 파라미터
  var parameters: [String: Any]? {
    switch self {
    case let .search(request):
      return [
        "query": request.query,
        "sort": request.sort.rawValue,
        "page": request.page,
        "size": request.size
      ]
    }
  }
  
  /// HTTP 메서드
  var method: HTTPMethod {
    switch self {
    case .search:
      return .get
    }
  }
  
  /// HTTP 헤더
  var headers: [String : String]? {
    return APIHeader.baseHeader
  }
}
