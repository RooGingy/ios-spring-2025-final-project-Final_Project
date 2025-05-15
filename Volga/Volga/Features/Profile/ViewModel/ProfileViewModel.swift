//
//  ProfileViewModel.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = true

    init() {
        fetchUserInfo()
    }

    func fetchUserInfo() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(currentUserId).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: User.self)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserLoggedIn = false
        } catch {
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
}
