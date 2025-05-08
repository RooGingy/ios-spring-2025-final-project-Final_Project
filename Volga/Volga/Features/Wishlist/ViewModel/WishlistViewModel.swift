//
//  WishlistViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//

//
//  WishlistViewModel.swift
//  Volga
//
//  Created by Austin Moser on 5/8/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class WishlistViewModel: ObservableObject {
    @Published var wishlistBooks: [Book] = []

    func loadWishlist() {
        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else {
            print("User ID not available")
            return
        }

        let db = Firestore.firestore()
        let wishlistRef = db.collection("users").document(userID).collection("wishlist")

        wishlistRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error loading wishlist: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            var loadedBooks: [Book] = []
            let group = DispatchGroup()

            for doc in documents {
                guard let isbn = doc["isbn"] as? String else { continue }

                group.enter()
                db.collection("books")
                    .whereField("isbn", isEqualTo: isbn)
                    .getDocuments { bookSnapshot, _ in
                        if let bookDoc = bookSnapshot?.documents.first,
                           let book = try? bookDoc.data(as: Book.self) {
                            loadedBooks.append(book)
                        }
                        group.leave()
                    }
            }

            group.notify(queue: .main) {
                self.wishlistBooks = loadedBooks
            }
        }
    }

    func addBookToWishlist(_ book: Book) {
        let db = Firestore.firestore()
        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else { return }

        let wishlistRef = db.collection("users").document(userID).collection("wishlist")

        wishlistRef.document(book.id ?? UUID().uuidString).setData([
            "isbn": book.isbn
        ]) { error in
            if let error = error {
                print("Error adding book to wishlist: \(error.localizedDescription)")
            }
        }
    }

    func removeBookFromWishlist(_ book: Book) {
        let db = Firestore.firestore()
        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else { return }

        let wishlistRef = db.collection("users").document(userID).collection("wishlist")

        wishlistRef.whereField("isbn", isEqualTo: book.isbn).getDocuments { snapshot, error in
            if let error = error {
                print("Error finding wishlist book to remove: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            for doc in documents {
                doc.reference.delete()
            }

            // ✅ Remove from local state
            DispatchQueue.main.async {
                self.wishlistBooks.removeAll { $0.isbn == book.isbn }
            }
        }
    }
}
