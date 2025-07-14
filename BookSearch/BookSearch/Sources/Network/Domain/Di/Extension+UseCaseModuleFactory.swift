//
//  Extension+UseCaseModuleFactory.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation

import DiContainer

extension UseCaseModuleFactory {
  public var useCaseDefinitions: [() -> Module] {
    let registerModuleCopy = registerModule  // self를 직접 캡처하지 않고 복사
    return [
      registerModuleCopy.fetchBookUseCase,
      registerModuleCopy.favoriteBookUseCase
    ]
  }
}
