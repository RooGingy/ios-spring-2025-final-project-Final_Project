//
//  BookstoreViewModel.swift
//  Volga
//
//  Created by Austin Moser on 4/22/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BookstoreViewModel: ObservableObject {
	@Published var books: [Book] = []
	@Published var searchResults: [Book] = []
	@Published var searchQuery: String = "" {
		didSet { resetSearch() }
	}

	@Published var isLoading = false
	@Published var allLoaded = false
	@Published var searchAllLoaded = false

	private let pageSize = 5
	private let memoryLimit = 50
	private let db = Firestore.firestore()

	private var lastDocument: DocumentSnapshot?
	private var lastSearchDocument: DocumentSnapshot?

	var visibleBooks: [Book] {
		searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? books : searchResults
	}

	var activeAllLoaded: Bool {
		searchQuery.isEmpty ? allLoaded : searchAllLoaded
	}

	func loadInitialBooksIfNeeded() {
		if books.isEmpty { loadMoreBooks() }
	}

	private func resetSearch() {
		lastSearchDocument = nil
		searchResults = []
		searchAllLoaded = false

		if !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			loadMoreSearchResults()
		}
	}

	func loadMoreBooks() {
		guard !isLoading && !allLoaded else { return }
		isLoading = true

		var query = db.collection("books")
			.order(by: "title")
			.limit(to: pageSize)

		if let last = lastDocument {
			query = query.start(afterDocument: last)
		}

		query.getDocuments { [weak self] snapshot, _ in
			DispatchQueue.main.async {
				self?.isLoading = false

				guard let docs = snapshot?.documents, !docs.isEmpty else {
					self?.allLoaded = true
					return
				}

				let newBooks = docs.compactMap { try? $0.data(as: Book.self) }
				self?.books.append(contentsOf: newBooks)

				if self?.books.count ?? 0 > self?.memoryLimit ?? 50 {
					self?.books.removeFirst((self?.books.count ?? 0) - 50)
				}

				self?.lastDocument = docs.last
				self?.allLoaded = docs.count < self?.pageSize ?? 5
			}
		}
	}

	func loadMoreSearchResults() {
		guard !isLoading && !searchAllLoaded else { return }
		isLoading = true

		let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

		var query = db.collection("books")
			.order(by: "title")
			.start(at: [trimmed])
			.end(at: [trimmed + "\u{f8ff}"])
			.limit(to: pageSize)

		if let last = lastSearchDocument {
			query = query.start(afterDocument: last)
		}

		query.getDocuments { [weak self] snapshot, _ in
			DispatchQueue.main.async {
				self?.isLoading = false

				guard let docs = snapshot?.documents, !docs.isEmpty else {
					self?.searchAllLoaded = true
					return
				}

				let newBooks = docs.compactMap { try? $0.data(as: Book.self) }
				self?.searchResults.append(contentsOf: newBooks)

				if self?.searchResults.count ?? 0 > self?.memoryLimit ?? 50 {
					self?.searchResults.removeFirst((self?.searchResults.count ?? 0) - 50)
				}

				self?.lastSearchDocument = docs.last
				self?.searchAllLoaded = docs.count < self?.pageSize ?? 5
			}
		}
	}
}
