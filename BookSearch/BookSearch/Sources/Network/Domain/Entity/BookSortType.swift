//
//  BookSortType.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

// MARK: - Enum 정의

/// 가격 정렬 모드 (오름차순/내림차순)
enum PriceSortMode {
  case ascending   ///< 오름차순
  case descending  ///< 내림차순
}

/// 일반 정렬 방향 (오름차순/내림차순)
enum SortDirection {
  case ascending   ///< 오름차순
  case descending  ///< 내림차순
}

/// 검색 결과 정렬 타입
enum SearchSortType: String {
  case accuracy    ///< 정확도순
  case latest      ///< 최신순
}

/// 즐겨찾기 리스트에서 사용할 정렬 타입
enum FavoriteSortType {
  /// 가격 정렬 (오름차순/내림차순)
  case price(PriceSortMode)
  /// 출간일 정렬 (정확도/최신순)
  case publishedAt(SearchSortType)
  /// 제목 정렬 (오름차순/내림차순)
  case title(SortDirection)

  /// SearchSortType으로 변환 (UI 정책에 따라 매핑)
  var searchSortType: SearchSortType {
    switch self {
    case .title: return .accuracy
    case .publishedAt: return .latest
    case .price: return .accuracy // UI 정책에 따라 .latest로 바꿔도 무방
    }
  }
}
