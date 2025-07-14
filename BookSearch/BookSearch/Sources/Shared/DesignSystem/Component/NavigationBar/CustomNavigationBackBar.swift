//
//  CustomNavigationBackBar.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/11/25.
//

import SwiftUI

/// 커스텀 내비게이션 바(뒤로가기 + 즐겨찾기 토글) 뷰입니다.
///
/// - 왼쪽: 뒤로가기 버튼, 오른쪽: 즐겨찾기(하트) 버튼을 제공합니다.
struct CustomNavigationBackBar: View {
  /// 뒤로가기 버튼 액션
  var buttonAction: () -> Void = { }
  /// 즐겨찾기 상태
  var isFavorite: Bool
  /// 즐겨찾기 토글 액션
  var onToggleFavorite: () -> Void
  
  /// 생성자
  /// - Parameters:
  ///   - isFavorite: 즐겨찾기 상태
  ///   - buttonAction: 뒤로가기 버튼 액션
  ///   - onToggleFavorite: 즐겨찾기 토글 액션
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
      // 왼쪽: 뒤로가기 버튼
      Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 10, height: 20)
        .foregroundStyle(.staticBlack)
        .onTapGesture {
          buttonAction()
        }
      
      Spacer()
      
      // 오른쪽: 즐겨찾기(하트) 버튼
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
