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
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = false

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

                        // Styled Login Button
                        CustomButton(
                            title: "Login",
                            icon: "person.fill.checkmark",
                            bgColor: Color("SoftTealBlue"),
                            fgColor: .white
                        ) {
                            withAnimation {
                                viewModel.login {
                                    isUserLoggedIn = true
                                }
                            }
                        }

                        // Optional: create account
                        CustomButton(
                            title: "Create Account",
                            icon: "person.badge.plus",
                            bgColor: Color("SoftTealBlue"),
                            fgColor: .white
                        ) {
                            viewModel.navigateToCreateAccount = true
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.navigateToCreateAccount) {
                CreateAccount()
            }
        }
    }
}
