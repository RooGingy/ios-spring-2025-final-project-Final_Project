//
//  PrimaryButton.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct PrimaryButton: View {
	let title: String
	let width: CGFloat = 340
	let height: CGFloat = 50
	let backgroundColor: Color
	let textColor: Color
	let action: () -> Void

	var body: some View {
		Button(action: {
			action()
		}) {
			Text(title)
				.font(.body)
				.foregroundColor(textColor)
				.frame(width: width, height: height)
				.background(backgroundColor)
				.cornerRadius(10)
		}
	}
}

#Preview {
	PrimaryButton(title: "Login", backgroundColor: Color.teal, textColor: Color.black) {
	}

	PrimaryButton(title: "Create Account", backgroundColor: Color.teal, textColor: Color.black) {

	}

	PrimaryButton(title: "Back", backgroundColor: Color.teal, textColor: Color.black) {
	}
}
