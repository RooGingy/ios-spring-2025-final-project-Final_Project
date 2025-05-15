//
//  CartViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//

import Foundation
import FirebaseFirestore

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var totalPrice: Double = 0.0
    @Published var isLoading = false

    func loadCart() {
        isLoading = true
        cartItems.removeAll()

        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else {
            print("User ID is missing.")
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userID).collection("cart")

        cartRef.getDocuments { snapshot, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                print("Failed to fetch cart items: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            var items: [CartItem] = []

            for doc in documents {
                let data = doc.data()

                guard let title = data["title"] as? String,
                      let author = data["author"] as? String,
                      let coverImage = data["coverImage"] as? String,
                      let isbn = data["isbn"] as? String,
                      let price = data["price"] as? Double,
                      let quantity = data["quantity"] as? Int else {
                    continue
                }

                let book = Book(
                    id: doc.documentID,
                    title: title,
                    author: author,
                    genres: "Unknown",
                    isbn: isbn,
                    description: BookDescription(paragraph1: "", paragraph2: "", paragraph3: ""),
                    coverImage: coverImage,
                    rating: 0.0,
                    price: price,
                    inStock: true,
                    onHand: 0
                )

                items.append(CartItem(book: book, quantity: quantity))
            }

            DispatchQueue.main.async {
                self.cartItems = items
                self.recalculateTotal()
            }
        }
    }

    func removeFromCart(bookId: String) {
        cartItems.removeAll { $0.book.id == bookId }
        recalculateTotal()

        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("cart").document(bookId).delete()
    }

    func clearCart() {
        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else { return }

        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userID).collection("cart")

        for item in cartItems {
            if let bookId = item.book.id {
                cartRef.document(bookId).delete()
            }
        }

        cartItems.removeAll()
        totalPrice = 0.0
        print("🧹 Cart cleared")
    }

    func recalculateTotal() {
        totalPrice = cartItems.reduce(0) { $0 + ($1.book.price * Double($1.quantity)) }
    }

    func checkout(name: String, address: String) {
        print("🛒 Starting checkout with name: '\(name)', address: '\(address)'")

        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else {
            print("❌ No user ID")
            return
        }

        guard !cartItems.isEmpty else {
            print("⚠️ No cart items to checkout")
            return
        }

        let db = Firestore.firestore()
        let orderRef = db.collection("users").document(userID).collection("orders").document()

        let orderData: [String: Any] = [
            "name": name,
            "address": address,
            "total": totalPrice,
            "timestamp": Timestamp(date: Date())
        ]

        orderRef.setData(orderData) { error in
            if let error = error {
                print("❌ Failed to create order: \(error.localizedDescription)")
                return
            }

            print("✅ Order created: users/\(userID)/orders/\(orderRef.documentID)")

            var completed = 0
            let total = self.cartItems.count

            for item in self.cartItems {
                let book = item.book

                guard let bookId = book.id else {
                    print("⚠️ Skipping book with nil ID: \(book.title)")
                    continue
                }

                print("📦 Writing item: \(book.title), qty: \(item.quantity)")

                let itemData: [String: Any] = [
                    "bookId": bookId,
                    "title": book.title,
                    "author": book.author,
                    "genres": book.genres,
                    "isbn": book.isbn,
                    "description": [
                        "paragraph1": book.description.paragraph1,
                        "paragraph2": book.description.paragraph2,
                        "paragraph3": book.description.paragraph3
                    ],
                    "coverImage": book.coverImage,
                    "rating": book.rating,
                    "price": book.price,
                    "inStock": book.inStock,
                    "onHand": book.onHand,
                    "quantity": item.quantity
                ]

                orderRef.collection("items").addDocument(data: itemData) { itemError in
                    if let itemError = itemError {
                        print("❌ Failed to add item \(book.title): \(itemError.localizedDescription)")
                    } else {
                        print("✅ Item added: \(book.title)")
                    }

                    completed += 1
                    if completed == total {
                        DispatchQueue.main.async {
                            self.clearCart()
                        }
                    }
                }
            }
        }
    }
}
