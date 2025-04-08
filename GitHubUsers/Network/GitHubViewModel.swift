//
//  GitHubViewModel.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import Foundation
import Combine

// MARK: - ViewModel
class GitHubViewModel: ObservableObject {
    @Published var user: GitHubUser? = nil
    @Published var followers: [GitHubSimpleUser] = []
    @Published var following: [GitHubSimpleUser] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchUser(username: String, completion: (() -> Void)? = nil) {
        // Reset the state early
        self.user = nil
        self.errorMessage = nil

        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            self.errorMessage = "Invalid URL"
            completion?()
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Request error: \(error.localizedDescription)"
                    completion?()
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    completion?()
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    self.errorMessage = "User not found"
                    completion?()
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    completion?()
                    return
                }

                do {
                    let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                    self.user = user
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }

                completion?()
            }
        }.resume()
    }
    func fetchFollowers(username: String, completion: @escaping ([GitHubSimpleUser]) -> Void) {
            guard let url = URL(string: "https://api.github.com/users/\(username)/followers") else {
                errorMessage = "Invalid followers URL"
                completion([])
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion([])
                        return
                    }

                    guard let data = data else {
                        self.errorMessage = "No data"
                        completion([])
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode([GitHubSimpleUser].self, from: data)
                        self.followers = decoded
                        completion(decoded)
                    } catch {
                        self.errorMessage = "Decoding error: \(error.localizedDescription)"
                        completion([])
                    }
                }
            }.resume()
        }

        func fetchFollowing(username: String, completion: @escaping ([GitHubSimpleUser]) -> Void) {
            guard let url = URL(string: "https://api.github.com/users/\(username)/following") else {
                errorMessage = "Invalid following URL"
                completion([])
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion([])
                        return
                    }

                    guard let data = data else {
                        self.errorMessage = "No data"
                        completion([])
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode([GitHubSimpleUser].self, from: data)
                        self.following = decoded
                        completion(decoded)
                    } catch {
                        self.errorMessage = "Decoding error: \(error.localizedDescription)"
                        completion([])
                    }
                }
            }.resume()
        }

    private func handleError(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            self.errorMessage = error.localizedDescription
        }
    }
}
