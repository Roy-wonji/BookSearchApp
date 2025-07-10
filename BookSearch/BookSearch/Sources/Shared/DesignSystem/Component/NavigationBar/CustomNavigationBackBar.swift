//
//  CustomNavigationBackBar.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/11/25.
//

import SwiftUI

struct CustomNavigationBackBar: View {
  var buttonAction: () -> Void = { }

  public init(
    buttonAction: @escaping () -> Void
  ) {
    self.buttonAction = buttonAction
  }

  public var body: some View {
    HStack {
      Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 10, height: 20)
        .foregroundStyle(.staticBlack)
        .onTapGesture {
          buttonAction()
        }
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}
