//
//  BookFavoriteUseCaseImpl.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation
import DiContainer

/// 즐겨찾기 도서 유스케이스의 구현체입니다.
///
/// - BookFavoriteRepositoryProtocol을 주입받아 실제 비즈니스 로직을 수행합니다.
struct BookFavoriteUseCaseImplementation: BookFavoriteUseCaseProtocol {
  /// 즐겨찾기 저장소
  private let repository: BookFavoriteRepositoryProtocol

  /// 생성자
  /// - Parameter repository: 즐겨찾기 저장소 구현체
  init(repository: BookFavoriteRepositoryProtocol) {
    self.repository = repository
  }

  /// 즐겨찾기 도서 목록을 반환합니다.
  func loadFavoriteBooks() async -> BookSearchModel {
    await repository.loadFavoriteBooks()
  }

  /// 도서의 즐겨찾기 상태를 토글합니다.
  func toggleFavorite(_ book: Book) async {
    await repository.toggleFavorite(book)
  }
}

// MARK: - RegisterModule 확장

extension RegisterModule {
  /// 즐겨찾기 유스케이스 모듈을 등록합니다.
  var favoriteBookUseCase: () -> Module {
    makeUseCaseWithRepository(
      BookFavoriteUseCaseProtocol.self,
      repositoryProtocol: BookFavoriteRepositoryProtocol.self,
      repositoryFallback: MockBookFavoriteRepository(),
      factory: { repo in
        BookFavoriteUseCaseImplementation(repository: repo)
      }
    )
  }

  /// 즐겨찾기 저장소 모듈을 등록합니다.
  var favoriteBookRepository: () -> Module {
    makeDependency(BookFavoriteRepositoryProtocol.self) {
      BookFavoriteRepositoryImplementation()
    }
  }
}
