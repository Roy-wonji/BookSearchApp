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
  var publishedAt: Date?       // DTO의 datetime
  var isbn: String?
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




extension BookSearchModel {
  static var mock: BookSearchModel {
    let formatter = ISO8601DateFormatter()
    return BookSearchModel(
      books: [
        Book(
          title: "ㄴ(니은)이 말했어",
          authors: ["김귀자"],
          description: "해맑은 동심의 시를 통해 아이들과 교감하는 김귀자 시인의 네 번째 동시집입니다. 56편의 시를 4부로 나누어 실었습니다. 특별히 한 교육원의 30여 명 어린이가 그림을 직접 그려 시인이 노래한 동심의 세계를 더욱 맑고 곱게 색칠했습니다. 아이들의 그림은 날것처럼 생생하게 시와 어울려 시 읽는 즐거움을 더욱 키워줍니다. 시인은 언제나 아이들의 눈과 마음으로 세상과 사물을 바라봅니다. 시인의 눈에는 쉽게 지나치는 작고 사소한 것들이 들어옵니다. 시인",
          publishedAt: formatter.date(from: "2024-09-06T00:00:00.000+09:00"),
          isbn: "117272007X 9791172720070",
          publisher: "고래책빵",
          price: 13000,
          salePrice: 11700,
          saleStatus: "정상판매",
          thumbnailURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6719567%3Ftimestamp%3D20250201153518",
          translators: [],
          detailURL: URL(string: "https://search.daum.net/search?w=bookpage&bookId=6719567&q=%E3%84%B4%28%EB%8B%88%EC%9D%80%29%EC%9D%B4+%EB%A7%90%ED%96%88%EC%96%B4"),
          isFavorite: true
        ),
        Book(
          title: "메가두뇌력 퍼즐: 한글 ㄱ ㄴ",
          authors: ["메가스터디 유아교육 연구소"],
          description: "『메가두뇌력 퍼즐: 한글 ㄱ ㄴ』 은 두뇌를 발달시켜 주는 퍼즐 놀이입니다. 재미있는 퍼즐을 보며 집중력을 키우고, 퍼즐 조각을 맞추며 소근육을 키울 수 있습니다. ‘어떤 그림이 완성될까?’ 머릿속에 그림을 떠올리며 메가두뇌력 퍼즐 놀이를 통해 상상력을 키워보세요.",
          publishedAt: formatter.date(from: "2016-11-01T00:00:00.000+09:00"),
          isbn: "8809392991079",
          publisher: "엠키즈",
          price: 4900,
          salePrice: 3920,
          saleStatus: "정상판매",
          thumbnailURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F3775204%3Ftimestamp%3D20221107235941",
          translators: [],
          detailURL: URL(string: "https://search.daum.net/search?w=bookpage&bookId=3775204&q=%EB%A9%94%EA%B0%80%EB%91%90%EB%87%8C%EB%A0%A5+%ED%8D%BC%EC%A6%90%3A+%ED%95%9C%EA%B8%80+%E3%84%B1+%E3%84%B4"),
          isFavorite: false
        ),
        Book(
          title: "구름이 ㄱ ㄴ ㄷ(쫑알쫑알 한글똑똑 12)(양장본 HardCover)",
          authors: ["김기린"],
          description: "「쫑알쫑알 한글똑똑」은 아이들이 재미있는 그림책을 읽으며 한글을 깨치고, 어휘력과 표현력을 기를 수 있도록 구성했습니다. 한글에 흥미를 갖고, 학습할 수 있도록 재미있는 그림들로 이야기가 펼쳐집니다. 체계적인 프로그램으로 읽기, 듣기, 말하기, 쓰기 등 전 내용을 골고루 익힐 수 있는 시리즈입니다. 각 권마다 학습 목표를 담고 있고, 다양한 코너를 통해 배운 내용을 다시금 확인해볼 수 있습니다.",
          publishedAt: formatter.date(from: "2016-06-01T00:00:00.000+09:00"),
          isbn: "8963296628 9788963296623",
          publisher: "한국톨스토이",
          price: 10000,
          salePrice: 9000,
          saleStatus: "정상판매",
          thumbnailURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F882487%3Ftimestamp%3D20221025135906",
          translators: [],
          detailURL: URL(string: "https://search.daum.net/search?w=bookpage&bookId=882487&q=%EA%B5%AC%EB%A6%84%EC%9D%B4+%E3%84%B1+%E3%84%B4+%E3%84%B7%28%EC%AB%91%EC%95%8C%EC%AB%91%EC%95%8C+%ED%95%9C%EA%B8%80%EB%98%91%EB%98%91+12%29%28%EC%96%91%EC%9E%A5%EB%B3%B8+HardCover%29"),
          isFavorite: false
        )
      ],
      paging: PagingInfo(
        isEnd: false,
        pageableCount: 48,
        totalCount: 48
      )
    )
  }
}
