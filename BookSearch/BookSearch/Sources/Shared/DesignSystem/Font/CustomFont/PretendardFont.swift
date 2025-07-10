//
//  PretendardFont.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import SwiftUI

struct PretendardFont: ViewModifier {
  public let family: PretendardFontFamily
  public let size: CGFloat

  func body(content: Content) -> some View {
    return content
      .font(.custom("PretendardVariable-\(family)", fixedSize: size))
  }
}

extension View {
  func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> some View {
    return self.modifier(PretendardFont(family: family, size: size))
  }
}

extension UIFont {
  static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> UIFont {
    let fontName = "PretendardVariable-\(family)"
    return UIFont(name: fontName, size: size) ?? UIFont
      .systemFont(ofSize: size, weight: .regular)
  }
}

extension Font {
  static func pretendardFontFamily(family: PretendardFontFamily, size: CGFloat) -> Font{
    let font = Font.custom("PretendardVariable-\(family)", size: size)
    return font
  }
}
