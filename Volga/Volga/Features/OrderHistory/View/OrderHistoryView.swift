//
//  OrderHistoryView.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//


import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel = OrderHistoryViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.orders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(order.formattedDate)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Text(order.formattedTotal)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(order.books) { book in
                                            ZStack(alignment: .topTrailing) {
                                                AsyncImage(url: URL(string: book.coverURL)) { phase in
                                                    if let image = phase.image {
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                    } else {
                                                        Color.gray
                                                    }
                                                }
                                                .frame(width: 80, height: 120)
                                                .cornerRadius(8)
                                                .clipped()

                                                if book.quantity > 1 {
                                                    Text("x\(book.quantity)")
                                                        .font(.caption2.bold())
                                                        .foregroundColor(.white)
                                                        .padding(5)
                                                        .background(Color.black.opacity(0.75))
                                                        .clipShape(Circle())
                                                        .offset(x: -5, y: 5)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Order History")
        }
    }
}
