//
//   Extension+RepositoryModuleFactory.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation

import DiContainer


extension RepositoryModuleFactory {
  public mutating func registerDefaultDefinitions() {
    let registerModuleCopy = registerModule  // self를 직접 캡처하지 않고 복사
    repositoryDefinitions = {
      return [
        registerModuleCopy.fetchBookRepository,
        registerModuleCopy.favoriteBookRepository
      ]
    }()
  }
}
