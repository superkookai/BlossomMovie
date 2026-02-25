//
//  BlossomMovieApp.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import SwiftUI
import SwiftData

@main
struct BlossomMovieApp: App {
    let viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .modelContainer(for: Title.self)
    }
}
