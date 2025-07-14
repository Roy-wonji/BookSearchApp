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

  func toggleFavorite(_ book: Book) async {
    return
  }

  func isFavorite(_ book: Book) async -> Bool {
    return false
  }

  func loadFavorites() async -> Set<String> {
    return [""]
  }

}
