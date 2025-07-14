//
//  SearchCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct SearchCoordinatorView: View {
  @EnvironmentObject private var coordinator: SearchCoordinator
  @StateObject var viewModel = BookListViewModel()
  @State private var isTabBarHidden: Bool = false
  
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      SearchListView(viewModel: viewModel)
        .navigationDestination(for: SearchRoute.self) { route in
          makeDestination(for: route)
        }
        .onAppear {
          isTabBarHidden = false // ✅ 복귀 시 탭바 복원
        }
    }
    .modifier(HideableTabBarViewModifier(isHidden: isTabBarHidden)) // 💡 명확하게 상태로 적용
  }
}

extension SearchCoordinatorView {
  @ViewBuilder
  private func makeDestination(for route: SearchRoute) -> some View {
    switch route {
    case .searchMain:
      SearchListView(viewModel: viewModel)

    case .searchDetail(let book):
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
        isTabBarHidden = true // ✅ 진입 시 탭바 숨김
      }
    }
  }
}
