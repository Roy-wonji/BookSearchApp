//
//  FavoriteBooksStore.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation
import Combine

/// 즐겨찾기한 도서의 ISBN 목록을 관리하는 전역 상태 저장소입니다.
///
/// - 역할: 앱 전체에서 즐겨찾기 도서의 ISBN을 공유 및 관찰할 수 있도록 합니다.
/// - 사용 예시: `@ObservedObject var favoriteBooksStore = FavoriteBooksStore.shared`
///
/// 싱글턴 패턴으로 구현되어, 앱 전역에서 동일한 인스턴스를 사용합니다.
///

// 1) 프로토콜 선언
protocol FavoriteBooksStoreProtocol: ObservableObject {
  var favoriteBooks: Set<String> { get set }
}

// 2) 실제 Store는 프로토콜 채택
final class FavoriteBooksStore: FavoriteBooksStoreProtocol {
  @Published var favoriteBooks: Set<String> = []

  static let shared = FavoriteBooksStore()
}

