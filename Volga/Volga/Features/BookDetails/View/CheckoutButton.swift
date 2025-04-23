//
//  CheckoutButton.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

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
