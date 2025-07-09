//
//  BookSearchRepositoryImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

final class BookRepositoryImplementation: ObservableObject,  BookSearchRepositoryProtocol {
  private let provider: AsyncProvider<SearchService>
  public init(provider: AsyncProvider<SearchService> = .init()) {
    self.provider = provider
  }

  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel? {
    let dto: BookSearchDTOModel = try await provider.requestAsync(
      .search(request: request),
      decodeTo: BookSearchDTOModel.self
    )
    return dto.toDomain()
  }

}
