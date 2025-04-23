//
//  Review.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
	@DocumentID var id: String?
	let userId: String
	let name: String
	let rating: Int
	let comment: String
	let timestamp: Date
}
