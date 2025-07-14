//
//  BookSearchRepositoryImplementation.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
import LogMacro

/**
 도서 검색 및 즐겨찾기 기능을 제공하는 저장소 구현체입니다.
 
 - 네트워크 검색은 provider를 통해, 즐겨찾기는 KeychainStorable을 통해 관리합니다.
 - ObservableObject로 선언되어 SwiftUI 등에서 바인딩 가능합니다.
 */
final class BookRepositoryImplementation: ObservableObject, BookSearchRepositoryProtocol {
  
  /// 네트워크 요청용 Provider
  private let provider: AsyncProvider<SearchService>
  
  /**
   생성자
   
   - Parameters:
   - provider: 네트워크 요청 Provider (기본값: .init())
   - keychain: KeychainStorable 구현체 (기본값: KeychainHelper())
   */
  public init(
    provider: AsyncProvider<SearchService> = .init()
  ) {
    self.provider = provider
  }
  
  /**
   도서 검색 API 호출 및 결과 반환
   
   - Parameter request: 검색 요청 파라미터
   - Returns: BookSearchModel(검색 결과) 또는 nil
   - Throws: 네트워크/디코딩 등 오류 발생 시 에러
   */
  func fetchBooks(request: BookSearchRequest) async throws -> BookSearchModel? {
    let dto: BookSearchDTOModel = try await provider.requestAsync(
      .search(request: request),
      decodeTo: BookSearchDTOModel.self
    )
    return dto.toDomain()
  }
  
  /**
   도서의 즐겨찾기 상태를 토글(추가/삭제)합니다. (Keychain 기반)
   
   - Parameter book: 즐겨찾기 상태를 변경할 도서
   */
  func toggleFavorite(_ book: Book) async {
    guard let isbn = book.isbn else { return }
    
    // 1) 기존 즐겨찾기 ISBN 집합 로드
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
    
    // 4) 기존 즐겨찾기 모델(BookSearchModel) 로드
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
  
  /**
   Keychain에서 즐겨찾기 ISBN 집합을 읽어 옵니다.
   
   - Returns: 즐겨찾기된 도서의 ISBN Set
   */
  func loadFavorites() async -> Set<String> {
    do {
      return try KeychainHelper.load(Set<String>.self, for: .favoriteISBNs) ?? []
    } catch {
      await Log.debug("❌ Keychain load favoriteISBNs failed:", error)
      return []
    }
  }
  
  /**
   도서가 즐겨찾기인지 Keychain에서 확인합니다.
   
   - Parameter book: 확인할 도서
   - Returns: 즐겨찾기 여부 (true/false)
   */
  func isFavorite(_ book: Book) async -> Bool {
    guard let isbn = book.isbn else { return false }
    let favs = await loadFavorites()
    return favs.contains(isbn)
  }
}
