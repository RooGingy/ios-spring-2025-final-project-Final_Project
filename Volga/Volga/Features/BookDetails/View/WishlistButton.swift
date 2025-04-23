//
//  WishlistButton.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct WishlistButton: View {
	@Binding var isInWishlist: Bool
	let onToggle: () -> Void

	var body: some View {
		Button(action: onToggle) {
			Label(
				isInWishlist ? "In Wishlist" : "Add to Wishlist",
				systemImage: isInWishlist ? "heart.fill" : "heart"
			)
			.frame(maxWidth: .infinity)
			.padding()
			.background(Color("SlightlyLighterGray"))
			.foregroundColor(isInWishlist ? .red : .primary)
			.cornerRadius(12)
		}
	}
}
