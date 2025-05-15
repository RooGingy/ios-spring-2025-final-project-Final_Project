//
//  Login.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI
import FirebaseAuth

struct CreateAccount: View {
	@StateObject private var viewModel = CreateAccountViewModel()
	@Environment(\.dismiss) private var dismiss
	@State private var navigateToBookstore = false

	var body: some View {
		NavigationStack {
			VStack {
				Spacer(minLength: 40)

				ScrollView(showsIndicators: false) {
					VStack(spacing: 24) {
						Text("Create Your Account")
							.font(.title.bold())
							.padding(.bottom, 10)

						InputField(
							isSecure: false,
							placeholder: "First Name",
							text: $viewModel.firstName,
							showText: .constant(false),
							showError: viewModel.showErrors
						)

						InputField(
							isSecure: false,
							placeholder: "Last Name",
							text: $viewModel.lastName,
							showText: .constant(false),
							showError: viewModel.showErrors
						)

						InputField(
							isSecure: false,
							placeholder: "Email",
							text: $viewModel.email,
							showText: .constant(false),
							showError: viewModel.showErrors
						)

						InputField(
							isSecure: true,
							placeholder: "Password",
							text: $viewModel.password,
							showText: $viewModel.showPassword,
							showError: viewModel.showErrors
						)

						InputField(
							isSecure: true,
							placeholder: "Confirm Password",
							text: $viewModel.confirmPassword,
							showText: $viewModel.showConfirmPassword,
							showError: viewModel.showErrors
						)

						if let error = viewModel.errorMessage {
							Text(error)
								.foregroundColor(.red)
								.font(.caption)
								.multilineTextAlignment(.center)
								.padding(.horizontal)
						}

						CustomButton(
							title: "Create Account",
							icon: nil,
							bgColor: .teal,
							fgColor: .black
						) {
							withAnimation {
								viewModel.createAccount {
									CurrentUserManager.shared.loadUser()
									navigateToBookstore = true
								}
							}
						}
						.padding(.top, 10)
					}
					.padding()
				}
			}
			.padding()
			.navigationTitle("Create Account")
			.navigationBarTitleDisplayMode(.inline)
		}
		.fullScreenCover(isPresented: $navigateToBookstore) {
            Bookstore()
		}
	}
}

#Preview {
	CreateAccount()
}
