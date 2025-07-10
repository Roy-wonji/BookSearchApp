//
//  SearchListViewModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import DiContainer

@MainActor
final class BookListViewModel: ObservableObject {
  // MARK: - State
  @Published var booksSearchModel: BookSearchModel? = nil
  @Published var isLoading: Bool = false
  @Published var errorMessage: String? = nil
  @Published var searchText: String = ""
  @Published var sortType: SearchSortType = .accuracy  // ✅ 정렬 타입 상태
  @Published var sortDirection: SortDirection = .descending
  @Published var currentPage: Int = 1
  @Published var size = 20
  @Published var isEnd: Bool = false // paging 종료 여부 (API 응답 기반)


  // MARK: - Dependencies
  private let useCase: FetchBooksUseCaseProtocol

  // MARK: - Init
  init(container: DependencyContainer = .live) {
    if let resolved: FetchBooksUseCaseProtocol = container.resolve(
      FetchBooksUseCaseProtocol.self
    ) {
      self.useCase = resolved
    } else {
      if container.resolve(BookSearchRepositoryProtocol.self) == nil {
        container.register(BookSearchRepositoryProtocol.self) {
          BookRepositoryImplementation()
        }
      }
      container.register(FetchBooksUseCaseProtocol.self) {
        let repo = container.resolveOrDefault(
          BookSearchRepositoryProtocol.self,
          default: BookRepositoryImplementation()
        )
        return FetchBooksUseCaseImplementation(repository: repo)
      }
      guard let uc2 = container.resolve(FetchBooksUseCaseProtocol.self) else {
        fatalError("FetchBooksUseCaseProtocol resolve 실패")
      }
      self.useCase = uc2
    }
  }

  // MARK: - Action
  public enum Action {
    case onAppear
    case fetchBooks(query: String)
    case booksResponse(Result<BookSearchModel?, Error>)
    case updateSortType(SearchSortType)  // ✅ 정렬 타입 변경 액션
    case toggleSortDirection
    case fetchNextPage
  }

  // MARK: - Send
  public func send(_ action: Action) {
    switch action {
    case .onAppear:
      send(.fetchBooks(query: searchText))

    case .updateSortType:
      sortType = (sortType == .accuracy) ? .latest : .accuracy
      send(.fetchBooks(query: searchText))  // 정렬 변경 후 재요청

    case .fetchBooks(let query):
      isLoading = true
      Task {
        let result: Result<BookSearchModel?, Error>
        do {
          let model = try await useCase.execute(
            request: BookSearchRequest(
              query: query,
              sort: sortType,
              page: currentPage,
              size: size
            )
          )
          result = .success(model)
        } catch {
          result = .failure(error)
        }

        await MainActor.run {
          send(.booksResponse(result))
        }
      }

    case .fetchNextPage:
      guard !isLoading, !isEnd else { return }
      currentPage += 1
      send(.fetchBooks(query: searchText)) // 다음 페이지 호출

    case .booksResponse(let result):
      isLoading = false
      switch result {
      case .success(let model):
        // 클라이언트 정렬 후 모델 저장
        let sortedModel = sortClientSide(model)

        // 페이징 정보 반영 (예: 기존 모델에 append)
        if currentPage == 1 {
          // 첫 페이지는 전체 교체
          booksSearchModel = sortedModel
        } else if var existing = booksSearchModel,
                  let newBooks = sortedModel?.books {
          // 다음 페이지는 append
          existing.books.append(contentsOf: newBooks)
          booksSearchModel = existing
        }

        errorMessage = nil

      case .failure(let error):
        booksSearchModel = nil
        errorMessage = error.localizedDescription
      }

    case .toggleSortDirection:
      sortDirection = (sortDirection == .ascending) ? .descending : .ascending
        send(.fetchBooks(query: searchText))  // 정렬 방향 바꾸면 다시 검색
    }
  }


  private func sortClientSide(_ model: BookSearchModel?) -> BookSearchModel? {
    guard let model else { return nil }

    // books가 immutable이라면 새로 복사
    let sortedBooks: [Book]

    switch sortType {
    case .accuracy:
      sortedBooks = model.books.sorted {
        sortDirection == .ascending
        ? $0.title < $1.title
        : $0.title > $1.title
      }

    case .latest:
      // datetime 대신 publishedAt 혹은 date로 교체
      sortedBooks = model.books.sorted {
        guard let date0 = $0.publishedAt, let date1 = $1.publishedAt else { return false }
        return sortDirection == .ascending ? date0 < date1 : date0 > date1
      }
    }

    return BookSearchModel(
      books: sortedBooks,
      paging: model.paging
    )
  }
}
