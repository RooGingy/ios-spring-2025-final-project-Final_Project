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
            // Switch between screens based on tab
            switch selectedTab {
            case .home:
                Bookstore()
            case .cart:
                Text("Cart View Placeholder") // Replace with CartView()
            case .wishlist:
                WishlistView() // No need to pass selectedTab here
            case .orders:
                Text("Orders View Placeholder") // Replace with OrdersView()
            }

            // Only MainTabView owns the tab binding
            Navbar(selectedTab: $selectedTab)
        }
    }
}
