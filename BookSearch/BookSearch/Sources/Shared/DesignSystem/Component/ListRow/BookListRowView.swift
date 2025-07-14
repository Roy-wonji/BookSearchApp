//
//  BookListRowView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/14/25.
//

import SwiftUI

/// 도서 정보를 리스트 형태로 보여주는 행(Row) 뷰입니다.
///
/// - 도서 썸네일, 제목, 출판사, 저자, 즐겨찾기(좋아요) 버튼을 표시합니다.
struct BookListRowView: View {
  /// 표시할 도서 정보
  let book: Book
  /// 즐겨찾기(좋아요) 버튼 탭 액션
  let onFavoriteTapped: () -> Void
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // 썸네일 이미지
      RoundedRectangle(cornerRadius: 8)
        .fill(Color.gray.opacity(0.2))
        .frame(width: 60, height: 80)
        .overlay {
          AsyncImage(url: URL(string: book.thumbnailURL ?? "")) { image in
            image.resizable().scaledToFill()
          } placeholder: {
            Color.gray.opacity(0.1)
          }
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }
      
      // 도서 정보
      VStack(alignment: .leading, spacing: 4) {
        Text("도서")
          .pretendardFont(family: .Medium, size: 12)
          .foregroundStyle(.gray40)
        
        Text(book.title)
          .pretendardFont(family: .SemiBold, size: 17)
          .lineLimit(2)
        
        Text("출판사: \(book.publisher ?? "-")")
          .pretendardFont(family: .Regular, size: 15)
          .foregroundStyle(.gray40)
        
        Text("저자: \(book.authors.joined(separator: ", "))")
          .pretendardFont(family: .Regular, size: 15)
          .foregroundStyle(.gray40)
      }
      
      Spacer()
      
      // 즐겨찾기(좋아요) 아이콘
      Image(systemName: book.isFavorite ? "heart.fill" : "heart")
        .foregroundStyle(.gray40)
        .onTapGesture {
          onFavoriteTapped()
        }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
  }
}
