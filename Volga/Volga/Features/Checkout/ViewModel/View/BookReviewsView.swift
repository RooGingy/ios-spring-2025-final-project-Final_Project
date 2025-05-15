//
//  BookReviewsView.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct BookReviewsView: View {
    let book: Book
    @ObservedObject private var currentUser = CurrentUserManager.shared
    @StateObject private var reviewVM: ReviewViewModel

    @State private var showReviewSheet = false

    init(book: Book) {
        self.book = book
        _reviewVM = StateObject(wrappedValue: ReviewViewModel(bookId: book.id!))
    }

    var body: some View {
        VStack {
            if reviewVM.reviews.isEmpty {
                Text("No reviews yet.")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    Section(header: Text("Reviews for \(book.title.uppercased())").font(.headline)) {
                        ForEach(reviewVM.reviews) { review in
                            ReviewRow(review: review)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            Button(action: {
                showReviewSheet = true
            }) {
                Text("Write a Review")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("SoftTealBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showReviewSheet) {
                AddReviewSheet(bookId: book.id!) {
                    reviewVM.loadReviews()
                }
            }
        }
        .navigationTitle("Reviews")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // DO NOT CALL loadUser() HERE, YA TWIT
            reviewVM.loadReviews()
        }
    }
}
