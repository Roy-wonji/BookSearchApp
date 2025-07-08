//
//  FavoriteCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct FavoriteCoordinatorView: View {
  @EnvironmentObject private var coordinator: FavoriteCoordinator

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      FavoriteListView()
        .navigationDestination(for: FavoriteRoute.self, destination: makeDestination)
    }
  }
}

extension FavoriteCoordinatorView {

  @ViewBuilder
  private func makeDestination(for route: FavoriteRoute) -> some View {
    switch route {
    case .favoriteMain:
      SearchListView()
        .navigationBarBackButtonHidden()

    case .favoriteDetail:
      EmptyView()
        .navigationBarBackButtonHidden()
    }
  }
}
