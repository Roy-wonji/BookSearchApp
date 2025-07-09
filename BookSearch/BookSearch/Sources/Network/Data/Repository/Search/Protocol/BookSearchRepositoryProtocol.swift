//
//  BookSearchRepositoryProtocol.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

 protocol BookSearchRepositoryProtocol {
  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel?
}
