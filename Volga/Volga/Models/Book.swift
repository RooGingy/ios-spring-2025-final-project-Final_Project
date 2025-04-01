//
//  Book.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation

struct Book: Identifiable {
	let id = UUID()
	let title: String
	let author: String
	let price: Double
	let imageName: String
}
