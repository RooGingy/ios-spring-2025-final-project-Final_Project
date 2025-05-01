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

    @State private var showQuantitySelector = false

    var body: some View {
        VStack {
            if showQuantitySelector {
                HStack(spacing: 12) {
                    // Quantity controls
                    HStack {
                        Button(action: {
                            if quantity == 1 {
                                showQuantitySelector = false
                            } else {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.title2)
                                .frame(width: 32, height: 32)
                        }
                        .opacity(quantity <= 1 ? 0.5 : 1)

                        Text("Qty: \(quantity)")
                            .font(.headline)
                            .frame(minWidth: 60)

                        Button(action: {
                            if quantity < available {
                                quantity += 1
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .frame(width: 32, height: 32)
                        }
                        .disabled(quantity >= available)
                        .opacity(quantity >= available ? 0.5 : 1)
                    }

                    Spacer()

                    // Add to Cart button inside the bar
                    Button(action: onAdd) {
                        Text("Add to Cart")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color("SoftTealBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color("SoftTealBlue").opacity(0.15))
                .cornerRadius(12)
            } else {
                Button(action: {
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
// MARK: - CheckoutButton
struct CheckoutButton: View {
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
