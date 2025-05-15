//
//  CheckoutViewModel.swift
//  Volga
//
//  Created by Austin Moser on 5/8/25.
//


import Foundation
import SwiftUI
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var fullAddress: String = ""
    @Published var isFormIncomplete: Bool = true
    @Published var shouldDismiss: Bool = false

    private var cartViewModel: CartViewModel
    private var cancellables = Set<AnyCancellable>()

    init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        setupValidation()
    }

    private func setupValidation() {
        $fullName.combineLatest($fullAddress)
            .map { $0.0.isEmpty || $0.1.isEmpty }
            .assign(to: \ .isFormIncomplete, on: self)
            .store(in: &cancellables)
    }

    func placeOrder() {
        print("📨 Calling placeOrder with name: \(fullName), address: \(fullAddress)")
        cartViewModel.checkout(name: fullName, address: fullAddress)
        shouldDismiss = true
    }

    var totalPrice: Double {
        cartViewModel.totalPrice
    }
}
