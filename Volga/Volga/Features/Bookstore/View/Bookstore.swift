//
//  Bookstore.swift
//  Volga
//
//  Created by Austin Moser on 4/6/25.
//

import SwiftUI

struct Bookstore: View {
	@StateObject private var catalog = CatalogRepository()
	@StateObject private var searchViewModel = SearchBarViewModel(books: [])

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				ScrollView {
					VStack(spacing: 16) {
						Text("Welcome to the Bookstore!")
							.font(.title)
							.padding(.top)

						if catalog.books.isEmpty {
							ProgressView("Loading books...")
								.padding()
						} else {
							SearchBar(viewModel: searchViewModel)

							LazyVStack(spacing: 16) {
								ForEach(searchViewModel.filteredBooks) { book in
									NavigationLink(destination: BookDetailView(book: book)) {
										BookCard(book: book)
									}
									.buttonStyle(.plain)
								}
							}
							.padding()
						}
					}
				}

				Navbar() // Static at the bottom
			}
			.onAppear {
				catalog.fetchBooks()
			}
			.onChange(of: catalog.books) {
				searchViewModel.updateBooks(catalog.books)
			}
		}
	}
}

#Preview {
	NavigationStack {
		Bookstore()
	}
}
