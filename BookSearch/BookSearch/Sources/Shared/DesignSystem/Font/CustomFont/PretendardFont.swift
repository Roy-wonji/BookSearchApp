//
//  PretendardFont.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import SwiftUI

/// Pretendard 커스텀 폰트를 적용하는 ViewModifier입니다.
///
/// - family: 폰트 패밀리(굵기 등)
/// - size: 폰트 크기
struct PretendardFont: ViewModifier {
  /// Pretendard 폰트 패밀리(굵기 등)
  public let family: PretendardFontFamily
  /// 폰트 크기
  public let size: CGFloat
  
  func body(content: Content) -> some View {
    return content
      .font(.custom("PretendardVariable-\(family)", fixedSize: size))
  }
}

// MARK: - View 확장

extension View {
  /// Pretendard 커스텀 폰트를 적용하는 뷰 모디파이어입니다.
  ///
  /// - Parameters:
  ///   - family: Pretendard 폰트 패밀리(굵기 등)
  ///   - size: 폰트 크기
  /// - Returns: 커스텀 폰트가 적용된 뷰
  func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> some View {
    return self.modifier(PretendardFont(family: family, size: size))
  }
}

// MARK: - UIFont 확장

extension UIFont {
  /// Pretendard 커스텀 폰트를 반환합니다.
  ///
  /// - Parameters:
  ///   - family: Pretendard 폰트 패밀리(굵기 등)
  ///   - size: 폰트 크기
  /// - Returns: Pretendard 커스텀 폰트 또는 기본 시스템 폰트
  static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> UIFont {
    let fontName = "PretendardVariable-\(family)"
    return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
  }
}

// MARK: - Font 확장

extension Font {
  /// Pretendard 커스텀 폰트를 반환합니다.
  ///
  /// - Parameters:
  ///   - family: Pretendard 폰트 패밀리(굵기 등)
  ///   - size: 폰트 크기
  /// - Returns: Pretendard 커스텀 폰트
  static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> Font {
    let font = Font.custom("PretendardVariable-\(family)", size: size)
    return font
  }
}
