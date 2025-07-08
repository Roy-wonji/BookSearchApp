//
//  NavigationControlling.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/8/25.
//

import Foundation
import SwiftUI

// MARK: - Navigation 제어 프로토콜

/// SwiftUI `NavigationStack` 기반 화면 전환을 제어하는 공통 프로토콜입니다.
///
/// 각 탭 또는 플로우 별로 코디네이터가 이 프로토콜을 채택하면
/// 공통적인 `goBack`, `reset` 동작을 재사용할 수 있습니다.
protocol NavigationControlling: AnyObject {

  /// 현재 네비게이션 경로 상태입니다.
  ///
  /// `NavigationStack(path:)`에 바인딩되어 화면 이동을 제어합니다.
  var path: NavigationPath { get set }

  /// 초기 진입 지점을 설정하는 메서드입니다.
  ///
  /// 각 코디네이터에서 구현되어야 하며,
  /// 앱 시작 또는 탭 변경 시 루트 화면을 정의합니다.
  func start()

  /// 마지막 화면을 스택에서 제거하여 이전 화면으로 이동합니다.
  func goBack()

  /// 스택의 모든 경로를 제거하고 루트 화면으로 돌아갑니다.
  func reset()
}

// MARK: - NavigationControlling 기본 구현

extension NavigationControlling {

  /// 현재 화면을 스택에서 팝(뒤로 가기)합니다.
  ///
  /// - 동작:
  ///   - `path`가 비어있지 않은 경우, 마지막 항목을 제거하여 이전 화면으로 이동합니다.
  ///
  /// - 예시:
  ///   ```swift
  ///   coordinator.goBack()
  ///   ```
  func goBack() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  /// 네비게이션 스택을 초기 상태(루트)로 리셋합니다.
  ///
  /// - 동작:
  ///   - 현재 경로 배열에서 모든 화면을 제거하여, 루트 화면만 유지합니다.
  ///
  /// - 예시:
  ///   ```swift
  ///   coordinator.reset()
  ///   ```
  func reset() {
    path.removeLast(path.count)
  }
}
