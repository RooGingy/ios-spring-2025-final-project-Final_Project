//
//  Order.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//

import Foundation

struct Order: Identifiable {
    let id: String
    let timestamp: Date
    let total: Double
    let books: [OrderBookItem]

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }

    var formattedTotal: String {
        String(format: "$%.2f", total)
    }
}

struct OrderBookItem: Identifiable {
    let id: String
    let coverURL: String
    let title: String
    let quantity: Int
}
