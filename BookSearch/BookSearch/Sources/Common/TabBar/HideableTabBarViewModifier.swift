//
//  HideableTabBarViewModifier.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/13/25.
//

import SwiftUI

/// SwiftUI에서 UIKit의 TabBar를 숨기거나 보이게 할 수 있는 ViewModifier입니다.
///
/// - isHidden 값에 따라 UITabBar의 표시/숨김을 제어합니다.
/// - UIKit의 TabBar에 접근하기 위해 TabBarAccessor를 활용합니다.
struct HideableTabBarViewModifier: ViewModifier {
  /// TabBar를 숨길지 여부
  let isHidden: Bool
  
  func body(content: Content) -> some View {
    content
      .background(TabBarAccessor { tabBar in
        // 뷰 계층 복구 타이밍을 맞추기 위해 아주 짧은 딜레이를 줍니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
          tabBar?.isHidden = isHidden
        }
      })
  }
}

/// UIKit의 UITabBar에 접근할 수 있도록 해주는 UIViewControllerRepresentable입니다.
///
/// - SwiftUI에서 UIKit TabBar를 제어할 때 사용합니다.
/// - 콜백으로 UITabBar 인스턴스를 전달합니다.
struct TabBarAccessor: UIViewControllerRepresentable {
  /// UITabBar를 전달받을 콜백
  var callback: (UITabBar?) -> Void
  
  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    DispatchQueue.main.async {
      let tabBar = uiViewController.view.window?.rootViewController?.findTabBarController()?.tabBar
      self.callback(tabBar)
    }
  }
}

/// UITabBarController를 재귀적으로 찾는 UIViewController 확장입니다.
///
/// - 뷰 계층 구조 어디에서든 UITabBarController를 탐색할 수 있습니다.
extension UIViewController {
  /// 현재 또는 자식 뷰컨트롤러에서 UITabBarController를 찾아 반환합니다.
  func findTabBarController() -> UITabBarController? {
    if let tab = self as? UITabBarController {
      return tab
    }
    return children.compactMap { $0.findTabBarController() }.first
  }
}
