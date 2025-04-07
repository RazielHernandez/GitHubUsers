//
//  GitHubUserSearchView.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

struct GitHubUserSearchView: View {
    @StateObject private var viewModel = GitHubViewModel()
    @State private var username: String = ""
    @State private var submittedUsername: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                if let user = viewModel.user, user.login.lowercased() == submittedUsername.lowercased() {
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: user.avatar_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 4)

                        Text(user.login)
                            .font(.title2)
                            .bold()

                        if let name = user.name {
                            Text(name)
                                .font(.headline)
                        }

                        if let bio = user.bio {
                            Text(bio)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        HStack(spacing: 30) {
                            NavigationLink(destination: GitHubUserListView(title: "Followers", fetchType: .followers, username: user.login)) {
                                Text("\(user.followers) followers")
                                    .foregroundColor(.blue)
                            }

                            NavigationLink(destination: GitHubUserListView(title: "Following", fetchType: .following, username: user.login)) {
                                Text("\(user.following) following")
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding()
                } else if submittedUsername != "", viewModel.errorMessage != nil {
                    VStack(spacing: 16) {
                        Image(systemName: "person.fill.questionmark")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)

                        Text("User not found")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    Spacer()
                }

                Spacer()

                // Search Bar at bottom
                HStack {
                    TextField("Search GitHub username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        submittedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !submittedUsername.isEmpty {
                            viewModel.fetchUser(username: submittedUsername)
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
                .padding(.bottom, 16)
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("GitHub Search")
        }
    }
}

#Preview {
    GitHubUserSearchView()
}
