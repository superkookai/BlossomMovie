//
//  SearchViewModel.swift
//  BlossomMovie
//
//  Created by Weerawut on 25/2/2569 BE.
//

import Foundation
import OSLog

@Observable
class SearchViewModel {
    private(set) var errorMessage: String?
    private(set) var searchTitles: [Title] = []
    private let dataFetcher = DataFetcher()
    
    init() {
        Logger().debug("SearchViewModel init")
    }
    
    func getSearchTitles(by media: String, for title: String) async {
        do {
            if title.isEmpty {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "search", for: title)
            }
            errorMessage = nil
        } catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
}
