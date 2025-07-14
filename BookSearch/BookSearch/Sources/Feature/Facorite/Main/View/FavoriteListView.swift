//
//  FavoriteListView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

struct FavoriteListView: View {
  @ObservedObject var viewModel: BookFavoriteViewModel
  @EnvironmentObject private var coordinator: FavoriteCoordinator

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        SearchBarView(text: $viewModel.query)
          .padding(.top, 14)
          .onChange(of: viewModel.query) { newValue in
            viewModel.send(.updateQuery(newValue))
          }


        // ViewModel의 sortType: FavoriteSortType
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

  @ViewBuilder
  private func favoriteDataView() -> some View {
    if viewModel.favoriteBookList.books.isEmpty {
      EmptyResultView(
        mainTitle: "저장한 책이 없습니다",
        subTitle: "검색 탭에서 저장해주세요!"
      )
    } else {
      faviriteList()
    }
  }

  @ViewBuilder
  private func faviriteList() -> some View {
    ScrollView(.vertical) {
      LazyVStack {
        let books = viewModel.favoriteBookList.books
        ForEach(books.indices, id: \.self) { index in
          let model = books[index]
          BookListRowView(book: model) {
            viewModel.send(.toggleFavorite(model))
          }

          .onTapGesture {
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
