//
//  CurrentUserManager.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class CurrentUserManager: ObservableObject {
	static let shared = CurrentUserManager()

	@Published var userId: String = ""
	@Published var name: String = ""
	@Published var email: String = ""

	private init() {}

	func loadUser() {
		guard let uid = Auth.auth().currentUser?.uid else {
			return
		}

		self.userId = uid
		let db = Firestore.firestore()
		db.collection("users").document(uid).getDocument { snapshot, error in
			if error != nil {
				return
			}

			guard let data = snapshot?.data() else {
				return
			}

			self.name = data["name"] as? String ?? "User"
			self.email = data["email"] as? String ?? ""
		}
	}
}
