//
//  FavoriteBooksStore.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

final class FavoriteBooksStore: ObservableObject {
  @Published var favoriteBooks: Set<String> = []
  static let shared = FavoriteBooksStore()
}
