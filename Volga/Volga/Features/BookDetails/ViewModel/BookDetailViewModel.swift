//
//  BookDetailsModel.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class BookDetailViewModel: ObservableObject {
    @Published var quantity: Int = 1
    @Published var isInWishlist: Bool = false
    @Published var showSnackbar: Bool = false

    let book: Book

    init(book: Book) {
        self.book = book
    }

    func toggleWishlist() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let wishlistRef = db.collection("users").document(userId).collection("wishlist").document(book.id!)

        isInWishlist.toggle()

        if isInWishlist {
            wishlistRef.setData([
                "title": book.title,
                "author": book.author,
                "coverImage": book.coverImage,
                "price": book.price,
                "isbn": book.isbn
            ]) { error in
                if let error = error {
                    print("Error adding to wishlist: \(error.localizedDescription)")
                    self.isInWishlist = false
                }
            }
        } else {
            wishlistRef.delete { error in
                if let error = error {
                    print("Error removing from wishlist: \(error.localizedDescription)")
                    self.isInWishlist = true
                }
            }
        }
    }

    func checkIfInWishlist() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId).collection("wishlist").document(book.id!)

        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error checking wishlist status: \(error.localizedDescription)")
                return
            }

            self.isInWishlist = snapshot?.exists ?? false
        }
    }

    func addToCart() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart").document(book.id!)

        cartRef.setData([
            "title": book.title,
            "author": book.author,
            "coverImage": book.coverImage,
            "price": book.price,
            "isbn": book.isbn,
            "quantity": quantity
        ]) { error in
            if let error = error {
                print("Error adding to cart: \(error.localizedDescription)")
            } else {
                self.showSnackbar = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.showSnackbar = false
                }
            }
        }
    }

    func incrementQuantity() {
        if quantity < book.onHand {
            quantity += 1
        }
    }

    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
}
