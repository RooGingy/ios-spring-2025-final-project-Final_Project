//
//  CatalogRepository.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CatalogRepository: ObservableObject {
	@Published var books: [Book] = []
	private var db = Firestore.firestore()

	func fetchBooks() {
		db.collection("books").getDocuments { snapshot, error in
			if let error = error {
				print("Error fetching books: \(error.localizedDescription)")
				return
			}

			guard let documents = snapshot?.documents else {
				print("No books found.")
				return
			}

			self.books = documents.compactMap { doc in
				let book = try? doc.data(as: Book.self)
				print("📘 Book loaded: \(book?.title ?? "nil")")
				return book
			}
		}
	}
}
