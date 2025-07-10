//
//  SearchListView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import SwiftUI
import DiContainer

struct SearchListView: View {
  @StateObject private var viewModel = BookListViewModel()
  @EnvironmentObject private var coordinator: SearchCoordinator

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        searchBar(text: $viewModel.searchText)
          .padding(.top, 14)

        sortHeaderView(
          sortType: viewModel.sortType,
          onSortTapped:  {
            viewModel.send(.toggleSortDirection)
          },
          onToggleSortType:  { newValue in
            viewModel.send(.updateSortType(newValue))
          }
        )

        bookListDataView()
          .padding(.top , 10)

        Spacer()

      }

    }

    .task{
      viewModel.send(.onAppear)
    }
    .onChange(of: viewModel.searchText) {  newValue in
      viewModel.booksSearchModel?.books = []
      viewModel.send(.fetchBooks(query: newValue))
    }
  }
}


extension SearchListView {

  @ViewBuilder
  private func searchBar(text: Binding<String>) -> some View {
    HStack(spacing: 8) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray40)

      TextField("제목 또는 저자를 입력하세요.", text: text)
        .foregroundColor(.primary)
        .pretendardFont(family: .Medium, size: 18)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(Color(UIColor.systemGray6))
    .cornerRadius(20)
    .padding(.horizontal, 16)
  }


  @ViewBuilder
  func sortHeaderView(
    sortType: SearchSortType,
    onSortTapped: @escaping () -> Void,
    onToggleSortType : @escaping (SearchSortType) -> Void

  ) -> some View {
    HStack {
      Text(sortType == .accuracy ? "정확도순" : "발간일순")
        .pretendardFont(family: .SemiBold, size: 14)
        .foregroundColor(.black)
        .onTapGesture {
          onToggleSortType(sortType)
        }

      Spacer()

      Button(
        action: onSortTapped
      ) {
        HStack(spacing: 4) {
          Image(systemName: "arrow.up.arrow.down")
            .pretendardFont(family: .Medium, size: 12)
            .foregroundStyle(.staticBlack)
          Text("정렬")
            .pretendardFont(family: .Medium, size: 14)
            .foregroundStyle(.staticBlack)

        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }

  @ViewBuilder
  private func bookListDataView() -> some View {
    if viewModel.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if let books = viewModel.booksSearchModel?.books, books.isEmpty {
        emptyResultView()  // 📌 데이터 없을 경우 Empty UI
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
          bookListRow(book: model)
            .onTapGesture {
              coordinator.searchBookDetailView(book: model)
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
    }
    .scrollIndicators(.hidden)
  }


  @ViewBuilder
  private func bookListRow(book: Book) -> some View {
    HStack(alignment: .top, spacing: 12) {
      // 썸네일
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.gray.opacity(0.2))
        .frame(width: 60, height: 80)
        .overlay {
          AsyncImage(url: URL(string: book.thumbnailURL ?? "")) { image in
            image.resizable().scaledToFill()
          } placeholder: {
            Color.gray.opacity(0.1)
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }

      // 도서 정보
      VStack(alignment: .leading, spacing: 4) {
        Text("도서")
          .pretendardFont(family: .Medium, size: 12)
          .foregroundStyle(.gray40)

        Text(book.title)
          .pretendardFont(family: .SemiBold, size: 17)
          .lineLimit(2)

        Text("출판사: \(book.publisher ?? "-")")
          .pretendardFont(family: .Regular, size: 15)
          .foregroundStyle(.gray40)

        Text("저자: \(book.authors.joined(separator: ", "))")
          .pretendardFont(family: .Regular, size: 15)
          .foregroundStyle(.gray40)
      }

      Spacer()

      // 좋아요 아이콘
      Image(systemName: "heart")
        .foregroundStyle(.gray40)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
  }


  @ViewBuilder
  private func emptyResultView() -> some View {
    VStack(spacing: 12) {
      Image(systemName: "book.closed")
        .resizable()
        .scaledToFit()
        .frame(width: 60, height: 60)
        .foregroundStyle(.gray60)

      Text("검색 결과가 없습니다")
        .pretendardFont(family: .Bold, size: 16)
        .foregroundStyle(.gray60)

      Text("다른 키워드로 다시 검색해보세요.")
        .pretendardFont(family: .Medium, size: 14)
        .foregroundStyle(.gray40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
  }
}



#Preview {
  SearchListView()
}
