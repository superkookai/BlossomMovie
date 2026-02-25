//
//  ContentView.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(Constants.homeSting, systemImage: Constants.homeIconString) {
                HomeView()
            }
            
            Tab(Constants.upcommingSting, systemImage: Constants.uppcommingIconString) {
                UpcommingView()
            }
            
            Tab(Constants.searchSting, systemImage: Constants.searchIconString) {
                SearchView()
            }
            
            Tab(Constants.downloadSting, systemImage: Constants.downloadIconString) {
                DownloadView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
}
