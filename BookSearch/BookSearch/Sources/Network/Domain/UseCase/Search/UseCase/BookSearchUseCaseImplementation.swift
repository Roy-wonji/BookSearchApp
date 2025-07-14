//
//  BookSearchUseCaseImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import DiContainer

/// 도서 검색 및 즐겨찾기 유스케이스 구현체입니다.
///
/// - BookSearchRepositoryProtocol을 주입받아 실제 비즈니스 로직을 수행합니다.
struct BookSearchUseCaseImplementation: BookSearchUseCaseProtocol {
  /// 도서 검색/즐겨찾기 저장소
  private let repository: BookSearchRepositoryProtocol

  /// 생성자
  /// - Parameter repository: 도서 검색/즐겨찾기 저장소 구현체
  init(repository: BookSearchRepositoryProtocol) {
    self.repository = repository
  }

  /// 도서 검색을 실행합니다.
  func execute(request: BookSearchRequest) async throws -> BookSearchModel? {
    return try await repository.fetchBooks(request: request)
  }

  /// 도서의 즐겨찾기 상태를 토글합니다.
  func toggleFavorite(_ book: Book) async {
    return await repository.toggleFavorite(book)
  }

  /// 도서가 즐겨찾기인지 여부를 반환합니다.
  func isFavorite(_ book: Book) async -> Bool {
    return await repository.isFavorite(book)
  }

  /// 즐겨찾기된 도서의 ISBN 집합을 반환합니다.
  func loadFavorites() async -> Set<String> {
    return await repository.loadFavorites()
  }
}

// MARK: - RegisterModule 확장

extension RegisterModule {
  /// 도서 검색 유스케이스 모듈을 등록합니다.
  var bookSearchUseCase: () -> Module {
    makeUseCaseWithRepository(
      BookSearchUseCaseProtocol.self,
      repositoryProtocol: BookSearchRepositoryProtocol.self,
      repositoryFallback: MockBookRepository(),
      factory: { repo in
        BookSearchUseCaseImplementation(repository: repo)
      }
    )
  }

  /// 도서 검색 저장소 모듈을 등록합니다.
  var bookSearcBookRepository: () -> Module {
    makeDependency(BookSearchRepositoryProtocol.self) {
      BookRepositoryImplementation()
    }
  }
}
