//
//  AsyncProvider.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/9/25.
//

import Foundation
import LogMacro
import SwiftUI

final class AsyncProvider<T: TargetType> {
  private let session: URLSession
  private let maxRetryCount = 3
  private let retryDelay: TimeInterval = 2.0  // 재시도 간격 (2초)

  init(session: URLSession = .shared) {
    self.session = session
  }

  func requestAsync<D: Decodable & Sendable>(
    _ target: T,
    decodeTo type: D.Type
  ) async throws -> D {
    let request = await URLRequestBuilder.buildRequest(from: target)
    // ✅ 요청 로깅
    await URLSessionLogger.shared.logRequest(request)

    return try await executeWithRetry(
      request: request,
      decodeTo: type,
      retryCount: 0
    )
  }

  private func executeWithRetry<D: Decodable & Sendable>(
    request: URLRequest,
    decodeTo type: D.Type,
    retryCount: Int
  ) async throws -> D {
    do {
      let (data, response) = try await session.data(for: request)
      // ✅ 응답 로그
            await URLSessionLogger.shared.logResponse(data: data, response: response, error: nil)
      guard let httpResponse = response as? HTTPURLResponse else {
        await Log.error("No HTTP response received")
        throw DataError.noData
      }

      switch httpResponse.statusCode {
      case 200...299:
        // 성공 응답 처리
        return try data.decoded(as: D.self)

      case 400:
        await Log.error("Bad Request (400) for URL: \(request.url?.absoluteString ?? "No URL")")
        throw DataError.customError("Bad Request (400)")

      case 404:
        await Log.error("Not Found (404) for URL: \(request.url?.absoluteString ?? "No URL")")
        throw DataError.customError("Not Found (404)")

      case 500:
        await Log.error("Internal Server Error (500), attempting to decode response (Retry Count: \(retryCount + 1))")
        if retryCount < maxRetryCount {
          // 500 에러일 때도 디코딩을 시도합니다.
          if let decodedData = try? await decodeErrorResponseData(
            data: data,
            decodeTo: type
          ) {
            // 디코딩이 성공하면 반환
            return decodedData
          }

          // 대기 후 재시도
          try await Task
            .sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))  // 대기 시간
          return try await executeWithRetry(
            request: request,
            decodeTo: type,
            retryCount: retryCount + 1
          )
        } else {
          await Log.error("Failed after \(maxRetryCount) retries for 500 error response")
          throw DataError.unhandledStatusCode(httpResponse.statusCode)
        }

      default:
        await Log.error("Unhandled status code: \(httpResponse.statusCode) for URL: \(request.url?.absoluteString ?? "No URL")"
          )
        throw DataError.unhandledStatusCode(httpResponse.statusCode)
      }
    } catch {
      await URLSessionLogger.shared.logResponse(data: nil, response: nil, error: error)

      await Log.error("Network request failed with error: \(error.localizedDescription)")
      if retryCount < maxRetryCount {
        // 대기 후 재시도
        try await Task
          .sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))  // 대기 시간
        return try await executeWithRetry(
          request: request,
          decodeTo: type,
          retryCount: retryCount + 1
        )
      } else {
        throw error  // 재시도 횟수를 초과한 경우 원래 에러를 던짐
      }
    }
  }

  @MainActor private func decodeErrorResponseData<D: Decodable>(data: Data, decodeTo type: D.Type) throws -> D {
    let decoder = JSONDecoder()

    // 데이터를 제네릭 D 타입으로 디코딩 시도
    if let decodedData = try? decoder.decode(D.self, from: data) {
      Log.debug("Successfully decoded response: \(decodedData)")
      return decodedData
    } else {
      Log.error("Failed to decode response as type \(D.self)")
      throw URLError(.cannotParseResponse)
    }
  }
}

extension AsyncProvider: @unchecked Sendable {}
