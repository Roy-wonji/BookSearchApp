//
//  SearchService.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

enum SearchService {
  case search(request: BookSearchRequest)
}

extension SearchService: BaseTargetType {
  var domain: BookSeachDomain {
    return .search
  }
  
  var urlPath: String {
    switch self {
    case .search:
      return SearchAPI.searchBook.apiDescription
    }
  }
  
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

  var method: HTTPMethod {
    switch self {
    case .search:
      return .get
    }
  }

  var headers: [String : String]?{
    return APIHeader.baseHeader
  }
}
