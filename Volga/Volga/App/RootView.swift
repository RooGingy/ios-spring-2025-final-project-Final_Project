//
//  RootView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//


import SwiftUI

struct RootView: View {
    @AppStorage("isUserLoggedIn") var isUserLoggedIn = true

    var body: some View {
        if isUserLoggedIn {
            MainTabView()
        } else {
            Login()
        }
    }
}
