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
        case home, cart, wishlist, orders, profile
    }

    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .home:
                Bookstore()
            case .cart:
                CartView()
            case .wishlist:
                WishlistView()
            case .orders:
                OrderHistoryView()
            case .profile:
                ProfileView()
            }

            Navbar(selectedTab: $selectedTab)
        }
    }
}
