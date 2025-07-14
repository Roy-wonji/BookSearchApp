//
//  Extension+UseCaseModuleFactory.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation
import DiContainer

/// UseCaseModuleFactory의 기본 유스케이스 정의 배열 프로퍼티 확장입니다.
///
/// - fetchBookUseCase, favoriteBookUseCase 등 기본 유스케이스 정의를 제공합니다.
extension UseCaseModuleFactory {
  /// 기본 유스케이스 정의 배열입니다.
  ///
  /// - 주의: self를 직접 캡처하지 않기 위해 registerModule의 복사본을 사용합니다.
  public var useCaseDefinitions: [() -> Module] {
    let registerModuleCopy = registerModule  // self를 직접 캡처하지 않고 복사
    return [
      registerModuleCopy.bookSearchUseCase,
      registerModuleCopy.favoriteBookUseCase
    ]
  }
}
