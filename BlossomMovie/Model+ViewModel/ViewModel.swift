//
//  ViewModel.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import Foundation
import OSLog

@Observable
class ViewModel {
    init() {
        Logger().debug("ViewModel init")
    }
    
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failure(underlyError: Error)
    }
    
    private(set) var homeStatus: FetchStatus = .notStarted
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private(set) var upcomingStatus: FetchStatus = .notStarted
    private let dataFecther = DataFetcher()
    
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    var upcomingMovies: [Title] = []
    var heroTitle = Title.previewTitles[0]
    
    var videoId: String = ""
    var youtubeURLString = ""
    
    func getTitles() async {
        homeStatus = .fetching
        if trendingMovies.isEmpty {
            do {
                async let tMovies = dataFecther.fetchTitles(for: "movie", by: "trending")
                async let tTV = dataFecther.fetchTitles(for: "tv", by: "trending")
                async let tRMovies = dataFecther.fetchTitles(for: "movie", by: "top_rated")
                async let tRTV =  dataFecther.fetchTitles(for: "tv", by: "top_rated")
                
                trendingMovies = try await tMovies
                trendingTV = try await tTV
                topRatedMovies = try await tRMovies
                topRatedTV = try await tRTV
                
                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                
                homeStatus = .success
            } catch {
                print(error.localizedDescription)
                homeStatus = .failure(underlyError: error)
            }
        } else {
            homeStatus = .success
        }
    }
    
    func getVideoId(for title: String) async {
        videoIdStatus = .fetching
        do {
            videoId = try await dataFecther.fetchVideoId(for: title)
            youtubeURLString = "https://www.youtube.com/watch?v=\(videoId)"
            videoIdStatus = .success
        } catch {
            print(error.localizedDescription)
            videoIdStatus = .failure(underlyError: error)
        }
    }
    
    func getUpcomingMovies() async {
        upcomingStatus = .fetching
        do {
            upcomingMovies = try await dataFecther.fetchTitles(for: "movie", by: "upcoming")
            upcomingStatus = .success
        } catch {
            print(error.localizedDescription)
            upcomingStatus = .failure(underlyError: error)
        }
    }
}
