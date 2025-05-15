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

    private init() {
        setupAuthListener()
    }

    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                print("✅ User signed in: \(user.uid)")
                self.userId = user.uid
                self.loadUserData(uid: user.uid)
            } else {
                print("❌ User signed out")
                self.userId = ""
                self.name = ""
                self.email = ""
            }
        }
    }

    private func loadUserData(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("🔥 Failed to load user data: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("⚠️ No user document found for UID: \(uid)")
                return
            }

            self.name = data["name"] as? String ?? "User"
            self.email = data["email"] as? String ?? ""
            print("👤 Loaded user data: \(self.name), \(self.email)")
        }
    }
}
