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

/// 즐겨찾기 도서 목록 관리 ViewModel
///
/// - 기능: 즐겨찾기 목록 로딩, 검색, 정렬, 즐겨찾기 토글 등
@MainActor
final class BookFavoriteViewModel: ObservableObject {
  
  /// 즐겨찾기 도서 리스트 (검색/정렬 반영)
  @Published var favoriteBookList: BookSearchModel = .initModel
  
  /// 즐겨찾기 ISBN 저장소 (전역 공유)
  @ObservedObject var favoriteBooksStore: FavoriteBooksStore
  
  /// 검색어 (변경 시 자동으로 필터 적용)
  @Published var query: String = "" {
    didSet { applyFilters() }
  }
  
  /// 정렬 타입 (제목, 출판일, 금액 등)
  @Published var sortType: FavoriteSortType = .title(.descending)
  
  /// 데이터 로딩 상태
  @Published var isLoading: Bool = false
  
  /// 상세 조회용 도서 모델
  @Published var detailSearchBook: Book = .initBook
  
  /// 즐겨찾기 관련 UseCase
  private let useCase: BookFavoriteUseCaseProtocol
  
  /// View에서 발생하는 액션 정의
  enum Action {
    case onAppear
    case updateQuery(String)
    case toggleSortDirection
    case toggleSortType(SearchSortType)
    case sortByPrice
    case toggleFavorite(Book)
  }
  
  /// ViewModel 초기화
  /// - Parameters:
  ///   - container: 의존성 주입 컨테이너 (기본값: .live)
  ///   - favoriteBooksStore: 즐겨찾기 저장소 (기본값: .shared)
  init(
    container: DependencyContainer = .live,
    favoriteBooksStore: FavoriteBooksStore = .shared
  ) {
    self.favoriteBooksStore = favoriteBooksStore
    
    // Repository, UseCase DI 등록
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
    
    // 최초 데이터 로딩
    Task { await loadFavoriteBooks() }
  }
  
  /// View에서 발생한 액션 처리 함수
  /// - Parameter action: View에서 발생한 액션
  func send(_ action: Action) {
    switch action {
    case .onAppear:
      Task { await loadFavoriteBooks() }
      
    case .updateQuery(let newQuery):
      query = newQuery
      applyFilters()
      
    case .toggleSortDirection:
      // 정렬 방향 토글 (제목/출판일/금액)
      switch sortType {
      case .title(let dir):
        sortType = .title(dir == .ascending ? .descending : .ascending)
      case .publishedAt(let dir):
        // 잘못된 부분: SearchSortType이 아니라 SortDirection을 써야 합니다!
        sortType = .publishedAt(dir == .accuracy ? .latest : .accuracy)
      case .price(let mode):
        sortType = .price(mode == .ascending ? .descending : .ascending)
      }
      applyFilters()
      
    case .toggleSortType(let newSearchSortType):
      // 정확도순/발간일순 토글
      switch newSearchSortType {
      case .accuracy:
        // 이미 정확도순이면 방향 토글, 아니면 descending으로 변경
        if case .title(let dir) = sortType {
          sortType = .title(dir == .ascending ? .descending : .ascending)
        } else {
          sortType = .title(.descending)
        }
      case .latest:
        // 이미 발간일순이면 방향 토글, 아니면 descending으로 변경
        if case .publishedAt(let dir) = sortType {
          sortType = .publishedAt(dir == .accuracy ? .latest : .accuracy)
        } else {
          sortType = .publishedAt(.accuracy)
        }
      }
      applyFilters()
      
    case .sortByPrice:
      // 금액 정렬 토글
      if case .price(let mode) = sortType {
        sortType = .price(mode == .ascending ? .descending : .ascending)
      } else {
        sortType = .price(.descending)
      }
      applyFilters()
      
    case .toggleFavorite(let book):
      // 즐겨찾기 추가/삭제
      Task {
        await useCase.toggleFavorite(book)
        await loadFavoriteBooks()
      }
    }
  }
  
  /// 즐겨찾기 도서 목록 비동기 로딩
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
  
  /// 금액 정렬
  private func sortByPrice(_ books: [Book], mode: PriceSortMode) -> [Book] {
    switch mode {
    case .ascending:
      return books.sorted { ($0.salePrice ?? Int.max) < ($1.salePrice ?? Int.max) }
    case .descending:
      return books.sorted { ($0.salePrice ?? Int.min) > ($1.salePrice ?? Int.min) }
    }
  }
  
  /// 제목 정렬
  private func sortByTitle(_ books: [Book], direction: SortDirection) -> [Book] {
    books.sorted {
      direction == .ascending
      ? $0.title < $1.title
      : $0.title > $1.title
    }
  }
  
  /// 출판일 정렬
  private func sortByPublishedAt(_ books: [Book], direction: SearchSortType) -> [Book] {
    books.sorted {
      guard let d0 = $0.publishedAt, let d1 = $1.publishedAt else { return false }
      return direction == .accuracy ? d0 < d1 : d0 > d1
    }
  }
  
  // MARK: - 필터/정렬 적용
  
  /// 검색어 및 정렬 기준에 따라 리스트 필터링/정렬
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
  
  /// 해당 도서가 즐겨찾기 상태인지 여부 반환
  func isFavorite(_ book: Book) -> Bool {
    book.isbn.map { favoriteBooksStore.favoriteBooks.contains($0) } ?? false
  }
}
