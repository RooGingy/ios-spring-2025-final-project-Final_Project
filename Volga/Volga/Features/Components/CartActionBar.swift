//
//  CartActionBar.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

import SwiftUI

struct CartActionBar: View {
	let book: Book
	@Binding var quantity: Int
	@Binding var isInWishlist: Bool
	let onAddToCart: () -> Void
	let onToggleWishlist: () -> Void
	let onCheckout: (() -> Void)?

	@State private var showQuantityControls = false

	var body: some View {
		VStack(spacing: 12) {
			// Smart Add to Cart / Quantity Control
			if showQuantityControls {
				HStack(spacing: 16) {
					Button {
						if quantity > 1 {
							quantity -= 1
						} else {
							// Collapse if going back to 0
							showQuantityControls = false
							quantity = 1
						}
					} label: {
						Image(systemName: "minus.circle.fill")
							.font(.title2)
					}

					Text("Qty: \(quantity)")
						.font(.headline)

					Button {
						quantity += 1
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title2)
					}
				}
				.padding()
				.background(Color.blue.opacity(0.1))
				.foregroundColor(.blue)
				.cornerRadius(12)
			} else {
				Button(action: {
					onAddToCart()
					showQuantityControls = true
				}) {
					Label("Add to Cart", systemImage: "cart.fill.badge.plus")
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("SoftTealBlue"))
						.foregroundColor(.white)
						.cornerRadius(12)
				}
			}

			// Wishlist Button
			Button(action: onToggleWishlist) {
				Label(isInWishlist ? "In Wishlist" : "Add to Wishlist", systemImage: isInWishlist ? "heart.fill" : "heart")
					.fontWeight(.medium)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color("SlightlyLighterGray"))
					.foregroundColor(isInWishlist ? .red : .primary)
					.cornerRadius(12)
			}

			// Optional Checkout Button
			if let onCheckout {
				Button(action: onCheckout) {
					Label("Go to Checkout", systemImage: "creditcard")
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("SoftGreen"))
						.foregroundColor(.white)
						.cornerRadius(12)
				}
			}
		}
		.padding()
		.background(.ultraThinMaterial)
		.shadow(radius: 6)
	}
}

#Preview {
	CartActionBar(
		book: Book(
			id: "1",
			title: "Sample",
			author: "Author",
			genres: "Genre",
			isbn: "123",
			description: .init(paragraph1: "", paragraph2: "", paragraph3: ""),
			coverImage: "",
			rating: 4.0,
			price: 12.99,
			inStock: true,
			onHand: 10
		),
		quantity: .constant(2),
		isInWishlist: .constant(false),
		onAddToCart: {},
		onToggleWishlist: {},
		onCheckout: {}
	)
	.padding()
}
