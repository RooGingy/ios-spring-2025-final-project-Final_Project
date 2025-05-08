//
//  AddReviewSheet.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct AddReviewSheet: View {
	let bookId: String
	let onSubmit: () -> Void

	@Environment(\.dismiss) var dismiss
	@StateObject private var viewModel = CurrentUserManager.shared
	@StateObject private var reviewVM: ReviewViewModel

	init(bookId: String, onSubmit: @escaping () -> Void) {
       	self.bookId = bookId
		self.onSubmit = onSubmit
		_reviewVM = StateObject(wrappedValue: ReviewViewModel(bookId: bookId))
	}

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(spacing: 24) {
					Text("Rate this Book")
						.font(.title2)
						.fontWeight(.semibold)

					HStack(spacing: 10) {
						ForEach(1...5, id: \.self) { star in
							Image(systemName: star <= reviewVM.starRating ? "star.fill" : "star")
								.resizable()
								.frame(width: 32, height: 32)
								.foregroundColor(.yellow)
								.onTapGesture { reviewVM.starRating = star }
						}
					}

					TextEditor(text: $reviewVM.reviewText)
						.padding()
						.frame(height: 140)
						.background(Color(.secondarySystemBackground))
						.cornerRadius(10)
						.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))

					// ✅ FIXED: Full-area tappable Submit button
					Button(action: {
						reviewVM.submitReview(for: viewModel) {
							onSubmit()
							dismiss()
						}
					}) {
						Text("Submit Review")
							.font(.headline)
							.frame(maxWidth: .infinity)
							.padding()
							.background(Color("SoftGreen"))
							.foregroundColor(.white)
							.cornerRadius(12)
					}
					.disabled(reviewVM.reviewText.trimmingCharacters(in: .whitespaces).isEmpty)
				}
				.padding()
			}
			.navigationTitle("Leave a Review")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}
