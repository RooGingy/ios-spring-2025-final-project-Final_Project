//
//  RootView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
	@State private var isLoggedIn = false
	@State private var hasCheckedAuth = false // Prevent flicker

	var body: some View {
		Group {
			if !hasCheckedAuth {
				ProgressView("Checking login...")
			} else if isLoggedIn {
				BookstoreView()
					.onAppear {
						CurrentUserManager.shared.loadUser()
					}
			} else {
				Login()
			}
		}
		.onAppear {
			// Firebase auto-persistence check
			if Auth.auth().currentUser != nil {
				isLoggedIn = true
			}
			hasCheckedAuth = true
		}
	}
}

#Preview {
	RootView()
}
