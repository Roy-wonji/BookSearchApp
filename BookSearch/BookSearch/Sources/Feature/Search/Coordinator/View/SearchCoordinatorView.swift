//
//  SearchCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct SearchCoordinatorView: View {
  @EnvironmentObject private var coordinator: SearchCoordinator

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      SearchListView()
        .navigationDestination(for: SearchRoute.self, destination: makeDestination)
    }
  }
}

extension SearchCoordinatorView {

  @ViewBuilder
  private func makeDestination(for route: SearchRoute) -> some View {
    switch route {
    case .searchMain:
      SearchListView()
        .navigationBarBackButtonHidden()

    case .searchDetail:
      EmptyView()
        .navigationBarBackButtonHidden()
    }
  }
}
