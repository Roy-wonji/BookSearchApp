//
//  EmptyResultView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import SwiftUI

/// 검색 결과가 없을 때 표시되는 뷰입니다.
///
/// - 메인 타이틀과 서브 타이틀, 아이콘을 함께 표시합니다.
struct EmptyResultView: View {
  /// 메인 타이틀
  let mainTitle: String
  /// 서브 타이틀
  let subTitle: String
  
  var body: some View {
    VStack(spacing: 12) {
      // 닫힌 책 아이콘
      Image(systemName: "book.closed")
        .resizable()
        .scaledToFit()
        .frame(width: 60, height: 60)
        .foregroundStyle(.gray60)
      
      // 메인 타이틀
      Text(mainTitle)
        .pretendardFont(family: .Bold, size: 16)
        .foregroundStyle(.gray60)
      
      // 서브 타이틀
      Text(subTitle)
        .pretendardFont(family: .Medium, size: 14)
        .foregroundStyle(.gray40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
  }
}
