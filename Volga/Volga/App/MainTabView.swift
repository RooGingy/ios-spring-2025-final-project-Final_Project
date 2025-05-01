//
//  MainTabView.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, cart, wishlist, orders
    }

    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                Bookstore()
            case .cart:
                CartView() // ✅ Use the cart view here
            case .wishlist:
                WishlistView()
            case .orders:
                Text("Orders Placeholder") // Replace with OrdersView later
            }

            Navbar(selectedTab: $selectedTab)
        }
    }
}
