//
//  Extension+UserDefaults.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/13/25.
//

import Foundation

extension UserDefaults {
  private static let bookCacheKey = "saveBookSearchModel"
  private static let favoriteKey = "favoriteBookISBNs"
  
  func saveFavoriteISBNs(_ isbns: Set<String>) {
    self.set(Array(isbns), forKey: UserDefaults.favoriteKey)
  }
  
  func loadFavoriteISBNs() -> Set<String> {
    let array = self.stringArray(forKey: UserDefaults.favoriteKey) ?? []
    return Set(array)
  }
}

