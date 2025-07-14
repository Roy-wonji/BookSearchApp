//
//  APIHeader.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

/// API 요청에 사용되는 공통 헤더 키를 정의하는 구조체입니다.
struct APIHeader {
  /// Content-Type 헤더 키
  static let contentType   = "Content-Type"
  /// Authorization 헤더 키
  static let accessToken   = "Authorization"
  /// Accept 헤더 키
  static let accept        = "accept"
}

// MARK: - APIHeader 확장

extension APIHeader {
  /// Info.plist에서 KAKAO_KEY 값을 읽어와 Authorization 값으로 사용합니다.
  static var accessTokenHeader: String {
    Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String ?? ""
  }
  
  /// 인증 토큰이 필요 없는 기본 헤더
  public static var notAccessTokenHeader: [String: String] {
    [
      contentType: APIHeaderManger.contentType,
      accept: APIHeaderManger.contentType
    ]
  }
  
  /// 인증 토큰이 포함된 기본 헤더
  public static var baseHeader: [String: String] {
    [
      contentType: APIHeaderManger.contentType,
      accessToken: "KakaoAK \(accessTokenHeader)",
      accept: APIHeaderManger.contentType
    ]
  }
}
