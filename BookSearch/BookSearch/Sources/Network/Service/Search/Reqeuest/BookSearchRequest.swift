//
//  BookSearchRequest.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

struct BookSearchRequest {
    let query: String
    let sort: SearchSortType
    let page: Int
    let size: Int
}
