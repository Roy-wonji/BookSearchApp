//
//  SearchListView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI
import DiContainer

struct SearchListView: View {
  @ObservedObject var viewModel: BookListViewModel
  @EnvironmentObject private var coordinator: SearchCoordinator

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        SearchBarView(text: $viewModel.searchText)
          .padding(.top, 14)


        SortHeaderView(
          sortType: viewModel.sortType,
          onSortTapped: {
            viewModel.send(.toggleSortDirection)
          },
          onToggleSortType: { newValue in
            viewModel.send(.updateSortType(newValue))
          }
        )

        bookListDataView()
          .padding(.top , 10)

        Spacer()

      }

    }

    .onAppear{
      viewModel.send(.onAppear)
      Task {
        await viewModel.loadFavorites()
        viewModel.updateBookFavoriteState()
      }
    }
    .onChange(of: viewModel.searchText) {  newValue in
      viewModel.booksSearchModel?.books = []
      viewModel.send(.fetchBooks(query: newValue))
    }
    .onChange(of: viewModel.favoriteBooksStore.favoriteBooks) { newValue in
      Task {
        await viewModel.loadFavorites()
        viewModel.updateBookFavoriteState()
      }
    }
  }
}


extension SearchListView {

  @ViewBuilder
  private func bookListDataView() -> some View {
    if viewModel.isLoading {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if let books = viewModel.booksSearchModel?.books, books.isEmpty {
      EmptyResultView(
        mainTitle: "검색 결과가 없습니다",
        subTitle: "다른 키워드로 다시 검색해보세요."
      )  // 📌 데이터 없을 경우 Empty UI
    } else {
      bookListView()
    }
  }

  @ViewBuilder
  private func bookListView() -> some View {
    ScrollView(.vertical) {
      LazyVStack {
        let books = viewModel.booksSearchModel?.books ?? []
        ForEach(books.indices, id: \.self) { index in
          let model = books[index]
          BookListRowView(book: model) {
            viewModel.send(.toggleFavorite(model))
          }

          .onTapGesture {
            viewModel.detailSearchBook = model
            coordinator.searchBookDetailView(book: viewModel.detailSearchBook)
          }
          .onAppear {
            // 마지막 셀에 도달하면 다음 페이지 요청
            if index == books.count - 1 {
              viewModel.send(.fetchNextPage)
            }
          }
        }

        // 로딩 인디케이터
        if viewModel.isLoading {
          ProgressView()
            .padding()
        }
      }
      .onAppear {
        // 검색 탭에 진입할 때마다 즐겨찾기 최신 상태 동기화
        Task {
          await viewModel.loadFavorites()
          viewModel.updateBookFavoriteState()
        }
      }
    }
    .scrollIndicators(.hidden)
  }



}



#Preview {
  var viewModel: BookListViewModel = .init()
  SearchListView(viewModel: viewModel)
}
