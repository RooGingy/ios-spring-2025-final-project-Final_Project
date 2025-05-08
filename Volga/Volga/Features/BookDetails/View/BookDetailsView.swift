//
//  BookDetailsView.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

//
//  BookDetailsView.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

import SwiftUI

struct BookDetailsView: View {
    @StateObject private var viewModel: BookDetailViewModel
    @StateObject private var currentUser = CurrentUserManager.shared
    @State private var showReviews = false
    @State private var showCart = false

    var fromCart: Bool = false  // ✅ NEW

    init(book: Book, fromCart: Bool = false) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
        self.fromCart = fromCart
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {

                        AsyncImage(url: URL(string: viewModel.book.coverImage)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView().frame(width: 180, height: 260)
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 260)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            case .failure:
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 260)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }

                        VStack(spacing: 8) {
                            Text(viewModel.book.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            Text("by \(viewModel.book.author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(viewModel.book.genres)
                                .font(.callout)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            BookStatView(label: "Price", value: "$\(String(format: "%.2f", viewModel.book.price))")
                            BookStatView(label: "ISBN", value: viewModel.book.isbn)
                            BookStatView(label: "Rating", value: String(format: "%.1f", viewModel.book.rating))
                            BookStatView(label: "In Stock", value: "\(viewModel.book.onHand)")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        VStack(spacing: 12) {
                            WishlistButton(isInWishlist: $viewModel.isInWishlist) {
                                viewModel.toggleWishlist()
                            }

                            AddToCartButton(available: viewModel.book.onHand, quantity: $viewModel.quantity) {
                                viewModel.addToCart()
                            }

                            CartButton {
                                showCart = true
                            }

                            SeeReviewsButton {
                                showReviews = true
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.book.description.paragraph1)
                            Text(viewModel.book.description.paragraph2)
                            Text(viewModel.book.description.paragraph3)
                        }
                        .font(.body)
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }

            if viewModel.showSnackbar {
                VStack {
                    Spacer()
                    SnackbarView(message: viewModel.quantity == 0 ? "Removed from cart" : "Added to cart")
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.showSnackbar)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentUser.loadUser()
            viewModel.checkIfInWishlist()
            viewModel.quantity = 0
            viewModel.loadQuantityFromCart()
        }
        .navigationDestination(isPresented: $showReviews) {
            BookReviewsView(book: viewModel.book)
        }
        .navigationDestination(isPresented: $showCart) {
            CartView()
        }
    }
}
