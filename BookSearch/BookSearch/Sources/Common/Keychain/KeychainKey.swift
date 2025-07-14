//
//  KeychainKey.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

// MARK: - KeychainKey Enum

/**
 Keychain에 사용할 키를 정의한 enum입니다.
 
 - Note: 앱과 테스트 모두에서 String 기반으로 사용합니다.
 */
enum KeychainKey: String, CaseIterable {
  /// BookSearchModel 전체 저장용
  case bookSearchModel
  /// 즐겨찾기 ISBN 집합 저장용
  case favoriteISBNs
}
