//
//  SearchCoordinator.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Combine
import Foundation

import SwiftUI

/// 검색 리스트  탭의 화면 전환을 담당하는 코디네이터입니다.
final class SearchCoordinator: ObservableObject, NavigationControlling {

  // MARK: - NavigationControlling Requirement

  /// 현재 네비게이션 경로 상태입니다.
  ///
  /// `NavigationStack(path:)`에 바인딩되어 화면 이동을 제어합니다.
  @Published var path = NavigationPath()

  // MARK: - Public Methods

  /// 검색 리스트 화면으로 이동합니다.
  ///
  /// 이 메서드를 호출하면 `SeachRoute.searchMain`가
  /// 네비게이션 스택에 추가되어 해당 뷰가 푸시 됩니다.
  func showSearchListMainView() {
    path.append(SearchRoute(route: .searchMain))
  }

  func searchBookDetailView(book: Book) {
    path.append(SearchRoute(route: .searchDetail(book: book)))
  }


  // MARK: - 초기 진입 설정

  /// Coordinator를 시작합니다.
  ///
  /// 기존 스택을 초기화하고, 메인 검색 리스트 화면을 루트로 설정합니다.
  func start() {
    reset()
    showSearchListMainView()
  }
}

