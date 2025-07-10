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
        booksSearchModel = sortClientSide(model) // ✅ 여기서 새 객체를 할당
        // 페이징 끝 여부 갱신
        isEnd = model?.paging.isEnd ?? true
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
    
    // 새로운 배열을 복사해서 정렬
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
    
    // 정렬된 배열로 새로운 모델 생성
    return BookSearchModel(
      books: sortedBooks,
      paging: model.paging
    )
  }
}
