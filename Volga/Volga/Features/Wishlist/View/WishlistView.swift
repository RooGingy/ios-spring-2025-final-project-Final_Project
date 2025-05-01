//
//  WishlistView.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//


import SwiftUI

struct WishlistView: View {
    @StateObject private var viewModel = WishlistViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Your Wishlist")
                            .font(.title)
                            .padding(.top)

                        if viewModel.isLoading {
                            ProgressView("Loading wishlist...").padding()
                        } else if viewModel.wishlistBooks.isEmpty {
                            Text("You have no books in your wishlist.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.wishlistBooks) { book in
                                    NavigationLink(destination: BookDetailsView(book: book)) {
                                        BookCard(book: book)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadWishlist()
            }
        }
    }
}
