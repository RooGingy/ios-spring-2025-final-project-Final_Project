//
//  SeeReviewsButton.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct SeeReviewsButton: View {
	let book: Book

	var body: some View {
		NavigationLink {
			BookReviewsView(book: book)
		} label: {
			Label("See Reviews", systemImage: "text.book.closed")
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color("SoftTealBlue"))
				.foregroundColor(.white)
				.cornerRadius(12)
		}
	}
}
