//
//  PrimaryButtonView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct PrimaryButtonView: View {
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
	PrimaryButtonView(title: "Login", backgroundColor: Color.teal, textColor: Color.black) {
	}

	PrimaryButtonView(title: "Create Account", backgroundColor: Color.teal, textColor: Color.black) {

	}

	PrimaryButtonView(title: "Back", backgroundColor: Color.teal, textColor: Color.black) {
	}
}
