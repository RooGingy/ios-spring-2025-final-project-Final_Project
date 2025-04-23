//
//  AddReviewButton.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI
import Firebase

struct AddReviewButton: View {
	let bookId: String
	let userId: String
	let userName: String

	@State private var showSheet = false
	@State private var reviewText = ""
	@State private var starRating = 3

	var body: some View {
		Button("Write a Review") {
			showSheet = true
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(Color("SoftTealBlue"))
		.foregroundColor(.white)
		.cornerRadius(12)
		.sheet(isPresented: $showSheet) {
			NavigationStack {
				VStack(spacing: 20) {
					Text("Your Rating")
						.font(.headline)

					// ⭐️ Rating Bar
					HStack {
						ForEach(1...5, id: \.self) { star in
							Image(systemName: star <= starRating ? "star.fill" : "star")
								.resizable()
								.frame(width: 28, height: 28)
								.foregroundColor(.yellow)
								.onTapGesture {
									starRating = star
								}
						}
					}

					// 📝 Review Field
					TextEditor(text: $reviewText)
						frame(height: 120)
						overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
						.padding(.horizontal)

					Button("Submit Review") {
						addReview()
						showSheet = false
					}
					.buttonStyle(.borderedProminent)
					.disabled(reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
				}
				.padding()
				.navigationTitle("Leave a Review")
				.navigationBarTitleDisplayMode(.inline)
			}
		}
	}

	func addReview() {
		let db = Firestore.firestore()
		let reviewData: [String: Any] = [
			"userId": userId,
			"userName": userName,
			"rating": starRating,
			"comment": reviewText,
			"timestamp": Timestamp()
		]

		let bookRef = db.collection("books").document(bookId)
		let reviewsRef = bookRef.collection("reviews")

		// Add review
		reviewsRef.addDocument(data: reviewData) { error in
			if let error = error {
				print("⚠️ Failed to add review: \(error.localizedDescription)")
				return
			}

			// Update book average rating
			reviewsRef.getDocuments { snapshot, error in
				if let docs = snapshot?.documents {
					let allRatings = docs.compactMap { $0.data()["rating"] as? Int }
					let avg = Double(allRatings.reduce(0, +)) / Double(allRatings.count)
					bookRef.updateData(["rating": avg])
				}
			}
		}
	}
}
