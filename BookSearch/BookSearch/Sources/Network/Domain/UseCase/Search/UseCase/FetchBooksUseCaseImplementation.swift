//
//  FetchBooksUseCaseImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import DiContainer

struct FetchBooksUseCaseImplementation: FetchBooksUseCaseProtocol {
  private let repository: BookSearchRepositoryProtocol

   init(repository: BookSearchRepositoryProtocol) {
    self.repository = repository
  }

   func execute(request: BookSearchRequest) async throws -> BookSearchModel? {
    return try await repository.fetchBooks(request: request)
  }
}


extension DependencyContainer {
  var fetchBookUseCase: BookSearchRepositoryProtocol? { 
    resolve(BookSearchRepositoryProtocol.self)
  }
}

extension RegisterModule {
  var fetchBookUseCase: () -> Module {
    makeUseCaseWithRepository(
      FetchBooksUseCaseProtocol.self,
      repositoryProtocol: BookSearchRepositoryProtocol.self,
      repositoryFallback: MockBookRepository(),
      factory: { repo in
        FetchBooksUseCaseImplementation(repository: repo)
      }
    )
  }

  var fetchBookRepository: () -> Module {
    makeDependency(BookSearchRepositoryProtocol.self) {
      BookRepositoryImplementation()
    }
  }
}
