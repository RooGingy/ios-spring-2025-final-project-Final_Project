//
//  CartItem.swift
//  Volga
//
//  Created by Austin Moser on 5/8/25.
//


import Foundation

struct CartItem: Identifiable {
    var id: String { book.id ?? UUID().uuidString }
    let book: Book
    var quantity: Int
}