//
//  LoginViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation

class LoginViewModel: ObservableObject {
	@Published var email = ""
	@Published var password = ""
	@Published var showPassword = false
	@Published var errorMessage: String?
	@Published var showErrors = false

	@Published var navigateToCreateAccount = false
	@Published var navigateToBookstore = false

	var emailError: Bool {
		email.trimmingCharacters(in: .whitespaces).isEmpty
	}

	var passwordError: Bool {
		password.isEmpty
	}

	func login() {
		showErrors = true
		errorMessage = nil

		guard !emailError && !passwordError else {
			return
		}

		FirebaseAuthService.shared.login(email: email, password: password) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					self?.navigateToBookstore = true
				case .failure(let error):
					self?.errorMessage = error.localizedDescription
				}
			}
		}
	}
}
