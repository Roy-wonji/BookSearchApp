//
//  MockBookRepository.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

final class MockBookRepository: BookSearchRepositoryProtocol {

  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel? {
    return nil
  }
}
