//
//  BookDetailViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/22/25.
//


import Foundation
import SwiftUI

class BookDetailViewModel: ObservableObject {
	@Published var quantity: Int = 1
	@Published var isInWishlist: Bool = false

	let book: Book

	init(book: Book) {
		self.book = book
	}

	func toggleWishlist() {
		isInWishlist.toggle()
		// Optional: Update Firestore here
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