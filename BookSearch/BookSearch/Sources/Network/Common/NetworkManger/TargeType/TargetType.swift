//
//  TargetType.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

protocol TargetType {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var task: NetworkTask { get }
}
