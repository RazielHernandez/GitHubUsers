//
//  GitHubUserListView.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

struct GitHubUserSearchView: View {
    
    // MARK: - VARIABLES
    //@StateObject private var viewModel = GitHubViewModel()
    @State private var username: String = ""
    @State private var submittedUsername: String = ""
    @State private var shouldNavigate = false
    @State private var isLoading = false
    @State private var path = NavigationPath()
    
    @EnvironmentObject var viewModel: GitHubViewModel

    // MARK: - BODY
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()

                // Show loading
                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                }
                
                // Show error if user not found and not loading
                else if submittedUsername != "", viewModel.errorMessage != nil {
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
                
                else {
                    Image("github-icon-1-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                }

                Spacer()

                // Hidden navigation link
                NavigationLink(
                    destination: Group {
                        if let user = viewModel.user {
                            GitHubUserDetailView(username: user.login)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $shouldNavigate
                ) {
                    EmptyView()
                }
                .hidden()


                // Search Bar
                VStack {
                    
                    Text("Type the name of the user you're looking for")
                        .font(.footnote)
                    
                    HStack {
                        TextField("Search GitHub username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: {
                            let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty {
                                submittedUsername = trimmed
                                isLoading = true
                                viewModel.user = nil
                                viewModel.errorMessage = nil
                                
                                viewModel.fetchUser(username: trimmed) {
                                    DispatchQueue.main.async {
                                        isLoading = false
                                        if viewModel.user != nil {
                                            shouldNavigate = true
                                        }
                                    }
                                }
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
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("GitHub Search")
            .background(Color.secondary.opacity(0.2))
            .onAppear() {
                path.removeLast(path.count)
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    GitHubUserSearchView()
        .environmentObject(GitHubViewModel())
}
