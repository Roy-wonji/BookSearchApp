//
//  BookSearchDTOModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

struct BookSearchDTOModel: Decodable {
  let documents: [BookDocumentDTO]?
  let meta: MetaDTO?
}

struct MetaDTO: Decodable {
  let isEnd: Bool?
  let pageableCount: Int?
  let totalCount: Int?

  private enum CodingKeys: String, CodingKey {
    case isEnd         = "is_end"
    case pageableCount = "pageable_count"
    case totalCount    = "total_count"
  }
}

struct BookDocumentDTO: Decodable {
  let authors: [String]?
  let contents: String?
  let datetime: String?
  let isbn: String?
  let price: Int?
  let publisher: String?
  let salePrice: Int?
  let status: String?
  let thumbnail: String?
  let title: String?
  let translators: [String]?
  let url: String?

  private enum CodingKeys: String, CodingKey {
    case authors, contents, datetime, isbn, price, publisher
    case salePrice   = "sale_price"
    case status, thumbnail, title, translators, url
  }
}
