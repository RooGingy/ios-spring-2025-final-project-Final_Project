//
//  LoginViewModel.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var errorMessage: String?
    @Published var showErrors = false

    @Published var navigateToCreateAccount = false

    var emailError: Bool {
        email.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var passwordError: Bool {
        password.isEmpty
    }

    func login(success: @escaping () -> Void) {
        showErrors = true
        errorMessage = nil

        guard !emailError && !passwordError else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let uid = authResult?.user.uid {
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(uid)

                    userRef.getDocument { docSnapshot, _ in
                        if !(docSnapshot?.exists ?? false) {
                            userRef.setData([
                                "userId": uid,
                                "email": self?.email ?? "",
                                "name": "New User"
                            ]) { error in
                                if let error = error {
                                    print("❌ Failed to create Firestore user doc: \(error.localizedDescription)")
                                } else {
                                    print("✅ Firestore user document created.")
                                }
                            }
                        }
                        success() // 👈 Login successful, trigger RootView transition
                    }
                }
            }
        }
    }
}
