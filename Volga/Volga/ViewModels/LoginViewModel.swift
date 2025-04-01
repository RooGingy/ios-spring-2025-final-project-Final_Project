//
//  LoginViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation

class LoginViewModel: ObservableObject {
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var showPassword: Bool = false
	@Published var navigateToCreateAccount: Bool = false

	func login() {
		print("Logging in with: \(email), \(password)")
		// Add logic later
	}
}
