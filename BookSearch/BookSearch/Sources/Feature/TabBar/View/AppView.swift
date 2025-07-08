//
//  AppView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct AppView: View {
  @StateObject private var coordinator = AppCoordinator()
  @StateObject private var serchCoordinator = SearchCoordinator()
  @StateObject private var favoriteCoordinator = FavoriteCoordinator()

  var body: some View {
    VStack(spacing: 0) {
      // Content View
      ZStack {
        switch coordinator.selectedTab {
        case .search:
          SearchCoordinatorView()
            .environmentObject(serchCoordinator)
        case .favorites:
          FavoriteCoordinatorView()
            .environmentObject(favoriteCoordinator)
        }
      }

      // Custom Tab Bar
      tabBar()
    }
  }

}

extension AppView {
@ViewBuilder
  private func tabBar() -> some View {
    // Custom Tab Bar
    HStack {
      Spacer()
      tabBarItem(
        systemName: "magnifyingglass",
        title: "검색",
        tab: .search
      )
      Spacer()
      tabBarItem(
        systemName: "heart.fill",
        title: "즐겨찾기",
        tab: .favorites
      )
      Spacer()
    }
    .frame(height: 56)
    .background(Color.white)
    .shadow(color: .black.opacity(0.1), radius: 4, y: -2)
  }


  @ViewBuilder
  private func tabBarItem(systemName: String, title: String, tab: AppTab) -> some View {
    VStack(spacing: 4) {
      Image(systemName: systemName)
        .font(.system(size: 20))
        .foregroundColor(coordinator.selectedTab == tab ? .blue : .gray)
        .bold()

      Text(title)
        .font(.system(size: 12))
        .foregroundColor(coordinator.selectedTab == tab ? .blue : .gray)
        .bold()
    }
    .padding(.top, 8)
    .onTapGesture {
      coordinator.selectedTab = tab
    }
  }
}
