//
//  EmptyResultView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import SwiftUI

/// 검색 결과가 없을 때 표시되는 뷰
struct EmptyResultView: View {
  let mainTitle: String
  let subTitle: String

  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: "book.closed")
        .resizable()
        .scaledToFit()
        .frame(width: 60, height: 60)
        .foregroundStyle(.gray60)

      Text(mainTitle)
        .pretendardFont(family: .Bold, size: 16)
        .foregroundStyle(.gray60)

      Text(subTitle)
        .pretendardFont(family: .Medium, size: 14)
        .foregroundStyle(.gray40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
  }
}
