//
//  CustomNavigationBackBar.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/11/25.
//

import SwiftUI

struct CustomNavigationBackBar: View {
  var buttonAction: () -> Void = { }
   var isFavorite: Bool
  var onToggleFavorite: () -> Void

   init(
    isFavorite: Bool,
    buttonAction: @escaping () -> Void,
    onToggleFavorite: @escaping () -> Void
  ) {
    self.buttonAction = buttonAction
    self.isFavorite = isFavorite
    self.onToggleFavorite = onToggleFavorite
  }

  public var body: some View {
    HStack {
      // 왼쪽: 뒤로가기
      Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 10, height: 20)
        .foregroundStyle(.staticBlack)
        .onTapGesture {
          buttonAction()
        }

      Spacer()

      // 오른쪽: 즐겨찾기
      Image(systemName: isFavorite ? "heart.fill" : "heart")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
        .foregroundStyle(isFavorite ? .red : .gray)
        .onTapGesture {
          onToggleFavorite()
        }
    }
    .padding(.horizontal, 24)
  }
}
