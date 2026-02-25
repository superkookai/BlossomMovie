//
//  SearchView.swift
//  BlossomMovie
//
//  Created by Weerawut on 25/2/2569 BE.
//

import SwiftUI

struct SearchView: View {
    @State private var searchByMovies = true
    @State private var searchText = ""
    @State private var navigationPath = NavigationPath()
    
    private let searchViewModel = SearchViewModel()
    
    let columns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                if let errorMessage = searchViewModel.errorMessage {
                    Text(errorMessage)
                        .errorMessage()
                }
                LazyVGrid(columns: columns) {
                    ForEach(searchViewModel.searchTitles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()
                        }
                        .onTapGesture {
                            navigationPath.append(title)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(searchByMovies ? Constants.movieSearchString : Constants.tvSearchString)
            .navigationDestination(for: Title.self, destination: { title in
                TitleDetailView(title: title)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchByMovies.toggle()
                        Task {
                            await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
                        }
                    } label: {
                        Image(systemName: searchByMovies ? Constants.movieIconString : Constants.tvIconString)
                    }
                }
            }
            .searchable(text: $searchText,prompt: searchByMovies ? Constants.movieSearchString : Constants.tvSearchString)
            .task(id: searchText) {
                try? await Task.sleep(for: .milliseconds(500))
                if Task.isCancelled { return }
                await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
            }
        }
    }
}

#Preview {
    SearchView()
}
