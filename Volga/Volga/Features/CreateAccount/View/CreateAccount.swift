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
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false

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
                            icon: "person.badge.plus",
                            bgColor: Color("SoftTealBlue"),
                            fgColor: .white
                        ) {
                            withAnimation {
                                viewModel.createAccount {
                                    // ✅ DO NOT manually load the user
                                    // It’s handled automatically now
                                    isUserLoggedIn = true
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreateAccount()
}
