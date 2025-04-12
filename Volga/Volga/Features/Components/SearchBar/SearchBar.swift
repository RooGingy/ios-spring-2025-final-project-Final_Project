//
//  BookSearchBar.swift
//  Volga
//
//  Created by Austin Moser on 4/11/25.
//

import SwiftUI

struct SearchBar: View {
	@ObservedObject var viewModel: SearchBarViewModel

	var body: some View {
		TextField("Search by title, author, genre, or ISBN", text: $viewModel.query)
			.padding(10)
			.background(Color(.systemGray6))
			.cornerRadius(8)
			.padding(.horizontal)
			.onChange(of: viewModel.query) {
				viewModel.filterBooks()
			}
	}
}


#Preview {
	let mockBooks = [
		Book(
			id: "book1",
			title: "Mastering Swift",
			author: "Jane Developer",
			genres: "Programming",
			isbn: "1111111111",
			description: BookDescription(
				paragraph1: "An in-depth guide to Swift programming.",
				paragraph2: "Covers all major topics from basics to advanced.",
				paragraph3: "Great for iOS developers."
			),
			coverImage: "",
			rating: 4.5,
			price: 29.99,
			inStock: true,
			onHand: 12
		),
		Book(
			id: "book2",
			title: "Firebase in Action",
			author: "John Backend",
			genres: "Cloud",
			isbn: "2222222222",
			description: BookDescription(
				paragraph1: "A practical guide to using Firebase.",
				paragraph2: "Includes Auth, Firestore, and Storage.",
				paragraph3: "Helpful for mobile and web devs."
			),
			coverImage: "",
			rating: 4.8,
			price: 34.99,
			inStock: true,
			onHand: 8
		)
	]

	let viewModel = SearchBarViewModel(books: mockBooks)
	return SearchBar(viewModel: viewModel)
}
