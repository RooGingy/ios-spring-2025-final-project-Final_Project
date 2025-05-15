//
//  Login.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
	@StateObject private var viewModel = LoginViewModel()

	var body: some View {
		NavigationStack {
			VStack {
				Spacer(minLength: 40)

				ScrollView(showsIndicators: false) {
					VStack(spacing: 24) {
						Text("Welcome Back")
							.font(.largeTitle.bold())
							.padding(.bottom, 10)

						InputField(
							isSecure: false,
							placeholder: "Email",
							text: $viewModel.email,
							showText: .constant(false),
							showError: viewModel.showErrors && viewModel.emailError
						)

						InputField(
							isSecure: true,
							placeholder: "Password",
							text: $viewModel.password,
							showText: $viewModel.showPassword,
							showError: viewModel.showErrors && viewModel.passwordError
						)

						if let error = viewModel.errorMessage {
							Text(error)
								.foregroundColor(.red)
								.font(.caption)
								.multilineTextAlignment(.center)
								.padding(.horizontal)
						}

						CustomButton(
							title: "Login",
							icon: nil,
							bgColor: .teal,
							fgColor: .black
						) {
							withAnimation {
								viewModel.login()
								CurrentUserManager.shared.loadUser()
							}
						}

						CustomButton(
							title: "Create Account",
							icon: nil,
							bgColor: .teal,
							fgColor: .black
						) {
							viewModel.navigateToCreateAccount = true
						}
					}
					.padding()
				}
			}
			.padding()
			.navigationTitle("Login")
			.navigationBarTitleDisplayMode(.inline)
			.navigationDestination(isPresented: $viewModel.navigateToCreateAccount) {
				CreateAccount()
			}
		}
		.fullScreenCover(isPresented: $viewModel.navigateToBookstore) {
            Bookstore()
		}
	}
}

#Preview {
	Login()
}
