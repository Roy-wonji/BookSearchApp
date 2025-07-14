//
//  BookFavoriteViewModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/13/25.
//

import SwiftUI
import DiContainer
import LogMacro

// MARK: - ViewModel

@MainActor
final class BookFavoriteViewModel: ObservableObject {

  @Published var favoriteBookList: BookSearchModel = .initModel
  @ObservedObject var favoriteBooksStore: FavoriteBooksStore

  @Published var query: String = "" {
    didSet { applyFilters() }
  }
  @Published var sortType: FavoriteSortType = .title(.descending)
  @Published var isLoading: Bool = false
  @Published var detailSearchBook: Book = .initBook

  private let useCase: BookFavoriteUseCaseProtocol

  enum Action {
    case onAppear
    case updateQuery(String)
    case toggleSortDirection
    case toggleSortType(SearchSortType)
    case sortByPrice
    case toggleFavorite(Book)
  }

  init(
    container: DependencyContainer = .live,
    favoriteBooksStore: FavoriteBooksStore = .shared
  ) {
    self.favoriteBooksStore = favoriteBooksStore
    if container.resolve(BookFavoriteRepositoryProtocol.self) == nil {
      container.register(BookFavoriteRepositoryProtocol.self) {
        BookFavoriteRepositoryImplementation()
      }
    }
    if container.resolve(BookFavoriteUseCaseProtocol.self) == nil {
      container.register(BookFavoriteUseCaseProtocol.self) {
        let repo = container.resolveOrDefault(
          BookFavoriteRepositoryProtocol.self,
          default: BookFavoriteRepositoryImplementation()
        )
        return BookFavoriteUseCaseImplementation(repository: repo)
      }
    }
    guard let uc = container.resolve(BookFavoriteUseCaseProtocol.self) else {
      fatalError("BookFavoriteUseCaseProtocol resolve 실패")
    }
    self.useCase = uc

    Task { await loadFavoriteBooks() }
  }

  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task { await loadFavoriteBooks() }

    case .updateQuery(let newQuery):
      query = newQuery
      applyFilters()

    case .toggleSortDirection:
      switch sortType {
      case .title(let dir):
        sortType = .title(dir == .ascending ? .descending : .ascending)
      case .publishedAt(let dir):
        sortType = .publishedAt(dir == .accuracy ? .latest : .accuracy)
      case .price(let mode):
        sortType = .price(mode == .ascending ? .descending : .ascending)
      }
      applyFilters()

    case .toggleSortType(let newSearchSortType):
      switch newSearchSortType {
      case .accuracy:
        // 정확도순이면 무조건 방향 토글
        if case .title(let dir) = sortType {
          sortType = .title(dir == .ascending ? .descending : .ascending)
        } else {
          // 아니면 정확도순 descending으로
          sortType = .title(.descending)
        }
      case .latest:
        if case .publishedAt(let dir) = sortType {
          sortType = .publishedAt(dir == .accuracy ? .latest : .accuracy)
        } else {
          sortType = .publishedAt(.accuracy)
        }
      }
      applyFilters()


    case .sortByPrice:
      if case .price(let mode) = sortType {
        sortType = .price(mode == .ascending ? .descending : .ascending)
      } else {
        sortType = .price(.descending)
      }
      applyFilters()

    case .toggleFavorite(let book):
      Task {
        await useCase.toggleFavorite(book)
        await loadFavoriteBooks()
      }
    }
  }

  private func loadFavoriteBooks() async {
    await MainActor.run { isLoading = true }
    let model = await useCase.loadFavoriteBooks()
    await MainActor.run {
      favoriteBookList = model
      favoriteBooksStore.favoriteBooks = Set(model.books.compactMap { $0.isbn })
      applyFilters()
      isLoading = false
    }
  }

  // MARK: - 정렬 함수

  private func sortByPrice(_ books: [Book], mode: PriceSortMode) -> [Book] {
    switch mode {
    case .ascending:
      return books.sorted { ($0.salePrice ?? Int.max) < ($1.salePrice ?? Int.max) }
    case .descending:
      return books.sorted { ($0.salePrice ?? Int.min) > ($1.salePrice ?? Int.min) }
    }
  }

  private func sortByTitle(_ books: [Book], direction: SortDirection) -> [Book] {
    books.sorted {
      direction == .ascending
      ? $0.title < $1.title
      : $0.title > $1.title
    }
  }

  private func sortByPublishedAt(_ books: [Book], direction: SearchSortType) -> [Book] {
    books.sorted {
      guard let d0 = $0.publishedAt, let d1 = $1.publishedAt else { return false }
      return direction == .accuracy ? d0 < d1 : d0 > d1
    }
  }

  // MARK: - 필터/정렬 적용

  private func applyFilters() {
    var filtered = favoriteBookList.books

    // 1. 검색어 필터
    if !query.isEmpty {
      filtered = filtered.filter {
        $0.title.localizedCaseInsensitiveContains(query) ||
        $0.authors.joined(separator: ", ").localizedCaseInsensitiveContains(query)
      }
    }

    // 2. 정렬
    switch sortType {
    case .price(let mode):
      filtered = sortByPrice(filtered, mode: mode)
    case .publishedAt(let direction):
      filtered = sortByPublishedAt(filtered, direction: direction)
    case .title(let direction):
      filtered = sortByTitle(filtered, direction: direction)
    }

    favoriteBookList = BookSearchModel(books: filtered, paging: favoriteBookList.paging)
  }

  func isFavorite(_ book: Book) -> Bool {
    book.isbn.map { favoriteBooksStore.favoriteBooks.contains($0) } ?? false
  }
}
