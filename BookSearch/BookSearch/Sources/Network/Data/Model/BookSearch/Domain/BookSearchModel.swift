//
//  BookSearchModel.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation
// 1) 전체 검색 결과를 감싸는 Domain 모델
struct BookSearchModel: Decodable {
    let books: [Book]
    let paging: PagingInfo
}

// 2) 페이징 정보
struct PagingInfo : Decodable{
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
}

// 3) 책 한 권 정보를 담는 모델
struct Book: Decodable {
    let title: String
    let authors: [String]
    let description: String
    let publishedAt: Date?       // DTO의 datetime
    let isbn: String?
    let publisher: String?
    let price: Int?
    let salePrice: Int?
    let saleStatus: String?
    let thumbnailURL: URL?
    let translators: [String]
    let detailURL: URL?          // DTO의 url
}
