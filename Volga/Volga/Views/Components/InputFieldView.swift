//
//  InputFieldView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

import SwiftUI

struct InputFieldView: View {
	private let width: CGFloat = 350
	private let height: CGFloat = 50

	let isSecure: Bool
	let placeholder: String

	@Binding var text: String
	@Binding var showText: Bool

	var body: some View {
		ZStack(alignment: .trailing) {
			Group {
				if isSecure {
					if showText {
						TextField(placeholder, text: $text)
					} else {
						SecureField(placeholder, text: $text)
					}
				} else {
					TextField(placeholder, text: $text)
				}
			}
			.padding()
			.frame(width: width, height: height)
			.background(Color.gray.opacity(0.2))
			.cornerRadius(12)

			if isSecure {
				Button(action: {
					showText.toggle()
				}) {
					Image(systemName: showText ? "eye.slash" : "eye")
						.foregroundColor(.gray)
						.padding(.trailing, 10)
				}
			}
		}
	}
}

#Preview {
	VStack(spacing: 16) {
		InputFieldView(
			isSecure: false,
			placeholder: "Username",
			text: .constant(""),
			showText: .constant(false)
		)
		.padding(.bottom, 10)

		InputFieldView(
			isSecure: true,
			placeholder: "Password (Hidden)",
			text: .constant(""),
			showText: .constant(false)
		)
		.padding(.bottom, 10)

		InputFieldView(
			isSecure: true,
			placeholder: "Password (Visible)",
			text: .constant(""),
			showText: .constant(true)
		)
	}
	.padding()
}
