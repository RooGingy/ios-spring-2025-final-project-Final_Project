//
//  CreateAccountViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewModel: ObservableObject {
	@Published var firstName = ""
	@Published var lastName = ""
	@Published var email = ""
	@Published var password = ""
	@Published var confirmPassword = ""
	@Published var showPassword = false
	@Published var showConfirmPassword = false
	@Published var showErrors = false
	@Published var errorMessage: String?

	func createAccount(onSuccess: @escaping () -> Void) {
		showErrors = true
		errorMessage = nil

		guard validateFields() else { return }

		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
			DispatchQueue.main.async {
				if let error = error {
					self?.errorMessage = error.localizedDescription
				} else if let uid = authResult?.user.uid {
					// Save user data to Firestore
					let db = Firestore.firestore()
					let userData: [String: Any] = [
						"userId": uid,
						"name": "\(self?.firstName ?? "") \(self?.lastName ?? "")",
						"email": self?.email ?? ""
					]
					db.collection("users").document(uid).setData(userData) { err in
						if let err = err {
							self?.errorMessage = "Failed to save user: \(err.localizedDescription)"
						} else {
							onSuccess()
						}
					}
				}
			}
		}
	}

	private func validateFields() -> Bool {
		if firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
			lastName.trimmingCharacters(in: .whitespaces).isEmpty ||
			email.trimmingCharacters(in: .whitespaces).isEmpty ||
			password.isEmpty || confirmPassword.isEmpty {
			errorMessage = "All fields are required."
			return false
		}

		guard password == confirmPassword else {
			errorMessage = "Passwords do not match."
			return false
		}

		return true
	}
}
