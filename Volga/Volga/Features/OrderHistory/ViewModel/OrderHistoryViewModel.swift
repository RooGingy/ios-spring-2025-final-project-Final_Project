//
//  OrderHistoryViewModel.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//


import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class OrderHistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []

    init() {
        loadOrders()
    }

    func loadOrders() {
        let userID = CurrentUserManager.shared.userId
        guard !userID.isEmpty else {
            print("User not signed in")
            return
        }

        let db = Firestore.firestore()
        let ordersRef = db.collection("users").document(userID).collection("orders")

        ordersRef.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.orders.removeAll()
            let group = DispatchGroup()

            for doc in documents {
                let orderID = doc.documentID
                let timestamp = (doc["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                let total = doc["total"] as? Double ?? 0.0

                let itemsRef = ordersRef.document(orderID).collection("items")

                group.enter()
                itemsRef.getDocuments { itemSnapshot, itemError in
                    defer { group.leave() }

                    guard let itemDocs = itemSnapshot?.documents, itemError == nil else {
                        print("Error loading items for order \(orderID): \(itemError?.localizedDescription ?? "")")
                        return
                    }

                    let books: [OrderBookItem] = itemDocs.compactMap { itemDoc in
                        let data = itemDoc.data()
                        return OrderBookItem(
                            id: itemDoc.documentID,
                            coverURL: data["coverImage"] as? String ?? "",
                            quantity: data["quantity"] as? Int ?? 1
                        )
                    }

                    let order = Order(id: orderID, timestamp: timestamp, total: total, books: books)
                    DispatchQueue.main.async {
                        self.orders.append(order)
                        self.orders.sort { $0.timestamp > $1.timestamp }
                    }
                }
            }

            group.notify(queue: .main) {
                print("All orders loaded")
            }
        }
    }
}
