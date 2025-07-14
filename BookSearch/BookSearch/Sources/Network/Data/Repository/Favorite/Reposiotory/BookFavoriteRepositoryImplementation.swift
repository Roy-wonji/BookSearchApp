//
//  BookFavoriteRepositoryImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation
import LogMacro

/// 즐겨찾기 도서를 Keychain에 저장/불러오는 레포지토리 구현체입니다.
final class BookFavoriteRepositoryImplementation: BookFavoriteRepositoryProtocol, ObservableObject {

  init() {}

  /// Keychain에 저장된 즐겨찾기 도서 모델을 불러옵니다.
  /// 저장된 값이 없거나 디코딩에 실패하면 `.initModel`을 반환합니다.
  func loadFavoriteBooks() async -> BookSearchModel {
    do {
      if let model = try KeychainHelper.load(BookSearchModel.self, for: .bookSearchModel) {
        return model
      }
    } catch {
      await Log.debug("❌ Keychain load favorite BookSearchModel failed:", error)
    }
    return .initModel
  }

  /// 즐겨찾기 토글: Keychain에 저장된 모델에서 해당 도서를 추가/제거 후 다시 저장합니다.
  func toggleFavorite(_ book: Book) async {
    guard let isbn = book.isbn else { return }

    // 1) 기존 모델 로드
    let existingModel: BookSearchModel
    do {
      existingModel = try KeychainHelper
        .load(BookSearchModel.self, for: .bookSearchModel)
        ?? .initModel
    } catch {
      await Log.debug("❌ Keychain load favorite BookSearchModel failed:", error)
      existingModel = .initModel
    }

    // 2) 토글
    var books = existingModel.books
    if books.contains(where: { $0.isbn == isbn }) {
      books.removeAll { $0.isbn == isbn }
    } else {
      var fav = book
      fav.isFavorite = true
      books.append(fav)
    }

    // 3) 페이징 업데이트
    let count = books.count
    let newModel = BookSearchModel(
      books: books,
      paging: PagingInfo(isEnd: true, pageableCount: count, totalCount: count)
    )

    // 4) 비어있으면 삭제, 아니면 저장
    do {
      if books.isEmpty {
        try KeychainHelper.delete(.bookSearchModel)
        await Log.debug("🗑️ Keychain favorite BookSearchModel deleted")
      } else {
        try KeychainHelper.save(newModel, for: .bookSearchModel)
        await Log.debug("✅ Keychain save favorite BookSearchModel succeeded, count=\(count)")
      }
    } catch {
      await Log.debug("❌ Keychain favorite BookSearchModel 처리 실패:", error)
    }
  }
}
