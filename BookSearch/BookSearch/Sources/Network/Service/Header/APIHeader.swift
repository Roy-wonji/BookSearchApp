//
//  APIHeader.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation


struct APIHeader {
  static let contentType   = "Content-Type"
  static let accessToken   = "Authorization"
  static let accept          = "accept"

}

extension APIHeader {

  static var accessTokenHeader: String {
    Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String ?? ""
  }

  public static var notAccessTokenHeader: Dictionary<String, String> {
    [
      contentType: APIHeaderManger.contentType,
      accept: APIHeaderManger.contentType
    ]
  }


  public static var baseHeader: Dictionary<String, String> {
    [
      contentType: APIHeaderManger.contentType,
      accessToken: "KakaoAK \(accessTokenHeader)",
      accept: APIHeaderManger.contentType
    ]
  }
}
