//
//  BookDetailView.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

import SwiftUI

struct BookDetailView: View {
	let book: Book
	@State private var cartQuantity = 1
	@State private var isInWishlist = false

	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				VStack(alignment: .center, spacing: 20) {
					// 📘 Cover
					AsyncImage(url: URL(string: book.coverImage)) { phase in
						switch phase {
						case .empty:
							ProgressView()
								.frame(width: 180, height: 260)
						case .success(let image):
							image
								.resizable()
								.scaledToFit()
								.frame(width: 180, height: 260)
								.cornerRadius(12)
								.shadow(radius: 5)
						case .failure:
							Image(systemName: "book.closed")
								.resizable()
								.scaledToFit()
								.frame(width: 180, height: 260)
								.foregroundColor(.gray)
						@unknown default:
							EmptyView()
						}
					}

					// Title / Author / Genre
					VStack(spacing: 8) {
						Text(book.title)
							.font(.title)
							.fontWeight(.bold)
							.multilineTextAlignment(.center)

						Text("by \(book.author)")
							.font(.subheadline)
							.foregroundColor(.secondary)

						Text(book.genres)
							.font(.callout)
							.padding(.horizontal, 10)
							.padding(.vertical, 4)
							.background(Color.blue.opacity(0.1))
							.cornerRadius(8)
					}

					// Book Stats
					LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
						BookStatView(label: "Price", value: "$\(String(format: "%.2f", book.price))")
						BookStatView(label: "ISBN", value: book.isbn)
						BookStatView(label: "Rating", value: String(format: "%.1f", book.rating))
						BookStatView(label: "In Stock", value: "\(book.onHand)")
					}
					.padding()
					.background(Color(.systemGray6))
					.cornerRadius(12)

					// Description
					VStack(alignment: .leading, spacing: 10) {
						Text(book.description.paragraph1)
						Text(book.description.paragraph2)
						Text(book.description.paragraph3)
					}
					.font(.body)
					.padding(.horizontal)
				}
				.padding()
			}

			// Wishlist and Cart Buttons
			CartActionBar(
				book: book,
				quantity: $cartQuantity,
				isInWishlist: $isInWishlist,
				onAddToCart: {
					print("🛒 Add \(cartQuantity) of \(book.title) to cart")
					// Firestore logic here
				},
				onToggleWishlist: {
					isInWishlist.toggle()
					print(isInWishlist ? "❤️ Added to wishlist" : "💔 Removed from wishlist")
					// Firestore toggle here
				},
				onCheckout: {
					print("🧾 Proceeding to checkout with \(cartQuantity) of \(book.title)")
					// Navigate to CartView or CheckoutView
				}
			)
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	let sampleBook = Book(
		id: "123",
		title: "Sample Book",
		author: "Jane Doe",
		genres: "Fiction",
		isbn: "9781234567890",
		description: BookDescription(
			paragraph1: "This is the first paragraph of the book description. It gives an overview of the plot.",
			paragraph2: "The second paragraph adds depth, introducing key characters and themes.",
			paragraph3: "The third paragraph wraps up the synopsis and hints at the book's conclusion."
		),
		coverImage: "https://m.media-amazon.com/images/I/61bxwUK6K4L._AC_UF894,1000_QL80_.jpg",
		rating: 4.5,
		price: 9.99,
		inStock: true,
		onHand: 12
	)

	return NavigationStack {
		BookDetailView(book: sampleBook)
	}
}
