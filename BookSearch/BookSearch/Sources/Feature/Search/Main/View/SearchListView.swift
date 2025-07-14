//
//  SearchListView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI

/// 검색 결과 리스트를 보여주는 View입니다.
///
/// - 검색 바, 정렬 헤더, 도서 리스트, 로딩/빈 결과 처리 등 다양한 UI 요소를 포함합니다.
struct SearchListView: View {
  /// 도서 리스트 및 상태 관리 ViewModel
  @ObservedObject var viewModel: BookListViewModel

  /// Coordinator: 화면 이동 및 네비게이션 관리
  @EnvironmentObject private var coordinator: SearchCoordinator

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        // 검색 바
        SearchBarView(text: $viewModel.searchText)
          .padding(.top, 14)

        // 정렬 헤더
        SortHeaderView(
          sortType: viewModel.sortType,
          onSortTapped: {
            viewModel.send(.toggleSortDirection)
          },
          onToggleSortType: { newValue in
            viewModel.send(.updateSortType(newValue))
          }
        )

        // 도서 리스트/로딩/빈 결과
        bookListDataView()
          .padding(.top , 10)

        Spacer()
      }
    }
    // 화면 진입 시 초기화 및 즐겨찾기 동기화
    .onAppear{
      viewModel.send(.onAppear)
      Task {
        await viewModel.loadFavorites()
        viewModel.updateBookFavoriteState()
      }
    }
    // 검색어가 변경될 때마다 검색 요청
    .onChange(of: viewModel.searchText) {  newValue in
      viewModel.booksSearchModel?.books = []
      viewModel.send(.fetchBooks(query: newValue))
    }
    // 즐겨찾기 목록이 변경될 때마다 동기화
    .onChange(of: viewModel.favoriteBooksStore.favoriteBooks) { newValue in
      Task {
        await viewModel.loadFavorites()
        viewModel.updateBookFavoriteState()
      }
    }
  }
}

extension SearchListView {

  /// 도서 리스트/로딩/빈 결과 뷰를 반환합니다.
  @ViewBuilder
  private func bookListDataView() -> some View {
    if viewModel.isLoading {
      // 로딩 인디케이터
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if let books = viewModel.booksSearchModel?.books, books.isEmpty {
      // 📌 데이터 없을 경우 Empty UI
      EmptyResultView(
        mainTitle: "검색 결과가 없습니다",
        subTitle: "다른 키워드로 다시 검색해보세요."
      )
    } else {
      bookListView()
    }
  }

  /// 실제 도서 리스트 뷰를 반환합니다.
  @ViewBuilder
  private func bookListView() -> some View {
    ScrollView(.vertical) {
      LazyVStack {
        let books = viewModel.booksSearchModel?.books ?? []
        ForEach(books.indices, id: \.self) { index in
          let model = books[index]
          BookListRowView(book: model) {
            // 즐겨찾기 토글 액션
            viewModel.send(.toggleFavorite(model))
          }
          .onTapGesture {
            // 상세 화면 이동
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

        // 추가 로딩 인디케이터
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
