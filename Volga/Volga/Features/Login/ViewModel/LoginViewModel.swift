//
//  LoginViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation
import FirebaseAuth

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

		Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
			DispatchQueue.main.async {
				if let error = error {
					self?.errorMessage = error.localizedDescription
				} else {
					self?.navigateToBookstore = true
				}
			}
		}
	}
}
