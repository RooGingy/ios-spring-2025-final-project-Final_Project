//
//  NavbarView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct NavbarView: View {
	var body: some View {
		HStack {
			navButton(systemName: "house.fill", label: "Home")
			Spacer()
			navButton(systemName: "cart.fill", label: "Cart")
			Spacer()
			navButton(systemName: "heart.text.square.fill", label: "Wishlist")
			Spacer()
			navButton(systemName: "clock.arrow.circlepath", label: "Orders")
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 10)
		.background(Color(.systemGray6))
		.shadow(radius: 5)
		.frame(maxWidth: .infinity)
	}

	private func navButton(systemName: String, label: String) -> some View {
		Button(action: {
			// Handle the action here ya lazy bastard
		}) {
			VStack(spacing: 4) {
				Image(systemName: systemName)
					.font(.system(size: 20, weight: .semibold))
				Text(label)
					.font(.caption2)
			}
			.foregroundColor(.blue)
		}
	}
}

#Preview {
	NavbarView()
}
