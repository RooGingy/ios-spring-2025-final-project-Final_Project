//
//  Book.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Description Object (matches Firestore's nested map)
struct BookDescription: Codable {
	let paragraph1: String
	let paragraph2: String
	let paragraph3: String
}

// MARK: - Book Model
struct Book: Identifiable, Codable {
	@DocumentID var id: String?

	let title: String
	let author: String
	let genres: String
	let isbn: String
	let description: BookDescription
	let coverImage: String
	let rating: Double
	let price: Double
	let inStock: Bool
	let onHand: Int

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case author
		case genres = "genre" // Firestore key = "genre", model = "genres"
		case isbn
		case description
		case coverImage = "coverImage" // Firestore key = "coverImage"
		case rating
		case price
		case inStock
		case onHand
	}
}
