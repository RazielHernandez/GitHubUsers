//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by Raziel Hernandez on 2025-04-06.
//

import SwiftUI

@main
struct GitHubUsersApp: App {
    @StateObject var viewModel = GitHubViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            GitHubUserSearchView()
                
        }
        .environmentObject(viewModel)
        
    }
}
