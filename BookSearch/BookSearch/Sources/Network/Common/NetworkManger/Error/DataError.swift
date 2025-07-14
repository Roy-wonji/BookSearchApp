//
//  DataError.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation

/// 네트워크 및 데이터 처리 과정에서 발생할 수 있는 오류를 정의한 enum입니다.
enum DataError: Error {
  /// 데이터가 없음
  case noData
  
  /// 커스텀 에러 메시지
  case customError(String)
  
  /// 처리하지 않은 HTTP 상태 코드
  case unhandledStatusCode(Int)
  
  /// HTTP 응답 오류 (응답 객체, 에러 메시지)
  case httpResponseError(HTTPURLResponse, String)
}
