//
//  BookSortType.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

// MARK: - Enum 정의

enum PriceSortMode {
  case ascending
  case descending
}

enum FavoriteSortType {
  case price(PriceSortMode)
  case publishedAt(SearchSortType)
  case title(SortDirection)

  var searchSortType: SearchSortType {
    switch self {
    case .title: return .accuracy
    case .publishedAt: return .latest
    case .price: return .accuracy // UI 정책에 따라 .latest로 바꿔도 무방
    }
  }
}
