//
//  GitHubUserListView.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

struct GitHubUserSearchView: View {
    
    @State private var username: String = ""
    @State private var shouldNavigate = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                
                Image("github-icon-1-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                // MARK: - Navigation link
                NavigationLink(
                    destination: GitHubUserDetailView(username: username),
                    isActive: $shouldNavigate
                ) {
                    EmptyView()
                }
                .hidden()
                
                // MARK: - Search Bar
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
                                username = trimmed
                                shouldNavigate = true
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
            .onAppear {
                path.removeLast(path.count)
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    GitHubUserSearchView()
}
