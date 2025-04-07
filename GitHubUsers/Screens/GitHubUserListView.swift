//
//  GitHubUserListView.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

enum GitHubUserListType {
    case followers
    case following
}

struct GitHubUserListView: View {
    let title: String
    let fetchType: GitHubUserListType
    let username: String
    var previewUsers: [GitHubSimpleUser]? = nil

    @State private var users: [GitHubSimpleUser] = []
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading \(title)...")
            } else if let error = error {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                ForEach(users) { user in
                    NavigationLink(destination: GitHubUserDetailView(username: user.login)) {
                        HStack {
                            AsyncImage(url: URL(string: user.avatar_url)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                            Text(user.login)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            loadUsers()
        }
    }

    private func loadUsers() {
        let urlString: String
        switch fetchType {
        case .followers:
            urlString = "https://api.github.com/users/\(username)/followers"
        case .following:
            urlString = "https://api.github.com/users/\(username)/following"
        }

        guard let url = URL(string: urlString) else {
            error = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, err in
            DispatchQueue.main.async {
                isLoading = false
                if let err = err {
                    error = err.localizedDescription
                    return
                }

                guard let data = data else {
                    error = "No data received"
                    return
                }

                do {
                    let users = try JSONDecoder().decode([GitHubSimpleUser].self, from: data)
                    self.users = users
                } catch {
                    self.error = "Failed to decode data"
                }
            }
        }.resume()
    }
}

struct GitHubUserListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GitHubUserListView(
                title: "Followers",
                fetchType: .followers,
                username: "octocat",
                previewUsers: [
                    GitHubSimpleUser(
                        login: "mojombo",
                        avatar_url: "https://avatars.githubusercontent.com/u/1?v=4"
                    ),
                    GitHubSimpleUser(
                        login: "defunkt",
                        avatar_url: "https://avatars.githubusercontent.com/u/2?v=4"
                    )
                ]
            )
        }
    }
}
