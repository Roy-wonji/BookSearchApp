//
//  SearchRoute.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation

// 검색 화면에서 사용할 라우트 정보를 나타내는 열거형입니다.
///
/// 이 열거형은 실제 네비게이션 스택에 쌓이는 라우트로 사용됩니다.
/// 외부에서는 내부 전용 `Route` 타입을 통해 간접적으로 생성되며,
/// 직접 case 생성을 제한하여 안전한 라우팅 구조를 제공합니다.
enum SearchRoute: Hashable {

  /// 검색 메인 화면
  case searchMain

  /// 검색 상세 화면 (선택된 도서)
  case searchDetail(book: Book)

  // MARK: - 내부 전용 초기화

  /// 내부 Route 값을 기반으로 SearchRoute를 생성합니다.
  ///
  /// 외부에서는 직접 case를 생성하지 않고, 내부에서만 변환을 허용합니다.
  ///
  /// - Parameter route: 내부용 Route enum 값
  init(route: Route) {
    switch route {
    case .searchMain:
      self = .searchMain
    case .searchDetail(let book):
      self = .searchDetail(book: book)
    }
  }

  // MARK: - 내부 전용 라우트 Enum

  /// 외부 접근은 가능하지만 직접 SearchRoute를 생성할 수 없도록 제어하기 위한 내부 enum입니다.
  enum Route {
    case searchMain
    case searchDetail(book: Book)
  }
}
