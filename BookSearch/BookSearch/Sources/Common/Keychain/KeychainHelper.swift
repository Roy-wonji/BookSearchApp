//
//  KeychainHelper.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation
import Security

struct KeychainHelper {

  /// 저장할 키 종류
  enum Key: String, CaseIterable {
    case bookSearchModel      // BookSearchModel 전체 저장용
    case favoriteISBNs        // 즐겨찾기 ISBN 집합 저장용
  }

  /// Codable 객체를 Keychain에 저장
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

  /// Keychain에서 Codable 객체를 로드
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

  /// Keychain에서 특정 키만 삭제
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

  /// Keychain에 저장된 모든 앱 데이터 삭제
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

  enum KeychainError: Error {
    case unhandledError(status: OSStatus)
  }
}
