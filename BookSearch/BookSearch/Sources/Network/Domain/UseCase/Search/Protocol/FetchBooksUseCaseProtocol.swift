//
//  FetchBooksUseCaseProtocol.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

protocol FetchBooksUseCaseProtocol {
  func execute(request: BookSearchRequest) async throws -> BookSearchModel?
  func toggleFavorite(_ book: Book) async
  func isFavorite(_ book: Book) async -> Bool
  func loadFavorites() async -> Set<String>
}
