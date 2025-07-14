//
//  BookSearchRepositoryImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import LogMacro

final class BookRepositoryImplementation: ObservableObject, BookSearchRepositoryProtocol {
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

  /// Keychain‐based toggle
  func toggleFavorite(_ book: Book) async {
    guard let isbn = book.isbn else { return }

    // 1) Keychain에서 기존 즐겨찾기 ISBN 집합 로드
    var currentISBNs: Set<String> = []
    do {
      currentISBNs = try KeychainHelper.load(Set<String>.self, for: .favoriteISBNs) ?? []
    } catch {
      await Log.debug("❌ Keychain load favoriteISBNs failed:", error)
    }

    // 2) ISBN 토글
    if currentISBNs.contains(isbn) {
      currentISBNs.remove(isbn)
    } else {
      currentISBNs.insert(isbn)
    }

    // 3) Keychain에 favoriteISBNs 저장/삭제
    do {
      if currentISBNs.isEmpty {
        try KeychainHelper.delete(.favoriteISBNs)
        await Log.debug("🗑️ Keychain favoriteISBNs 삭제")
      } else {
        try KeychainHelper.save(currentISBNs, for: .favoriteISBNs)
        await Log.debug("✅ Keychain favoriteISBNs 저장:", currentISBNs)
      }
    } catch {
      await Log.debug("❌ Keychain save favoriteISBNs failed:", error)
    }

    // 4) Keychain에서 기존 즐겨찾기 모델(BookSearchModel) 로드
    var model: BookSearchModel = .initModel
    do {
      model = try KeychainHelper.load(BookSearchModel.self, for: .bookSearchModel) ?? .initModel
    } catch {
      await Log.debug("❌ Keychain load favoriteModel failed:", error)
    }

    // 5) 모델.books에도 토글 적용
    var books = model.books
    if let idx = books.firstIndex(where: { $0.isbn == isbn }) {
      books.remove(at: idx)
    } else {
      var fav = book
      fav.isFavorite = true
      books.append(fav)
    }

    // 6) 새로운 페이징 정보로 모델 재생성
    let count = books.count
    let newModel = BookSearchModel(
      books: books,
      paging: PagingInfo(isEnd: true, pageableCount: count, totalCount: count)
    )

    // 7) Keychain에 favoriteModel 저장/삭제
    do {
      if newModel.books.isEmpty {
        try KeychainHelper.delete(.bookSearchModel)
        await Log.debug("🗑️ Keychain favoriteModel 삭제")
      } else {
        try KeychainHelper.save(newModel, for: .bookSearchModel)
        await Log.debug("✅ Keychain favoriteModel 저장, count=\(count)")
      }
    } catch {
      await Log.debug("❌ Keychain save favoriteModel failed:", error)
    }
  }

  /// Keychain에서 즐겨찾기 ISBN 집합을 읽어 옵니다.
  func loadFavorites() async -> Set<String> {
    do {
      return try KeychainHelper.load(Set<String>.self, for: .favoriteISBNs) ?? []
    } catch {
      await Log.debug("❌ Keychain load favoriteISBNs failed:", error)
      return []
    }
  }

  /// Keychain에서 확인
  func isFavorite(_ book: Book) async -> Bool {
    guard let isbn = book.isbn else { return false }
    let favs = await loadFavorites()
    return favs.contains(isbn)
  }
}
