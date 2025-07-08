//
//  Extension+AppDIContainer.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation

import DiContainer

extension AppDIContainer {
  func registerDefaultDependencies() async {
    await registerDependencies { container in
      self.repositoryFactory.registerDefaultDefinitions()
      let repositoryFactory = self.repositoryFactory
      let useCaseFactory = self.useCaseFactory

      // asyncForEach를 사용하여 각 모듈을 비동기적으로 등록합니다.
      await repositoryFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }

      await useCaseFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }
    }
  }
}

