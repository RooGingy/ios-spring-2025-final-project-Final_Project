//
//  CartViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

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

            self.cartItems = documents.compactMap { doc in
                let data = doc.data()

                // If any required field is missing, skip
                guard let title = data["title"] as? String,
                      let author = data["author"] as? String,
                      let coverImage = data["coverImage"] as? String,
                      let price = data["price"] as? Double,
                      let isbn = data["isbn"] as? String,
                      let quantity = data["quantity"] as? Int else {
                    return nil
                }

                let book = Book(
                    id: doc.documentID,
                    title: title,
                    author: author,
                    genres: "", // optional if not stored
                    isbn: isbn,
                    description: BookDescription(paragraph1: "", paragraph2: "", paragraph3: ""),
                    coverImage: coverImage,
                    rating: 0.0,
                    price: price,
                    inStock: true,
                    onHand: 0
                )

                return CartItem(book: book, quantity: quantity)
            }
        }
    }
    
    func removeFromCart(bookId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart").document(bookId)

        cartRef.delete { error in
            if let error = error {
                print("Error removing from cart: \(error.localizedDescription)")
            } else {
                self.loadCart()
            }
        }
    }
}
