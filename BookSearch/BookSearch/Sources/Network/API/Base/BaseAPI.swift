//
//  BaseAPI.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

enum BaseAPI : String {
  case base

  var apiDescription: String {
    switch self {
    case .base:
      return "https://\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? "")"
    }
  }
}
