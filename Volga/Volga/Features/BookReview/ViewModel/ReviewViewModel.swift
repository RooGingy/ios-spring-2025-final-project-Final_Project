//
//  ReviewViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/22/25.
//


import Foundation
import Firebase
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
	@Published var reviews: [Review] = []
	@Published var reviewText = ""
	@Published var starRating = 3

	private let db = Firestore.firestore()
	private var bookId: String

	init(bookId: String) {
		self.bookId = bookId
	}

	func loadReviews() {
		let ref = db.collection("books").document(bookId).collection("reviews")
		ref.order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
			if let docs = snapshot?.documents {
				self.reviews = docs.compactMap { try? $0.data(as: Review.self) }
			}
		}
	}

	func submitReview(for user: CurrentUserManager, onComplete: @escaping () -> Void) {
		let bookRef = db.collection("books").document(bookId)
		let reviewsRef = bookRef.collection("reviews")

		let trimmed = reviewText.trimmingCharacters(in: .whitespacesAndNewlines)

		let reviewData: [String: Any] = [
			"userId": user.userId,
			"name": user.name,
			"rating": starRating,
			"comment": trimmed,
			"timestamp": Timestamp()
		]

		reviewsRef.addDocument(data: reviewData) { error in
			guard error == nil else { return }

			reviewsRef.getDocuments { snapshot, _ in
				if let docs = snapshot?.documents {
					let ratings = docs.compactMap { $0.data()["rating"] as? Int }
					let avg = Double(ratings.reduce(0, +)) / Double(ratings.count)
					bookRef.updateData(["rating": avg])
				}
			}
			onComplete()
		}
	}
}