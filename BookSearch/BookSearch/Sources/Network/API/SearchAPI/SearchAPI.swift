//
//  SearchAPI.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

enum SearchAPI {
 case searchBook

  var apiDescription: String {
    switch self {
    case .searchBook:
      return "/book"
    }
  }
}
