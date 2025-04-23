//
//  BookCard.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct BookCard: View {
	let book: Book

	var body: some View {
		HStack(spacing: 16) {
			AsyncImage(url: URL(string: book.coverImage)) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.frame(width: 100, height: 140)
				case .success(let image):
					image
						.resizable()
						.scaledToFill()
						.frame(width: 100, height: 140)
						.clipped()
				case .failure(_):
					Image(systemName: "book.closed")
						.resizable()
						.scaledToFit()
						.frame(width: 80, height: 100)
						.padding()
						.foregroundColor(.gray)
						.background(Color.gray.opacity(0.1))
						.cornerRadius(8)
				@unknown default:
					EmptyView()
				}
			}
			.cornerRadius(8)

			VStack(alignment: .leading, spacing: 6) {
				Text(String(format: "$%.2f", book.price))
					.font(.title3)
					.fontWeight(.bold)

				Text(book.title)
					.font(.headline)
					.lineLimit(2)

				Text("by \(book.author)")
					.font(.subheadline)
					.foregroundColor(.secondary)

				HStack(spacing: 4) {
					ForEach(0..<5) { index in
						Image(systemName: index < Int(book.rating) ? "star.fill" : "star")
							.foregroundColor(.yellow)
							.font(.caption)
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
		.shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
	}
}
