//
//  Constants.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import Foundation
import SwiftUI

struct Constants {
    static let homeSting = "Home"
    static let upcommingSting = "Upcoming"
    static let searchSting = "Search"
    static let downloadSting = "Download"
    static let playSting = "Play"
    static let trendingMovieSting = "Trending Movies"
    static let trendingTVString = "Trending TV"
    static let topRatedMovieString = "Top Rated Movies"
    static let topRatedTVString = "Top Rated TV"
    static let movieSearchString = "Movie Search"
    static let tvSearchString = "TV Search"
    static let moviePlaceholderString = "Search for a Movie"
    static let tvPlaceholderString = "Search for a TV Show"
    
    static let homeIconString = "house"
    static let uppcommingIconString = "play.circle"
    static let searchIconString = "magnifyingglass"
    static let downloadIconString = "arrow.down.to.line"
    static let tvIconString = "tv"
    static let movieIconString = "movieclapper"
    
    static let testTitleURL = "https://image.tmdb.org/t/p/w500/nnl6OWkyPpuMm595hmAxNW3rZFn.jpg"
    static let testTitleURL2 = "https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg"
    static let testTitleURL3 = "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"
    
    static let posterURLStart = "https://image.tmdb.org/t/p/w500"
    
    static func addPosterPath(to titles: inout [Title]) {
        for index in titles.indices {
            if let path = titles[index].posterPath {
                titles[index].posterPath = posterURLStart + path
            }
        }
    }
}

enum YoutubeURLString: String {
    case trailer = "trailer"
    case queryShorten = "q"
    case space = " "
    case key = "key"
}

extension Text {
    func ghostButton() -> some View {
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.buttonText)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.buttonBorder ,lineWidth: 5)
            )
    }
}

extension Text {
    func errorMessage() -> some View {
        self
            .foregroundColor(.red)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 10))
    }
}
