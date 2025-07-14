//
//  FavoriteListView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

/// 즐겨찾기한 도서 목록을 보여주는 View입니다.
///
/// - 검색, 정렬, 즐겨찾기 해제, 상세 진입 등 다양한 UI 요소를 포함합니다.
struct FavoriteListView: View {
  /// 즐겨찾기 리스트 및 상태 관리 ViewModel
  @ObservedObject var viewModel: BookFavoriteViewModel

  /// Coordinator: 화면 이동 및 네비게이션 관리
  @EnvironmentObject private var coordinator: FavoriteCoordinator

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        // 검색 바
        SearchBarView(text: $viewModel.query)
          .padding(.top, 14)
          .onChange(of: viewModel.query) { newValue in
            viewModel.send(.updateQuery(newValue))
          }

        // 정렬 헤더
        SortHeaderView(
          sortType: viewModel.sortType.searchSortType,
          showFilter: true,
          onSortTapped: {
            viewModel.send(.toggleSortDirection)
          },
          onToggleSortType: { newSearchSortType in
            viewModel.send(.toggleSortType(newSearchSortType))
          },
          onFilterTapped: {
            viewModel.send(.sortByPrice)
          }
        )

        // 즐겨찾기 데이터/빈 결과
        favoriteDataView()

        Spacer()
      }
      .onAppear() {
        viewModel.send(.onAppear)
      }
    }
  }
}

extension FavoriteListView {

  /// 즐겨찾기 데이터가 없으면 빈 결과, 있으면 리스트를 보여줍니다.
  @ViewBuilder
  private func favoriteDataView() -> some View {
    if viewModel.favoriteBookList.books.isEmpty {
      EmptyResultView(
        mainTitle: "저장한 책이 없습니다",
        subTitle: "검색 탭에서 저장해주세요!"
      )
    } else {
      favoriteList()
    }
  }

  /// 즐겨찾기 도서 리스트 뷰를 반환합니다.
  @ViewBuilder
  private func favoriteList() -> some View {
    ScrollView(.vertical) {
      LazyVStack {
        let books = viewModel.favoriteBookList.books
        ForEach(books.indices, id: \.self) { index in
          let model = books[index]
          BookListRowView(book: model) {
            // 즐겨찾기 해제 액션
            viewModel.send(.toggleFavorite(model))
          }
          .onTapGesture {
            // 상세 화면 이동
            viewModel.detailSearchBook = model
            coordinator.searchFavoriteDetailView(book: model)
          }
        }

        // 로딩 인디케이터
        if viewModel.isLoading {
          ProgressView()
            .padding()
        }
      }
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  @StateObject var viewModel = BookFavoriteViewModel()
  FavoriteListView(viewModel: viewModel)
}
