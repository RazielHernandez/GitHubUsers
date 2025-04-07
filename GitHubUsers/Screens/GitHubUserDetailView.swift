//
//  GitHubUserDetailView.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

struct GitHubUserDetailView: View {
    let username: String
    @StateObject private var viewModel = GitHubViewModel()
    @State private var isLoading = true

    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView("Loading user...")
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            } else if let user = viewModel.user {
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: user.avatar_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

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
            } else {
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
            }
        }
        .onAppear {
            viewModel.fetchUser(username: username) {
                isLoading = false
            }
        }
        .navigationTitle(username)
    }
}


struct GitHubUserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = GitHubViewModel()
        mockViewModel.user = GitHubUser(
            login: "octocat",
            avatar_url: "https://avatars.githubusercontent.com/u/583231?v=4",
            html_url: "https://github.com/octocat",
            name: "The Octocat",
            bio: "Just a test GitHub user 🐙",
            location: "The Internet",
            public_repos: 8,
            followers: 39,
            following: 9
        )

        return NavigationStack {
            GitHubUserDetailView(username: "octocat")
        }
    }
}

