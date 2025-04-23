//
//  ReviewRow.swift
//  Volga
//
//  Created by Austin Moser on 4/15/25.
//

import SwiftUI

struct ReviewRow: View {
	let review: Review

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack {
				Text(review.name)
					.font(.headline)

				Spacer()

				HStack(spacing: 2) {
					ForEach(1...5, id: \.self) { i in
						Image(systemName: i <= review.rating ? "star.fill" : "star")
							.foregroundColor(.yellow)
							.font(.caption)
					}
				}
			}

			Text(review.comment)
				.font(.body)
				.foregroundColor(.secondary)
		}
		.padding(.vertical, 4)
	}
}
