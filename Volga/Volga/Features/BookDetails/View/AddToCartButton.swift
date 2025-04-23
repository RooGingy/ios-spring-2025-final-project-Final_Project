//
//  AddToCartButton.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct AddToCartButton: View {
	let book: Book
	@Binding var quantity: Int
	let onAddToCart: () -> Void

	@State private var showQuantitySelector = false

	var body: some View {
		Group {
			if showQuantitySelector {
				HStack {
					// Minus Button
					Button {
						if quantity == 1 {
							showQuantitySelector = false
							quantity = 1
						} else {
							quantity -= 1
						}
					} label: {
						Image(systemName: "minus")
							.font(.title2)
							.frame(width: 44, height: 44)
					}
					.opacity(quantity <= 1 ? 0.5 : 1)

					Spacer()

					// Quantity Display
					Text("Qty: \(quantity)")
						.font(.headline)
						.frame(maxWidth: .infinity)
						.multilineTextAlignment(.center)

					Spacer()

					// Plus Button
					Button {
						if quantity < book.onHand {
							quantity += 1
						}
					} label: {
						Image(systemName: "plus")
							.font(.title2)
							.frame(width: 44, height: 44)
					}
					.disabled(quantity >= book.onHand)
					.opacity(quantity >= book.onHand ? 0.5 : 1)
				}
				.padding()
				.background(Color("SoftTealBlue").opacity(0.15))
				.foregroundColor(.blue)
				.cornerRadius(12)
			} else {
				Button(action: {
					onAddToCart()
					showQuantitySelector = true
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
		}
	}
}
