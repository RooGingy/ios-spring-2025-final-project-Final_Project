//
//  ProfileView.swift
//  Volga
//
//  Created by Austin Moser on 5/14/25.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Your Profile")
                            .font(.title)
                            .padding(.top)

                        if let user = viewModel.user {
                            VStack(spacing: 12) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.blue)

                                Text(user.name)
                                    .font(.title2.bold())

                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        } else {
                            Text("No user info available.")
                                .foregroundColor(.secondary)
                                .padding()
                        }

                        Button(action: viewModel.signOut) {
                            Text("Sign Out")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
