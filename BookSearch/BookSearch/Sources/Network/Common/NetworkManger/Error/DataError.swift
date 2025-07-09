//
//  DataError.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

// 데이터 오류 정의
enum DataError: Error {
   case noData
   case customError(String)
   case unhandledStatusCode(Int)
   case httpResponseError(HTTPURLResponse, String)
}
