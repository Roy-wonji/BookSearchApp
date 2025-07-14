//
//  BaseTargetType.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

/// 도메인 구분용 enum입니다. (예: 검색 도메인)
enum BookSeachDomain {
  /// 검색 도메인
  case search
}

extension BookSeachDomain {
  /// 도메인별 URL 경로 반환
  var url: String {
    switch self {
    case .search:
      return "search"
    }
  }
}

/// API 타겟의 공통 속성을 정의하는 프로토콜입니다.
///
/// - 도메인, URL 경로, 파라미터 등 API 요청에 필요한 정보를 제공합니다.
protocol BaseTargetType: TargetType {
  /// 도메인 구분값
  var domain: BookSeachDomain { get }
  /// API URL 경로
  var urlPath: String { get }
  /// 요청 파라미터
  var parameters: [String: Any]? { get }
}

// MARK: - BaseTargetType 기본 구현

extension BaseTargetType {
  /// API의 baseURL
  var baseURL: URL {
    return URL(string: BaseAPI.base.apiDescription)!
  }
  
  /// 전체 path (도메인 + urlPath)
  var path: String {
    return domain.url + urlPath
  }
  
  /// 기본 헤더 (인증 없는 헤더 사용)
  var headers: [String : String]? {
    return APIHeader.notAccessTokenHeader
  }
  
  /// 네트워크 요청 Task (파라미터 유무/메서드에 따라 인코딩 방식 분기)
  var task: NetworkTask {
    if let parameters = parameters {
      if method == .get {
        return .requestParameters(
          parameters: parameters,
          encoding: .url
        )
      } else {
        return .requestParameters(
          parameters: parameters,
          encoding: .json
        )
      }
    } else {
      return .requestPlain
    }
  }
}
