//
//  SearchBarView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import Foundation

import SwiftUI

/// 검색어를 입력하는 커스텀 검색 바
struct SearchBarView: View {
  @Binding var text: String

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray40)

      TextField("제목 또는 저자를 입력하세요.", text: $text)
        .foregroundColor(.primary)
        .pretendardFont(family: .Medium, size: 18)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(Color(UIColor.systemGray6))
    .cornerRadius(20)
    .padding(.horizontal, 16)
  }
}
