//
//  OrderDetailView.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//


import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Order Details")
                    .font(.title2.bold())

                HStack {
                    Text("Date:")
                        .bold()
                    Text(order.formattedDate)
                }

                HStack {
                    Text("Total:")
                        .bold()
                    Text(order.formattedTotal)
                }

                Divider()

                Text("Items:")
                    .font(.headline)

                ForEach(order.books) { book in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: book.coverURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color.gray
                            }
                        }
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)
                            Text("Quantity: \(book.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Order #\(order.id.prefix(6))")
        .navigationBarTitleDisplayMode(.inline)
    }
}
