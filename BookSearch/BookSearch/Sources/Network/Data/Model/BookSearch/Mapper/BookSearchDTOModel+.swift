//
//  BookSearchDTOModel+.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import Foundation

extension BookSearchDTOModel {
  func toDomain() -> BookSearchModel {
    // ISO8601 포맷터 (fractional seconds 포함)
    let isoFormatter: ISO8601DateFormatter = {
      let f = ISO8601DateFormatter()
      f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return f
    }()

    let domainBooks: [Book] = (documents ?? []).map { dto in
      let publishedDate = dto.datetime.flatMap { isoFormatter.date(from: $0) }
      let detailURL     = dto.url.flatMap { URL(string: $0) }

      return Book(
        title:        dto.title            ?? "제목 없음",
        authors:      dto.authors         ?? [],
        description:  dto.contents        ?? "",
        publishedAt:  publishedDate,
        isbn:         dto.isbn,
        publisher:    dto.publisher,
        price:        dto.price,
        salePrice:    dto.salePrice,
        saleStatus:   dto.status,
        thumbnailURL: dto.thumbnail,
        translators:  dto.translators      ?? [],
        detailURL:    detailURL
      )
    }

    let paging = PagingInfo(
      isEnd:         meta?.isEnd         ?? false,
      pageableCount: meta?.pageableCount ?? 0,
      totalCount:    meta?.totalCount    ?? 0
    )

    return BookSearchModel(
      books:  domainBooks,
      paging: paging
    )
  }
}
