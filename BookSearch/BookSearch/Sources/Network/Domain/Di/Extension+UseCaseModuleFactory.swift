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
    return [
      registerModule.fetchBookUseCase
    ]
  }
}
