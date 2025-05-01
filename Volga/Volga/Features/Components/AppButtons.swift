//
//  AppButtons.swift
//  Volga
//
//  Created by Austin Moser on 4/23/25.
//

import SwiftUI

// MARK: - AddToCartButton
struct AddToCartButton: View {
    let available: Int
    @Binding var quantity: Int
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Quantity selector row
            HStack {
                Button(action: {
                    if quantity > 0 {
                        quantity -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                }
                .opacity(quantity <= 1 ? 0.5 : 1)

                Spacer()

                Text("Qty: \(quantity)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: {
                    if quantity < available {
                        quantity += 1
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                }
                .opacity(quantity >= available ? 0.5 : 1)
                .disabled(quantity >= available)
            }

            // Full-width Add to Cart button
            Button(action: onAdd) {
                Label("Add to Cart", systemImage: "cart.fill.badge.plus")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("SoftTealBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color("SoftTealBlue").opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - CartButton
struct CartButton: View {
	let onCheckout: () -> Void

	var body: some View {
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

// MARK: - SeeReviewsButton
struct SeeReviewsButton: View {
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Label("See Reviews", systemImage: "text.book.closed")
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color("SoftTealBlue"))
				.foregroundColor(.white)
				.cornerRadius(12)
		}
	}
}

// MARK: - WishlistButton
struct WishlistButton: View {
	@Binding var isInWishlist: Bool
	let onToggle: () -> Void

	var body: some View {
		Button(action: onToggle) {
			Label(isInWishlist ? "In Wishlist" : "Add to Wishlist", systemImage: isInWishlist ? "heart.fill" : "heart")
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color("SlightlyLighterGray"))
				.foregroundColor(isInWishlist ? .red : .primary)
				.cornerRadius(12)
		}
	}
}

// MARK: - AddReviewButton
struct AddReviewButton: View {
	let onSubmit: (Int, String) -> Void

	@State private var showReviewSheet = false
	@State private var reviewText = ""
	@State private var starRating = 3

	var body: some View {
		Button("Write a Review") {
			showReviewSheet = true
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(Color("SoftTealBlue"))
		.foregroundColor(.white)
		.cornerRadius(12)
		.sheet(isPresented: $showReviewSheet) {
			NavigationStack {
				VStack(spacing: 20) {
					Text("Your Rating")
						.font(.headline)

					HStack {
						ForEach(1...5, id: \.self) { star in
							Image(systemName: star <= starRating ? "star.fill" : "star")
								.resizable()
								.frame(width: 28, height: 28)
								.foregroundColor(.yellow)
								.onTapGesture {
									starRating = star
								}
						}
					}

					TextEditor(text: $reviewText)
						.frame(height: 120)
						.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
						.padding(.horizontal)

					Button("Submit Review") {
						onSubmit(starRating, reviewText)
						showReviewSheet = false
					}
					.buttonStyle(.borderedProminent)
					.disabled(reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
				}
				.padding()
				.navigationTitle("Leave a Review")
				.navigationBarTitleDisplayMode(.inline)
			}
		}
	}
}

// MARK: - CustomButton
struct CustomButton: View {
	let title: String
	let icon: String?
	let bgColor: Color
	let fgColor: Color
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack {
				if let icon = icon {
					Image(systemName: icon)
				}
				Text(title)
			}
			.frame(maxWidth: .infinity)
			.padding()
			.background(bgColor)
			.foregroundColor(fgColor)
			.cornerRadius(12)
		}
	}
}
