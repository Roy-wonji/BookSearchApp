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
    TabView(selection: $coordinator.selectedTab) {
      SearchCoordinatorView()
        .environmentObject(serchCoordinator)
        .tabItem {
          tabBarItem(
            systemName: "magnifyingglass",
            title: "검색",
            tab: .search
          )
        }
        .tag(AppTab.search)

      FavoriteCoordinatorView()
        .environmentObject(favoriteCoordinator)
        .tabItem {
          tabBarItem(
            systemName: "heart.fill",
            title: "즐겨찾기",
            tab: .favorites
          )
        }
        .tag(AppTab.favorites)
    }
  }
}

extension AppView {
  @ViewBuilder
  private func tabBarItem(
    systemName: String,
    title: String,
    tab: AppTab
  ) -> some View {
    VStack(spacing: 4) {
      Image(systemName: systemName)
        .font(.system(size: 20))
        .foregroundColor(coordinator.selectedTab == tab ? .blue30 : .gray40)
        .bold()

      Text(title)
        .pretendardFont(family: .Regular, size: 12)
        .foregroundColor(coordinator.selectedTab == tab ? .blue30 : .gray40)
        .bold()
    }
    .padding(.top, 8)
    .onTapGesture {
      coordinator.selectedTab = tab
    }
  }
}
