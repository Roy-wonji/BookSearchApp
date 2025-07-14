//
//  BookRepositoryImplementationTests.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

// MockBookRepositoryTests.swift

import Testing
@testable import BookSearch

struct MockBookRepositoryTests {
  // BookSearchModel.mock의 첫 번째, 두 번째 책 사용
  let testBook = BookSearchModel.mock.books.first!
  let testBook2 = BookSearchModel.mock.books[1]

  func makeRepo(initialBooks: [Book] = []) -> MockBookRepository {
    MockBookRepository(initialBooks: initialBooks)
  }

  @Test
  func 초기_즐겨찾기_상태_확인() async throws {
    let repo = makeRepo(initialBooks: [testBook])
    let favs = await repo.loadFavorites()
    let books = await repo.loadFavoriteBooks()
    #expect(favs.contains(testBook.isbn!))
    #expect(books.contains(where: { $0.isbn == testBook.isbn }))
    #expect(await repo.isFavorite(testBook))
  }

  @Test
  func 즐겨찾기_토글_삭제_및_추가() async throws {
    let repo = makeRepo(initialBooks: [testBook])
    // 삭제
    await repo.toggleFavorite(testBook)
    let favsAfterDelete = await repo.loadFavorites()
    let booksAfterDelete = await repo.loadFavoriteBooks()
    #expect(!favsAfterDelete.contains(testBook.isbn!))
    #expect(!booksAfterDelete.contains(where: { $0.isbn == testBook.isbn }))
    #expect(!(await repo.isFavorite(testBook)))
    // 다시 추가
    await repo.toggleFavorite(testBook)
    let favsAfterAdd = await repo.loadFavorites()
    let booksAfterAdd = await repo.loadFavoriteBooks()
    #expect(favsAfterAdd.contains(testBook.isbn!))
    #expect(booksAfterAdd.contains(where: { $0.isbn == testBook.isbn }))
    #expect(await repo.isFavorite(testBook))
  }

  @Test
  func 여러권_즐겨찾기_추가_및_전체조회() async throws {
    let repo = makeRepo()
    await repo.toggleFavorite(testBook)
    await repo.toggleFavorite(testBook2)
    let favs = await repo.loadFavorites()
    let books = await repo.loadFavoriteBooks()
    #expect(favs.contains(testBook.isbn!))
    #expect(favs.contains(testBook2.isbn!))
    #expect(books.contains(where: { $0.isbn == testBook.isbn }))
    #expect(books.contains(where: { $0.isbn == testBook2.isbn }))
    #expect(await repo.isFavorite(testBook))
    #expect(await repo.isFavorite(testBook2))
  }
}
