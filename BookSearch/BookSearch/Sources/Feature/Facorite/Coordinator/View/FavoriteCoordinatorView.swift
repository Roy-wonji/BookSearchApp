//
//  FavoriteCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

/// 즐겨찾기 기능의 네비게이션 흐름을 관리하는 Coordinator View입니다.
///
/// - 역할: 즐겨찾기 리스트 및 상세 화면 간의 네비게이션, 탭바 숨김/표시 상태 관리
struct FavoriteCoordinatorView: View {
  /// 즐겨찾기 Coordinator (네비게이션 경로 관리)
  @EnvironmentObject private var coordinator: FavoriteCoordinator

  /// 즐겨찾기 리스트 및 상세 화면의 ViewModel
  @StateObject var viewModel = BookFavoriteViewModel()

  /// 탭바 숨김 여부를 제어하는 상태값
  @State private var isTabBarHidden: Bool = false

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      // 즐겨찾기 메인 리스트 화면
      FavoriteListView(viewModel: viewModel)
        .navigationDestination(for: FavoriteRoute.self, destination: makeDestination)
    }
    // 탭바 숨김/표시 Modifier 적용
    .modifier(HideableTabBarViewModifier(isHidden: isTabBarHidden))
  }
}

extension FavoriteCoordinatorView {
  /// 네비게이션 목적지 뷰 생성 함수
  /// - Parameter route: 이동할 목적지 라우트
  /// - Returns: 목적지에 해당하는 View
  @ViewBuilder
  private func makeDestination(for route: FavoriteRoute) -> some View {
    switch route {
    case .favoriteMain:
      // 메인으로 돌아올 때도 탭바 숨김 해제
      FavoriteListView(viewModel: viewModel)
        .navigationBarBackButtonHidden()

    case .favoriteDetail(let book):
      // 즐겨찾기 상세 화면
      SearchDetailView(
        book: $viewModel.detailSearchBook,
        isFavorite: viewModel.isFavorite(book),
        onToggleFavorite: {
          viewModel.send(.toggleFavorite(book))
        },
        backAction: {
          coordinator.goBack()
        }
      )
      .navigationBarBackButtonHidden()
      .onAppear {
        // 상세 진입 시 탭바 숨김
        isTabBarHidden = true
      }
      .onDisappear {
        // 상세에서 벗어날 때 탭바 복원
        isTabBarHidden = false
      }
    }
  }
}
