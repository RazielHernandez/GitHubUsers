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
    
    init(username: String, viewModel: GitHubViewModel = GitHubViewModel()) {
            self.username = username
            _viewModel = StateObject(wrappedValue: viewModel)
        }

    var body: some View {
        VStack {
            if let user = viewModel.user {
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
                        Text("\(user.followers) followers")
                        Text("\(user.following) following")
                    }
                    .font(.subheadline)
                }
                .padding()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Spacer()
                ProgressView("Loading...")
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchUser(username: username)
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
            followers: 3934,
            following: 9
        )

        return NavigationStack {
            GitHubUserDetailView(username: "octocat", viewModel: mockViewModel)
        }
    }
}

