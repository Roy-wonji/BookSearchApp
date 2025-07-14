//
//  SearchCoordinatorView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

/// 검색 기능의 네비게이션 흐름을 관리하는 Coordinator View입니다.
///
/// - 역할: 검색 리스트와 상세 화면 간의 네비게이션, 탭바 표시/숨김 상태 관리
struct SearchCoordinatorView: View {
  /// 검색 Coordinator (네비게이션 경로 관리)
  @EnvironmentObject private var coordinator: SearchCoordinator

  /// 검색 리스트 및 상세 화면의 ViewModel
  @StateObject var viewModel = BookListViewModel()

  /// 탭바 숨김 여부를 제어하는 상태값
  @State private var isTabBarHidden: Bool = false

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      // 검색 리스트 화면
      SearchListView(viewModel: viewModel)
        .navigationDestination(for: SearchRoute.self) { route in
          makeDestination(for: route)
        }
        .onAppear {
          isTabBarHidden = false // ✅ 복귀 시 탭바 복원
        }
    }
    // 탭바 숨김/표시 Modifier 적용
    .modifier(HideableTabBarViewModifier(isHidden: isTabBarHidden))
  }
}

extension SearchCoordinatorView {
  /// 네비게이션 목적지 뷰 생성 함수
  /// - Parameter route: 이동할 목적지 라우트
  /// - Returns: 목적지에 해당하는 View
  @ViewBuilder
  private func makeDestination(for route: SearchRoute) -> some View {
    switch route {
    case .searchMain:
      // 검색 리스트 화면
      SearchListView(viewModel: viewModel)

    case .searchDetail(let book):
      // 검색 상세 화면
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
        isTabBarHidden = true // ✅ 상세 진입 시 탭바 숨김
      }
    }
  }
}
