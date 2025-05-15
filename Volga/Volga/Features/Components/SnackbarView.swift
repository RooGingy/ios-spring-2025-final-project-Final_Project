//
//  SnackbarView.swift
//  Volga
//
//  Created by Austin Moser on 4/30/25.
//


import SwiftUI

struct SnackbarView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.85))
            .cornerRadius(12)
            .shadow(radius: 4)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .padding(.bottom, 20)
    }
}