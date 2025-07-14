//
//  SortHeaderView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import SwiftUI

struct SortHeaderView: View {
  let sortType: SearchSortType
  let showFilter: Bool
  let onSortTapped: () -> Void
  let onToggleSortType: (SearchSortType) -> Void
  let onFilterTapped: () -> Void


  init(
    sortType: SearchSortType,
    showFilter: Bool = false,
    onSortTapped: @escaping () -> Void,
    onToggleSortType: @escaping (
      SearchSortType
    ) -> Void,
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
      Text(sortType == .accuracy ? "정확도순" : "발간일순")
        .pretendardFont(family: .SemiBold, size: 14)
        .foregroundColor(.black)
        .onTapGesture {
                onToggleSortType(sortType == .accuracy ? .latest : .accuracy)
            }

      Spacer()
      
      // 조건에 따라 필터 버튼과 액션 노출
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
