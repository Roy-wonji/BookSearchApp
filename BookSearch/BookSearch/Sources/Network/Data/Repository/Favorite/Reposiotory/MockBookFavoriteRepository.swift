//
//  MockBookFavoriteRepository.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

final class MockBookFavoriteRepository: BookFavoriteRepositoryProtocol {


  func isFavorite(_ bookId: String) -> Bool {
  return false
  }

  func loadFavoriteBooks() async -> BookSearchModel {
    return .initModel
  }

  func toggleFavorite(_ book: Book) async {
    return
  }
}
