//
//  InputField.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct InputField: View {
	private let width: CGFloat = 350
	private let height: CGFloat = 50

	let isSecure: Bool
	let placeholder: String
	@Binding var text: String
	@Binding var showText: Bool
	var showError: Bool = false  // Show error message if the field is empty

	var body: some View {
		VStack(spacing: 4) {
			ZStack(alignment: .trailing) {
				Group {
					if isSecure {
						if showText {
							TextField(placeholder, text: $text)
								.autocapitalization(.none)
								.disableAutocorrection(true)
						} else {
							SecureField(placeholder, text: $text)
								.autocapitalization(.none)
								.disableAutocorrection(true)
						}
					} else {
						TextField(placeholder, text: $text)
							.autocapitalization(.none)
							.disableAutocorrection(true)
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

			// Error Message Display if field is empty and showError is true
			if showError && text.isEmpty {
				HStack {
					Spacer()
					Text("Required")
						.foregroundColor(.red)
						.font(.caption)
						.padding(.trailing, 4)
				}
				.frame(width: width)
			}
		}
	}
}

#Preview {
	VStack(spacing: 16) {
		InputField(
			isSecure: false,
			placeholder: "Email",
			text: .constant(""),
			showText: .constant(false),
			showError: true
		)

		InputField(
			isSecure: true,
			placeholder: "Password",
			text: .constant(""),
			showText: .constant(false),
			showError: true
		)
	}
	.padding()
}
