//
//  WishlistView.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//`

import SwiftUI
import FirebaseFirestore

struct WishlistView: View {
    @StateObject private var viewModel = WishlistViewModel()
    @State private var selectedBook: Book? = nil
    @State private var showDetails = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Your Wishlist")
                            .font(.title)
                            .padding(.top)

                        if viewModel.wishlistBooks.isEmpty {
                            Text("No books in your wishlist yet.")
                                .foregroundColor(.secondary)
                                .padding()
                        }

                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.wishlistBooks, id: \.id) { book in
                                ZStack(alignment: .topTrailing) {
                                    // Whole card is tappable
                                    BookCard(book: book)
                                        .onTapGesture {
                                            selectedBook = book
                                            showDetails = true
                                        }

                                    // Trash icon
                                    Button(action: {
                                        viewModel.removeBookFromWishlist(book)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 1)
                                    }
                                    .padding(10)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadWishlist()
            }
            .navigationDestination(isPresented: $showDetails) {
                if let book = selectedBook {
                    BookDetailsView(book: book)
                }
            }
        }
    }
}
