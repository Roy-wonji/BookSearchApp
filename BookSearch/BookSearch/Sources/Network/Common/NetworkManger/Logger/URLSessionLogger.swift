//
//  URLSessionLogger.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation
import LogMacro

final class URLSessionLogger {
    static let shared = URLSessionLogger()

    private init() {}

    // MARK: - 요청 로그
  @MainActor func logRequest(_ request: URLRequest) {
#if DEBUG
    Log.debug("⎡--------------------- REQUEST ---------------------⎤")

        if let method = request.httpMethod {
          Log.network("[Method]", method)
        }

        if let url = request.url?.absoluteString {
          Log.network("[URL]", url)
        }

        if let headers = request.allHTTPHeaderFields {
          Log.network("[Headers]")
            for (key, value) in headers {
              Log.network("  \(key): \(value)")
            }
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
          Log.network("[Body]")
          Log.network("  \(bodyString)")
        }

    Log.network("⎣------------------ END REQUEST --------------------⎦")
#endif
    }

    // MARK: - 응답 로그
  @MainActor
  func logResponse(data: Data?, response: URLResponse?, error: Error?) {
  #if DEBUG
      Log.network("⎡--------------------- RESPONSE --------------------⎤")

      if let url = response?.url?.absoluteString {
          Log.network("[URL]", url)
      }

      if let httpResponse = response as? HTTPURLResponse {
          Log.network("[Status Code] \(httpResponse.statusCode)")
          Log.network("[Response Headers]")
          for (key, value) in httpResponse.allHeaderFields {
              Log.network("  \(key): \(value)")
          }
      }

      if let data = data {
          do {
              let json = try JSONSerialization.jsonObject(with: data, options: [])
              let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
              if let prettyString = String(data: prettyData, encoding: .utf8) {
                  Log.network("[Body (Map)]")
                  Log.network(prettyString)
              }
          } catch {
              // JSON 디코딩 실패 시 원본 문자열 출력
              if let rawString = String(data: data, encoding: .utf8) {
                  Log.network("[Body (Raw)]")
                  Log.network(rawString)
              } else {
                  Log.network("[Body] Cannot decode data")
              }
          }
      }

      if let error = error {
          Log.network("[Error] \(error.localizedDescription)")
      }

      Log.network("⎣------------------ END RESPONSE -------------------⎦")
  #endif
  }
}
