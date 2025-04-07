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

    func fetchUser(username: String) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubUser.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleError, receiveValue: { [weak self] user in
                self?.user = user
                self?.errorMessage = nil
            })
            .store(in: &cancellables)
    }

    func fetchFollowers(username: String) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/followers") else {
            errorMessage = "Invalid followers URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GitHubSimpleUser].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleError, receiveValue: { [weak self] followers in
                self?.followers = followers
            })
            .store(in: &cancellables)
    }

    func fetchFollowing(username: String) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/following") else {
            errorMessage = "Invalid following URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GitHubSimpleUser].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: handleError, receiveValue: { [weak self] following in
                self?.following = following
            })
            .store(in: &cancellables)
    }

    private func handleError(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            self.errorMessage = error.localizedDescription
        }
    }
}
