//
//  LoginView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct LoginView: View {
	@StateObject private var viewModel = LoginViewModel()

	var body: some View {
		VStack(spacing: 20) {
			Spacer()

			InputFieldView(isSecure: false, placeholder: "Email", text: $viewModel.email, showText: .constant(false))
			InputFieldView(isSecure: true, placeholder: "Password", text: $viewModel.password, showText: $viewModel.showPassword)

			Spacer()

			PrimaryButtonView(title: "Login", backgroundColor: .teal, textColor: .black) {
				viewModel.login()
			}

			PrimaryButtonView(title: "Create Account", backgroundColor: .teal, textColor: .black) {
				viewModel.navigateToCreateAccount = true
			}
		}
		.padding()
		.navigationTitle("Login")
		.navigationBarTitleDisplayMode(.inline)

		// 👉 Add this here, ya navigational muppet
		.navigationDestination(isPresented: $viewModel.navigateToCreateAccount) {
			CreateAccountView()
		}
	}
}

#Preview {
	LoginView()
}
