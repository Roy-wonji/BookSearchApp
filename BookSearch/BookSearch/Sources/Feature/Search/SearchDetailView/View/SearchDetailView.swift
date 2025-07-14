//
//  SearchDetailView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/11/25.
//

import SwiftUI

/// 도서 상세 정보를 보여주는 View입니다.
///
/// - 도서 제목, 표지, 상세 정보, 책 소개, 즐겨찾기 토글 및 뒤로가기 버튼을 포함합니다.
struct SearchDetailView: View {
  /// 상세 표시할 도서 (Binding)
  @Binding var book: Book

  /// 즐겨찾기 여부
  var isFavorite: Bool

  /// 즐겨찾기 토글 액션
  var onToggleFavorite: () -> Void

  /// 뒤로가기 액션
  var backAction: () -> Void

  var body: some View {
    ZStack {
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack {
        // 커스텀 네비게이션 바 (뒤로가기, 즐겨찾기)
        CustomNavigationBackBar(
          isFavorite: isFavorite,
          buttonAction: {
            backAction()
          },
          onToggleFavorite: {
            onToggleFavorite()
          }
        )
        // 도서 상세 정보
        bookDetailView(book: book)
          .padding(.top, 10)
      }
    }
  }
}

extension SearchDetailView {
  /// 도서 상세 정보 뷰
  @ViewBuilder
  func bookDetailView(book: Book) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {

        // 도서 제목
        Text(book.title)
          .font(.title2)
          .fontWeight(.bold)

        // 표지 및 상세 정보
        HStack(alignment: .top, spacing: 16) {

          // 썸네일 이미지
          RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 100, height: 140)
            .overlay(
              AsyncImage(url: URL(string: book.thumbnailURL ?? "")) { image in
                image
                  .resizable()
                  .scaledToFill()
              } placeholder: {
                Color.gray.opacity(0.1)
              }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            )

          // 텍스트 정보
          VStack(alignment: .leading, spacing: 6) {
            Text("저자: \(book.authors.joined(separator: ", "))")
            Text("출판사: \(book.publisher ?? "-")")
            Text("출간일: \(formattedDate(book.publishedAt))")
            Text("ISBN: \(book.isbn ?? "-")")
            Text("정상가: \(priceText(book.price))")
            Text("할인가: \(priceText(book.salePrice))")
          }
          .pretendardFont(family: .Regular, size: 15)
          .foregroundColor(.staticBlack)
        }

        // 책 소개
        bookDescriptionView(book: book)
          .padding(.top, 20)
      }
      .padding(.horizontal)
    }
  }

  /// 책 소개 뷰
  @ViewBuilder
  func bookDescriptionView(book: Book) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("책 소개")
        .pretendardFont(family: .SemiBold, size: 17)
        .foregroundStyle(.staticBlack)

      Text(book.description.isEmpty ? "책 소개가 비었습니다." : book.description)
        .pretendardFont(family: .Regular, size: 15)
        .foregroundStyle(.staticBlack)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
  }

  /// 날짜를 "yyyy년 MM월 dd일" 형식으로 변환
  private func formattedDate(_ date: Date?) -> String {
    guard let date else { return "-" }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
  }

  /// 가격을 "N원" 형식으로 변환
  private func priceText(_ price: Int?) -> String {
    guard let price, price >= 0 else { return "N원" }
    return "\(price)원"
  }
}

#Preview {
  @State var book = Book.mock
  var viewmodel = BookListViewModel()
  SearchDetailView(book:  $book, isFavorite: viewmodel.isFavorite(book)) {
    viewmodel.isFavorite(book)
  } backAction: {}
}
