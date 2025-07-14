//
//  BookSearchModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
// 1) 전체 검색 결과를 감싸는 Domain 모델
struct BookSearchModel: Codable {
    var books: [Book]
    var paging: PagingInfo
}

// 2) 페이징 정보
struct PagingInfo : Codable{
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
}

// 3) 책 한 권 정보를 담는 모델
struct Book: Codable, Identifiable, Hashable {
  var id = UUID()
    let title: String
    let authors: [String]
    let description: String
    let publishedAt: Date?       // DTO의 datetime
    let isbn: String?
    let publisher: String?
    let price: Int?
    let salePrice: Int?
    let saleStatus: String?
    let thumbnailURL: String?
    let translators: [String]
    let detailURL: URL?          // DTO의 url

  var isFavorite: Bool = false
}


extension Book {
  static var mock: Book {
    Book(
      title: "SS 8",
      authors: ["하루모토 쇼헤이"],
      description: "",
      publishedAt: ISO8601DateFormatter().date(from: "2003-06-25T00:00:00.000+09:00"),
      isbn: "8952942728 9788952942722",
      publisher: "학산문화사",
      price: 3000,
      salePrice: -1,
      saleStatus: "",
      thumbnailURL: "",
      translators: [],
      detailURL: URL(string: "https://search.daum.net/search?w=bookpage&bookId=655874&q=SS+8")
    )
  }

  static var initBook: Book {
    Book(
      title: "",
      authors: [""],
      description: "",
      publishedAt: Date(),
      isbn: "",
      publisher: "",
      price: 0,
      salePrice: 0,
      saleStatus: "",
      thumbnailURL: "",
      translators: [],
      detailURL: URL(string: "")
    )
  }
}


extension BookSearchModel {
  static var initModel: BookSearchModel {
    .init(books: [], paging: PagingInfo(isEnd: true, pageableCount: 0, totalCount: 0))
  }
}
