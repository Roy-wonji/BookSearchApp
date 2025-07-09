//
//  Extension+Data.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

extension Data {
  func decoded<T: Decodable>(as type: T.Type) throws -> T {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: self)
  }
}
