//
//  BookFavoriteUseCaseImpl.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

import DiContainer

struct BookFavoriteUseCaseImplementation: BookFavoriteUseCaseProtocol {
  private let repository: BookFavoriteRepositoryProtocol

  init(repository: BookFavoriteRepositoryProtocol) {
    self.repository = repository
  }

  func loadFavoriteBooks() async -> BookSearchModel {
    await repository.loadFavoriteBooks()
  }

  func toggleFavorite(_ book: Book) async {
    await repository.toggleFavorite(book)
  }
}

extension DependencyContainer {
  var favoriteBookUseCase: BookFavoriteRepositoryProtocol? {
    resolve(BookFavoriteRepositoryProtocol.self)
  }
}

extension RegisterModule {
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

  var favoriteBookRepository: () -> Module {
    makeDependency(BookFavoriteRepositoryProtocol.self) {
      BookFavoriteRepositoryImplementation()
    }
  }
}
