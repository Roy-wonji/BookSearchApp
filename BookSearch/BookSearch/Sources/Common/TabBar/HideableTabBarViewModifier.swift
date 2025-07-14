//
//  HideableTabBarViewModifier.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/13/25.
//

import SwiftUI

/// SwiftUI에서 UIKit의 TabBar를 숨기거나 보이게 할 수 있는 ViewModifier
struct HideableTabBarViewModifier: ViewModifier {
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

/// UIKit의 UITabBar에 접근할 수 있도록 해주는 UIViewControllerRepresentable
struct TabBarAccessor: UIViewControllerRepresentable {
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

/// UITabBarController를 재귀적으로 찾는 UIViewController 확장
extension UIViewController {
  func findTabBarController() -> UITabBarController? {
    if let tab = self as? UITabBarController {
      return tab
    }
    return children.compactMap { $0.findTabBarController() }.first
  }
}

