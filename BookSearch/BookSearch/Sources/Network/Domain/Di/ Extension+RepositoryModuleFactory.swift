//
//   Extension+RepositoryModuleFactory.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation
import DiContainer

/// RepositoryModuleFactory의 기본 저장소 등록 함수 확장입니다.
///
/// - fetchBookRepository, favoriteBookRepository 등 기본 저장소 정의를 등록합니다.
extension RepositoryModuleFactory {
    /// 기본 저장소 정의를 등록합니다.
    ///
    /// - 주의: self를 직접 캡처하지 않기 위해 registerModule의 복사본을 사용합니다.
    public mutating func registerDefaultDefinitions() {
        let registerModuleCopy = registerModule  // self를 직접 캡처하지 않고 복사
        repositoryDefinitions = {
            return [
                registerModuleCopy.bookSearcBookRepository,
                registerModuleCopy.favoriteBookRepository
            ]
        }()
    }
}

