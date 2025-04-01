//
//  CreateAccountView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct CreateAccountView: View {
	@StateObject private var viewModel = CreateAccountViewModel()
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 20) {
			Text("Volga")
				.font(.largeTitle)
				.fontWeight(.bold)

			InputFieldView(isSecure: false, placeholder: "First Name", text: $viewModel.firstName, showText: .constant(false))
			InputFieldView(isSecure: false, placeholder: "Last Name", text: $viewModel.lastName, showText: .constant(false))
			InputFieldView(isSecure: false, placeholder: "Email", text: $viewModel.email, showText: .constant(false))
			InputFieldView(isSecure: true, placeholder: "Password", text: $viewModel.password, showText: $viewModel.showPassword)
			InputFieldView(isSecure: true, placeholder: "Confirm Password", text: $viewModel.confirmPassword, showText: $viewModel.showConfirmPassword)

			PrimaryButtonView(title: "Create Account", backgroundColor: .teal, textColor: .black) {
				viewModel.createAccount()
			}

			PrimaryButtonView(title: "Back", backgroundColor: .teal, textColor: .black) {
				dismiss()
			}
		}
		.padding(20)
		.navigationTitle("Create Account")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	CreateAccountView()
}
