//
//  Bookstore.swift
//  Volga
//
//  Created by Austin Moser on 4/6/25.
//

import SwiftUI

struct Bookstore: View {
	@StateObject private var catalog = CatalogRepository()

	var body: some View {
		VStack {
			// Bookstore Content
			Text("Welcome to the Bookstore!")
				.font(.title)
				.padding()

			if catalog.books.isEmpty {
				// Show a loading indicator while fetching books
				ProgressView("Loading books...")
					.padding()
			} else {
				// Display the list of books when they are loaded
				ScrollView {
					LazyVStack(spacing: 16) {
						ForEach(catalog.books) { book in
							BookCard(book: book) // Use the BookCard to display each book
						}
					}
					.padding(.horizontal)
					.padding(.top)
				}
			}

			// Navbar (if any additional navigation bar needed)
			Navbar()
		}
		.onAppear {
			catalog.fetchBooks() // Fetch books when the view appears
		}
	}
}

#Preview {
	Bookstore()
}
