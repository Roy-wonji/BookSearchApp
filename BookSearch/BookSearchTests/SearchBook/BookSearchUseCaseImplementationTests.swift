//
//  BookSearchUseCaseImplementationTests.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Testing
@testable import BookSearch

/// BookSearchUseCaseImplementation의 즐겨찾기 및 검색 기능 단위 테스트
struct BookSearchUseCaseImplementationTests {
  let testBook = BookSearchModel.mock.books.first! // 테스트용 Book 1
  let testBook2 = BookSearchModel.mock.books[1]    // 테스트용 Book 2

  /// 테스트용 UseCase 생성 함수
  /// - initialBooks: 초기 즐겨찾기 상태로 사용할 Book 배열
  /// - 실제 UseCase 타입 반환 (MockBookRepository 주입)
  func makeUseCase(initialBooks: [Book] = []) -> BookSearchUseCaseImplementation {
    let repo = MockBookRepository(initialBooks: initialBooks)
    return BookSearchUseCaseImplementation(repository: repo)
  }

  /// 1. 초기 즐겨찾기 상태 확인 테스트
  /// - 초기 즐겨찾기 배열에 testBook이 포함되어 있으면
  ///   loadFavorites와 isFavorite이 올바르게 동작하는지 검증
  @Test
  func 초기_즐겨찾기_상태_확인() async throws {
    let useCase = makeUseCase(initialBooks: [testBook])
    let favs = await useCase.loadFavorites()
    #expect(favs.contains(testBook.isbn!))           // Store에 포함되어야 함
    #expect(await useCase.isFavorite(testBook))      // isFavorite도 true여야 함
  }

  /// 2. 즐겨찾기 토글, 삭제, 추가 테스트
  /// - 즐겨찾기 삭제 후 Store/조회 모두 false로 바뀌는지
  /// - 다시 추가 시 true로 복원되는지 검증
  @Test
  func 즐겨찾기_토글_삭제_및_추가() async throws {
    let useCase = makeUseCase(initialBooks: [testBook])
    // 삭제
    await useCase.toggleFavorite(testBook)
    let favsAfterDelete = await useCase.loadFavorites()
    #expect(!favsAfterDelete.contains(testBook.isbn!))
    #expect(!(await useCase.isFavorite(testBook)))
    // 다시 추가
    await useCase.toggleFavorite(testBook)
    let favsAfterAdd = await useCase.loadFavorites()
    #expect(favsAfterAdd.contains(testBook.isbn!))
    #expect(await useCase.isFavorite(testBook))
  }

  /// 3. 여러 권 즐겨찾기 추가 및 전체 조회 테스트
  /// - 여러 권을 즐겨찾기에 추가했을 때
  ///   Store와 isFavorite이 모두 정상 반영되는지 검증
  @Test
  func 여러권_즐겨찾기_추가_및_전체조회() async throws {
    let useCase = makeUseCase()
    await useCase.toggleFavorite(testBook)
    await useCase.toggleFavorite(testBook2)
    let favs = await useCase.loadFavorites()
    #expect(favs.contains(testBook.isbn!))
    #expect(favs.contains(testBook2.isbn!))
    #expect(await useCase.isFavorite(testBook))
    #expect(await useCase.isFavorite(testBook2))
  }

  /// 4. fetchBooks가 항상 nil을 반환하는지 테스트
  /// - MockBookRepository는 검색 결과를 반환하지 않으므로 nil이어야 함
  @Test
  func fetchBooks_항상_nil_반환() async throws {
    let useCase = makeUseCase()
    let request = BookSearchRequest(
      query: "아무거나",
      sort: .accuracy, // 실제 enum 값
      page: 1,
      size: 10
    )
    let result = try await useCase.execute(request: request)
    #expect(result == nil)
  }
}
