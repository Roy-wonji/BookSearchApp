//
//  KeychainHelper.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation
import Security

/// Keychain을 이용한 안전한 데이터 저장/로드/삭제를 도와주는 Helper 구조체입니다.
///
/// - Codable 객체를 Keychain에 저장/로드/삭제할 수 있습니다.
/// - 앱에서 즐겨찾기, 모델 캐싱 등 민감한 정보 저장에 활용합니다.
struct KeychainHelper {

  /// 저장할 키 종류 (Keychain 내 Account 역할)
  enum Key: String, CaseIterable {
    case bookSearchModel      ///< BookSearchModel 전체 저장용
    case favoriteISBNs        ///< 즐겨찾기 ISBN 집합 저장용
  }

  /// Codable 객체를 Keychain에 저장합니다.
  ///
  /// - Parameters:
  ///   - object: 저장할 Codable 객체
  ///   - key: 저장할 위치(Key)
  /// - Throws: 저장 실패 시 에러 발생
  static func save<T: Codable>(_ object: T, for key: Key) throws {
    let data = try JSONEncoder().encode(object)
    let q: [CFString: Any] = [
      kSecClass:          kSecClassGenericPassword,
      kSecAttrAccount:    key.rawValue,
      kSecValueData:      data,
      kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
    ]
    // 기존 항목 제거
    SecItemDelete(q as CFDictionary)
    // 새 항목 추가
    let status = SecItemAdd(q as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  /// Keychain에서 Codable 객체를 로드합니다.
  ///
  /// - Parameters:
  ///   - type: 로드할 타입
  ///   - key: 로드할 위치(Key)
  /// - Returns: 로드된 객체 또는 nil
  /// - Throws: 로드 실패 시 에러 발생
  static func load<T: Codable>(_ type: T.Type, for key: Key) throws -> T? {
    let q: [CFString: Any] = [
      kSecClass:       kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecReturnData:  true,
      kSecMatchLimit:  kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(q as CFDictionary, &result)
    switch status {
    case errSecSuccess:
      guard let data = result as? Data else { return nil }
      return try JSONDecoder().decode(T.self, from: data)
    case errSecItemNotFound:
      return nil
    default:
      throw KeychainError.unhandledError(status: status)
    }
  }

  /// Keychain에서 특정 키의 데이터를 삭제합니다.
  ///
  /// - Parameter key: 삭제할 위치(Key)
  /// - Throws: 삭제 실패 시 에러 발생
  static func delete(_ key: Key) throws {
    let q: [CFString: Any] = [
      kSecClass:       kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    let status = SecItemDelete(q as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  /// Keychain에 저장된 모든 앱 데이터(정의된 Key)를 삭제합니다.
  ///
  /// - Throws: 삭제 실패 시 에러 발생
  static func clearAll() throws {
    for key in Key.allCases {
      let q: [CFString: Any] = [
        kSecClass:       kSecClassGenericPassword,
        kSecAttrAccount: key.rawValue
      ]
      let status = SecItemDelete(q as CFDictionary)
      guard status == errSecSuccess || status == errSecItemNotFound else {
        throw KeychainError.unhandledError(status: status)
      }
    }
  }

  /// Keychain 관련 에러 정의
  enum KeychainError: Error {
    case unhandledError(status: OSStatus)
  }
}
