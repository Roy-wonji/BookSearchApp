//
//  FavoriteCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct FavoriteCoordinatorView: View {
  @EnvironmentObject private var coordinator: FavoriteCoordinator
  @StateObject var viewModel = BookFavoriteViewModel()
  @State private var isTabBarHidden: Bool = false

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      // 메인 리스트
      FavoriteListView(viewModel: viewModel)
        .navigationDestination(for: FavoriteRoute.self, destination: makeDestination)
    }
    .modifier(HideableTabBarViewModifier(isHidden: isTabBarHidden))
  }
}

extension FavoriteCoordinatorView {
  @ViewBuilder
  private func makeDestination(for route: FavoriteRoute) -> some View {
    switch route {
    case .favoriteMain:
      // 다시 메인으로 돌아올 때도 탭바 숨김 해제
      FavoriteListView(viewModel: viewModel)
        .navigationBarBackButtonHidden()

    case .favoriteDetail(let book):
      // 상세 화면
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
