//
//  BookSearchViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/11/25.
//

import Foundation
import Combine

class SearchBarViewModel: ObservableObject {
	@Published var query: String = ""
	@Published private(set) var allBooks: [Book] = []
	@Published var filteredBooks: [Book] = []

	init(books: [Book]) {
		updateBooks(books)
	}

	func updateBooks(_ books: [Book]) {
		self.allBooks = books
		self.filterBooks()
	}

	func filterBooks() {
		if query.trimmingCharacters(in: .whitespaces).isEmpty {
			filteredBooks = allBooks
		} else {
			let q = query.lowercased()
			filteredBooks = allBooks.filter {
				$0.title.lowercased().contains(q) ||
				$0.author.lowercased().contains(q) ||
				$0.genres.lowercased().contains(q) ||
				$0.isbn.contains(q)
			}
		}
	}
}
