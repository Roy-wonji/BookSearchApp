//
//  SortHeaderView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import SwiftUI

/// 검색 결과 상단에 정렬/필터 버튼을 표시하는 헤더 뷰입니다.
///
/// - 정렬 타입, 정렬/필터 버튼, 정렬 타입 토글 기능을 제공합니다.
struct SortHeaderView: View {
  /// 현재 정렬 타입
  let sortType: SearchSortType
  /// 필터 버튼 노출 여부
  let showFilter: Bool
  /// 정렬 버튼 탭 액션
  let onSortTapped: () -> Void
  /// 정렬 타입 토글 액션
  let onToggleSortType: (SearchSortType) -> Void
  /// 필터 버튼 탭 액션
  let onFilterTapped: () -> Void
  
  /// 생성자
  /// - Parameters:
  ///   - sortType: 현재 정렬 타입
  ///   - showFilter: 필터 버튼 노출 여부
  ///   - onSortTapped: 정렬 버튼 액션
  ///   - onToggleSortType: 정렬 타입 토글 액션
  ///   - onFilterTapped: 필터 버튼 액션
  init(
    sortType: SearchSortType,
    showFilter: Bool = false,
    onSortTapped: @escaping () -> Void,
    onToggleSortType: @escaping (SearchSortType) -> Void,
    onFilterTapped: @escaping () -> Void = {}
  ) {
    self.sortType = sortType
    self.showFilter = showFilter
    self.onSortTapped = onSortTapped
    self.onToggleSortType = onToggleSortType
    self.onFilterTapped = onFilterTapped
  }
  
  var body: some View {
    HStack {
      // 정렬 타입 텍스트 (탭 시 타입 토글)
      Text(sortType == .accuracy ? "정확도순" : "발간일순")
        .pretendardFont(family: .SemiBold, size: 14)
        .foregroundColor(.black)
        .onTapGesture {
          onToggleSortType(sortType == .accuracy ? .latest : .accuracy)
        }
      
      Spacer()
      
      // 조건에 따라 필터 버튼 노출
      if showFilter {
        Button(action: onFilterTapped) {
          HStack(spacing: 4) {
            Image(systemName: "slider.horizontal.3")
              .pretendardFont(family: .Medium, size: 12)
              .foregroundStyle(.staticBlack)
            Text("필터")
              .pretendardFont(family: .Medium, size: 14)
              .foregroundStyle(.staticBlack)
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(Color.white)
          .cornerRadius(16)
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color.gray.opacity(0.4), lineWidth: 1)
          )
        }
      }
      
      // 정렬 버튼
      Button(action: onSortTapped) {
        HStack(spacing: 4) {
          Image(systemName: "arrow.up.arrow.down")
            .pretendardFont(family: .Medium, size: 12)
            .foregroundStyle(.staticBlack)
          Text("정렬")
            .pretendardFont(family: .Medium, size: 14)
            .foregroundStyle(.staticBlack)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
  }
}
