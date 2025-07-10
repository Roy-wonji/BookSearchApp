//
//  SearchDetailView.swift
//  BookSearch
//
//  Created by Wonji Suh  on 7/11/25.
//

import SwiftUI

struct SearchDetailView: View {
  @EnvironmentObject private var coordinator: SearchCoordinator
  var book: Book

  var body: some View {
    ZStack{
      Color.white
        .edgesIgnoringSafeArea(.all)

      VStack{
        CustomNavigationBackBar {
          coordinator.goBack()
        }

        bookDetailView(book: book)
          .padding(.top, 10)

      }
    }
  }
}

extension SearchDetailView {
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


        bookDescriptionView(book: book)
          .padding(.top, 20)
      }
      .padding(.horizontal)
    }
  }


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

  private func formattedDate(_ date: Date?) -> String {
    guard let date else { return "-" }
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
  }

  private func priceText(_ price: Int?) -> String {
    guard let price, price >= 0 else { return "N원" }
    return "\(price)원"
  }
}

#Preview {
  let book = Book.mock
  SearchDetailView(book:  book)
}
