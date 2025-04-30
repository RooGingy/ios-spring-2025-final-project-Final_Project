//
//  Bookstore.swift
//  Volga
//
//  Created by Austin Moser on 4/6/25.
//

import SwiftUI

struct Bookstore: View {
	@StateObject private var viewModel = BookstoreViewModel()

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				ScrollView {
					VStack(spacing: 16) {
						Text("Welcome to the Bookstore!")
							.font(.title)
							.padding(.top)

						TextField("Search by title...", text: $viewModel.searchQuery)
							.padding(10)
							.background(Color(.systemGray6))
							.cornerRadius(8)
							.padding(.horizontal)

						if viewModel.isLoading && viewModel.visibleBooks.isEmpty {
							ProgressView("Loading books...").padding()
						}

						LazyVStack(spacing: 16) {
							ForEach(viewModel.visibleBooks) { book in
								NavigationLink(destination: BookDetailsView(book: book)) {
									BookCard(book: book)
								}
								.buttonStyle(.plain)
							}

							if !viewModel.activeAllLoaded {
								ProgressView()
									.onAppear {
										if viewModel.searchQuery.isEmpty {
											viewModel.loadMoreBooks()
										} else {
											viewModel.loadMoreSearchResults()
										}
									}
							}
						}
						.padding()
					}
				}

				Navbar()
			}
			.navigationTitle("Bookstore")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear {
				viewModel.loadInitialBooksIfNeeded()
			}
		}
	}
}
