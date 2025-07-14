//
//  SearchListViewModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import DiContainer
import LogMacro
import SwiftUI

@MainActor
final class BookListViewModel: ObservableObject {
  // MARK: - 상태 관리
  @Published var booksSearchModel: BookSearchModel? = nil      // 전체 검색 결과 모델
  @Published var isLoading: Bool = false                       // 로딩 여부
  @Published var errorMessage: String? = nil                   // 에러 메시지
  @Published var searchText: String = ""                       // 검색어
  @Published var sortType: SearchSortType = .accuracy          // 정렬 기준 (정확도 or 최신순)
  @Published var sortDirection: SortDirection = .descending    // 정렬 방향
  @Published var currentPage: Int = 1                          // 현재 페이지 (페이징)
  @Published var size = 20                                     // 페이지당 항목 수
  @Published var isEnd: Bool = false                           // 더 이상 불러올 데이터 없음 여부
  @ObservedObject var favoriteBooksStore: FavoriteBooksStore    // 즐겨찾기 ISBN 집합
  @Published var detailSearchBook: Book = .initBook

  private let useCase: FetchBooksUseCaseProtocol               // 유스케이스 의존성 주입

  // MARK: - 초기화
  init(
    container: DependencyContainer = .live,
    favoriteBooksStore: FavoriteBooksStore = .shared
  ) {
    self.favoriteBooksStore = favoriteBooksStore

    // 의존성 주입 또는 기본 구현 등록
    if let resolved: FetchBooksUseCaseProtocol = container.resolve(FetchBooksUseCaseProtocol.self) {
      self.useCase = resolved
    } else {
      if container.resolve(BookSearchRepositoryProtocol.self) == nil {
        container.register(BookSearchRepositoryProtocol.self) {
          BookRepositoryImplementation()
        }
      }
      container.register(FetchBooksUseCaseProtocol.self) {
        let repo = container.resolveOrDefault(BookSearchRepositoryProtocol.self, default: BookRepositoryImplementation())
        return FetchBooksUseCaseImplementation(repository: repo)
      }
      guard let useCaseImpl = container.resolve(FetchBooksUseCaseProtocol.self) else {
        fatalError("FetchBooksUseCaseProtocol resolve 실패")
      }
      self.useCase = useCaseImpl
    }

    // 즐겨찾기 및 캐시 불러오기
    Task {
      await loadFavorites()
      updateBookFavoriteState()
    }
  }

  // MARK: - 액션 정의
  enum Action {
    case onAppear
    case fetchBooks(query: String)
    case booksResponse(Result<BookSearchModel?, Error>)
    case updateSortType(SearchSortType)
    case toggleSortDirection
    case fetchNextPage
    case toggleFavorite(Book)
  }

  // MARK: - 액션 처리
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      send(.fetchBooks(query: searchText))

    case .updateSortType:
      sortType = (sortType == .accuracy) ? .latest : .accuracy
      currentPage = 1
      send(.fetchBooks(query: searchText))

    case .toggleSortDirection:
      sortDirection = (sortDirection == .ascending) ? .descending : .ascending
      currentPage = 1
      send(.fetchBooks(query: searchText))

    case .fetchNextPage:
      guard !isLoading, !isEnd else { return }
      currentPage += 1
      send(.fetchBooks(query: searchText))

    case .fetchBooks(let query):
      isLoading = true
      Task {
        let result: Result<BookSearchModel?, Error>
        do {
          let model = try await useCase.execute(
            request: BookSearchRequest(query: query, sort: sortType, page: currentPage, size: size)
          )
          result = .success(model)
        } catch {
          result = .failure(error)
        }
        await MainActor.run {
          send(.booksResponse(result))
        }
      }

    case .booksResponse(let result):
      isLoading = false
      switch result {
      case .success(let model):
        guard let model else { return }
        isEnd = model.paging.isEnd
        let sorted = sortClientSide(model)
        if currentPage == 1 {
          booksSearchModel = sorted
        } else {
          booksSearchModel?.books.append(contentsOf: sorted.books)
        }
        updateBookFavoriteState()
      case .failure(let error):
        errorMessage = error.localizedDescription
      }

    case .toggleFavorite(let book):
      Task {
        // 1) UseCase 통해 저장소에 반영
        await useCase.toggleFavorite(book)

        // 2) Keychain에서 최신 즐겨찾기 ISBN 집합을 불러와서 store에 반영
        do {
          let loadedISBNs: Set<String> = try KeychainHelper.load(Set<String>.self, for: .favoriteISBNs) ?? []
          favoriteBooksStore.favoriteBooks = loadedISBNs
        } catch {
          Log.debug("❌ Keychain load favoriteISBNs 실패:", error)
          favoriteBooksStore.favoriteBooks = []
        }

        // 3) UI 업데이트
        updateBookFavoriteState()

        // 4) Keychain에 현재 즐겨찾기 BookSearchModel 저장
        if let allBooks = booksSearchModel?.books {
          let favorites = allBooks.filter(\.isFavorite)
          let favoriteModel = BookSearchModel(
            books: favorites,
            paging: PagingInfo(
              isEnd: true,
              pageableCount: favorites.count,
              totalCount: favorites.count
            )
          )
          do {
            try KeychainHelper.save(favoriteModel, for: .bookSearchModel)
            Log.debug("✅ Keychain favoriteModel 저장, count=\(favorites.count)")
          } catch {
            Log.debug("❌ Keychain에 favoriteModel 저장 실패:", error)
          }
        }
      }
    }
  }

  // MARK: - 클라이언트 사이드 정렬
  private func sortClientSide(_ model: BookSearchModel) -> BookSearchModel {
    var sortedBooks = model.books
    switch sortType {
    case .accuracy:
      sortedBooks.sort {
        sortDirection == .ascending
        ? $0.title < $1.title
        : $0.title > $1.title
      }
    case .latest:
      sortedBooks.sort {
        guard let d0 = $0.publishedAt, let d1 = $1.publishedAt else { return false }
        return sortDirection == .ascending ? d0 < d1 : d0 > d1
      }
    }
    return BookSearchModel(books: sortedBooks, paging: model.paging)
  }

  // MARK: - 즐겨찾기 목록 로드 (Keychain에 있으면 그걸로, 없으면 비움)
  func loadFavorites() async {
    var favoriteModel: BookSearchModel? = nil
    do {
      favoriteModel = try KeychainHelper.load(BookSearchModel.self, for: .bookSearchModel)
      Log.debug("🔑 Keychain에 저장된 BookSearchModel:", favoriteModel as Any)
    } catch {
      Log.debug("❌ Keychain에서 BookSearchModel 로드 실패:", error)
    }

    await MainActor.run {
      if let model = favoriteModel {
        let isbns = Set(model.books.compactMap { $0.isbn })
        self.favoriteBooksStore.favoriteBooks = isbns
        print("✅ BookSearchModel 기반으로 favoriteBooks 업데이트:", isbns)
      } else {
        self.favoriteBooksStore.favoriteBooks = []
        Log.debug("🗑️ BookSearchModel이 없으므로 favoriteBooks 비움")
      }
      self.updateBookFavoriteState()
    }
  }

  // MARK: - 즐겨찾기 상태를 Book 객체에 반영
  func updateBookFavoriteState() {
    guard let currentModel = booksSearchModel else { return }
    let updatedBooks = currentModel.books.map { book in
      var b = book
      b.isFavorite = book.isbn.map { favoriteBooksStore.favoriteBooks.contains($0) } ?? false
      return b
    }
    booksSearchModel = BookSearchModel(books: updatedBooks, paging: currentModel.paging)
  }

  func isFavorite(_ book: Book) -> Bool {
    return book.isbn.map { favoriteBooksStore.favoriteBooks.contains($0) } ?? false
  }
}
