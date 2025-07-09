//
//  BaseTargetType.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

enum BookSeachDomain {
  case search
}

extension BookSeachDomain {
  var url: String {
    switch self {
    case .search:
      return "search"
    }
  }

}

protocol BaseTargetType : TargetType {
  var domain: BookSeachDomain { get }
  var urlPath: String { get }
  var parameters: [String: Any]?{ get }
}


extension BaseTargetType {
  var baseURL: URL {
    return URL(string: BaseAPI.base.apiDescription)!
  }

  var path: String {
    return domain.url + urlPath
  }

  var headers: [String : String]? {
    return APIHeader.notAccessTokenHeader
  }

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


