//
//  OrderBookGrid.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//

import SwiftUI

struct OrderBookGrid: View {
    let books: [OrderBookItem]
    private let displayLimit = 4

    var body: some View {
        let visibleBooks = books.prefix(displayLimit)
        let remainingCount = books.count - visibleBooks.count

        HStack(spacing: 12) {
            ForEach(visibleBooks) { book in
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: book.coverURL)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else {
                            Color.gray
                        }
                    }
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)

                    if book.quantity > 1 {
                        Text("x\(book.quantity)")
                            .font(.caption2.bold())
                            .padding(4)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: -4, y: 4)
                    }
                }
            }

            if remainingCount > 0 {
                Text("+\(remainingCount)")
                    .font(.subheadline.bold())
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
    }
}
