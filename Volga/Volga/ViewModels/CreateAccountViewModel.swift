//
//  CreateAccountViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation

class CreateAccountViewModel: ObservableObject {
	@Published var firstName: String = ""
	@Published var lastName: String = ""
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var confirmPassword: String = ""
	@Published var showPassword: Bool = false
	@Published var showConfirmPassword: Bool = false

	func createAccount() {
		print("Creating account with: \(firstName) \(lastName), \(email)")
		// Add actual API calls later
	}
}
