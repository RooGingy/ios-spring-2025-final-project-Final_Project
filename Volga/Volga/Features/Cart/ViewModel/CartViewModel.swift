//
//  CartViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class CartViewModel: ObservableObject {
    struct CartItem {
        let book: Book
        let quantity: Int
    }

    @Published var cartItems: [CartItem] = []
    @Published var isLoading: Bool = false

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.book.price * Double($1.quantity)) }
    }

    func loadCart() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true

        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart")

        cartRef.getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error {
                print("Error loading cart: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            var loadedItems: [CartItem] = []
            let group = DispatchGroup()

            for doc in documents {
                let data = doc.data()
                guard let isbn = data["isbn"] as? String,
                      let quantity = data["quantity"] as? Int else {
                    continue
                }

                group.enter()
                db.collection("books")
                    .whereField("isbn", isEqualTo: isbn)
                    .getDocuments { result, _ in
                        if let bookDoc = result?.documents.first,
                           let book = try? bookDoc.data(as: Book.self) {
                            loadedItems.append(CartItem(book: book, quantity: quantity))
                        }
                        group.leave()
                    }
            }

            group.notify(queue: .main) {
                self.cartItems = loadedItems
            }
        }
    }

    func addToCart(book: Book, quantity: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart")

        // Use ISBN as identifier to ensure unique entries
        cartRef.document(book.id ?? UUID().uuidString).setData([
            "isbn": book.isbn,
            "quantity": quantity
        ]) { error in
            if let error = error {
                print("Error adding to cart: \(error.localizedDescription)")
            } else {
                self.loadCart()
            }
        }
    }

    func removeFromCart(bookId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("cart").document(bookId).delete { error in
            if let error = error {
                print("Error removing from cart: \(error.localizedDescription)")
            } else {
                self.loadCart()
            }
        }
    }
}
