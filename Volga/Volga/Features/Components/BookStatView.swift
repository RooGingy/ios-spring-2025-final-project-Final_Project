//
//  BookStatView.swift
//  Volga
//
//  Created by Austin Moser on 4/12/25.
//

import SwiftUI

struct BookStatView: View {
	let label: String
	let value: String
	var body: some View {
		VStack(spacing: 4) {
			HStack(spacing: 6) {
				Text(label)
					.font(.caption)
					.foregroundColor(.secondary)
			}

			Text(value)
				.font(.headline)
				.multilineTextAlignment(.center)
		}
	}
}
