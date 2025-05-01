//
//  WishlistViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class WishlistViewModel: ObservableObject {
    @Published var wishlistBooks: [Book] = []
    @Published var isLoading: Bool = false

    func loadWishlist() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true

        let db = Firestore.firestore()
        let wishlistRef = db.collection("users").document(userId).collection("wishlist")

        wishlistRef.getDocuments(completion: { snapshot, error in
            self.isLoading = false

            if let error = error {
                print("Error loading wishlist: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.wishlistBooks = documents.compactMap { doc in
                let data = doc.data()

                // Rebuild description from nested map
                let descriptionData = data["description"] as? [String: String] ?? [:]
                let description = BookDescription(
                    paragraph1: descriptionData["paragraph1"] ?? "",
                    paragraph2: descriptionData["paragraph2"] ?? "",
                    paragraph3: descriptionData["paragraph3"] ?? ""
                )

                return Book(
                    id: doc.documentID,
                    title: data["title"] as? String ?? "",
                    author: data["author"] as? String ?? "",
                    genres: data["genre"] as? String ?? "",
                    isbn: data["isbn"] as? String ?? "",
                    description: description,
                    coverImage: data["coverImage"] as? String ?? "",
                    rating: data["rating"] as? Double ?? 0.0,
                    price: data["price"] as? Double ?? 0.0,
                    inStock: data["inStock"] as? Bool ?? false,
                    onHand: data["onHand"] as? Int ?? 0
                )
            }
        })
    }
}
