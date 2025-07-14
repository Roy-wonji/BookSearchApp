//
//  Extension+AppDIContainer.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation
import DiContainer

/// AppDIContainer의 기본 의존성 등록 함수 확장입니다.
///
/// - 저장소/유스케이스 모듈을 DI 컨테이너에 비동기 등록합니다.
extension AppDIContainer {
  /// 앱의 기본 의존성(Repository, UseCase 등)을 비동기적으로 등록합니다.
  ///
  /// - 비동기 forEach(asyncForEach)을 사용하여 모든 모듈을 등록합니다.
  func registerDefaultDependencies() async {
    await registerDependencies { container in
      // 저장소 정의 등록
      self.repositoryFactory.registerDefaultDefinitions()
      let repositoryFactory = self.repositoryFactory
      let useCaseFactory = self.useCaseFactory
      
      // 저장소 모듈을 비동기적으로 등록
      await repositoryFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }
      
      // 유스케이스 모듈을 비동기적으로 등록
      await useCaseFactory.makeAllModules().asyncForEach { module in
        await container.register(module)
      }
    }
  }
}
