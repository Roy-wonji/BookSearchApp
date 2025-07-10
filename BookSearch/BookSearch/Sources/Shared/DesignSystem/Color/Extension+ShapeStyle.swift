//
//  Extension+ShapeStyle.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/10/25.
//

import SwiftUI

extension ShapeStyle where Self == Color {

  // MARK: - Static Basic

  static var staticWhite: Color { .init(hex: "FFFFFF") }
  static var staticBlack: Color { .init(hex: "0C0E0F") }

  // MARK: - Static Text

  static var textPrimary: Color { .init(hex: "FFFFFF") }
  static var textSecondary: Color { .init(hex: "EAEAEA") }
  static var textSecondary100: Color { .init(hex: "525252") }
  static var textInactive: Color { .init(hex: "70737C47").opacity(0.28) }

  // MARK: - Static Background

  static var backGroundPrimary: Color { .init(hex: "0C0E0F") }
  static var backgroundInverse: Color { .init(hex: "FFFFFF") }

  // MARK: - Static Border

  static var borderInactive: Color { .init(hex: "C6C6C6") }
  static var borderDisabled: Color { .init(hex: "323537") }
  static var borderInverse: Color { .init(hex: "202325") }

  // MARK: - Static Status

  static var statusFocus: Color { .init(hex: "0D82F9") }
  static var statusCautionary: Color { .init(hex: "FD5D08") }
  static var statusError: Color { .init(hex: "FD1008") }

  // MARK: - Primitives

  static var grayBlack: Color { .init(hex: "1A1A1A") }
  static var gray80: Color { .init(hex: "323537") }
  static var gray60: Color { .init(hex: "6F6F6F") }
  static var gray40: Color { .init(hex: "A8A8A8") }
  static var gray90: Color { .init(hex: "202325") }
  static var grayError: Color { .init(hex: "FF5050") }
  static var grayWhite: Color { .init(hex: "FFFFFF") }
  static var grayPrimary: Color { .init(hex: "0099FF") }

  static var blue30: Color { .init(hex: "C1D3FF") }

}
