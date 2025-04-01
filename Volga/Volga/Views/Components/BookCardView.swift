//
//  BookCardView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct BookCardView: View {
	let book: Book

	var body: some View {
		HStack(spacing: 16) {
			Image(book.imageName)
				.resizable()
				.scaledToFill()
				.frame(width: 100, height: 140)
				.clipped()
				.cornerRadius(8)

			VStack(alignment: .leading, spacing: 8) {
				Text(String(format: "$%.2f", book.price))
					.font(.title2)
					.fontWeight(.semibold)

				Text(book.title)
					.font(.title3)
					.fontWeight(.medium)
					.lineLimit(2)
					.truncationMode(.tail)

				Text("Author: \(book.author)")
					.font(.subheadline)
					.foregroundColor(.secondary)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
		.shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
	}
}
#Preview {
    BookCardView(book: .init(title: "Test Book", author: "Test Author", price: 12.99, imageName: "book"))
}
