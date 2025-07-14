//
//  BookFavoriteRepositoryProtocol.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

protocol BookFavoriteRepositoryProtocol {
  func loadFavoriteBooks() async -> BookSearchModel
  func toggleFavorite(_ book: Book) async
}
