//
//  RootView.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI

struct RootView: View {
	@State private var isLoggedIn = false // Track login state
	
	var body: some View {
		NavigationStack {
			if isLoggedIn {
				Bookstore()
			} else {
				Login()
			}
		}
	}
}

#Preview {
	RootView()
}
