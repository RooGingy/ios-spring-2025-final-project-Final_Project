//
//  CheckoutView.swift
//  Volga
//
//  Created by Austin Moser on 5/8/25.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss

    init(cartViewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(cartViewModel: cartViewModel))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Shipping Information")
                    .font(.title2.bold())

                VStack(spacing: 16) {
                    TextField("Full Name", text: $viewModel.fullName)
                        .textContentType(.name)
                        .textFieldStyle(.roundedBorder)

                    TextField("Shipping Address", text: $viewModel.fullAddress)
                        .textContentType(.fullStreetAddress)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(spacing: 8) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", viewModel.totalPrice))
                            .font(.headline.bold())
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    viewModel.placeOrder()
                }) {
                    Text("Place Order")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormIncomplete ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(viewModel.isFormIncomplete)
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
