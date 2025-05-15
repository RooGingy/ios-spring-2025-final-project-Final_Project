//
//  CartView.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @State private var selectedBook: Book?
    @State private var showBookDetails = false
    @State private var comingFromCart = false
    @State private var checkoutActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Your Cart")
                            .font(.title)
                            .padding(.top)

                        if viewModel.isLoading {
                            ProgressView("Loading cart...").padding()
                        } else if viewModel.cartItems.isEmpty {
                            Text("Your cart is empty.")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.cartItems, id: \.book.id) { item in
                                    CartBookCard(
                                        book: item.book,
                                        quantity: item.quantity,
                                        onEdit: {
                                            selectedBook = item.book
                                            comingFromCart = true
                                            showBookDetails = true
                                        },
                                        onRemove: {
                                            viewModel.removeFromCart(bookId: item.book.id!)
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.bottom)
                }

                if !viewModel.cartItems.isEmpty {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total:")
                                .font(.headline)
                            Spacer()
                            Text(String(format: "$%.2f", viewModel.totalPrice))
                                .font(.headline)
                                .fontWeight(.bold)
                        }

                        Button("Proceed to Checkout") {
                            checkoutActive = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadCart()
            }
            .navigationDestination(isPresented: $showBookDetails) {
                if let book = selectedBook {
                    BookDetailsView(book: book, fromCart: comingFromCart)
                }
            }
            .navigationDestination(isPresented: $checkoutActive) {
                CheckoutView(cartViewModel: viewModel)
            }
        }
    }
}
