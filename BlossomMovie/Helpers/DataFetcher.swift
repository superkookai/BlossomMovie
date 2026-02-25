//
//  DataFetcher.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import Foundation
import OSLog

struct DataFetcher {
    init() {
        Logger().debug("DataFetcher init")
    }
    
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    
    //MARK: - Fetch Movie Titles
    // https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/search/movie?api_key=YOUR_API_KEY&query=SEARCH_PHARSE
    func fetchTitles(for media: String, by type: String, for title: String? =  nil) async throws -> [Title] {
        guard let fetchTitleURL = try buildURL(media: media, type: type, searchPhrase: title) else {
            throw NetworkError.urlBuildFailed
        }
        print(fetchTitleURL)
        
        var titles = try await fetchAndDecode(url: fetchTitleURL, type: TMDBAPIObject.self).results
        Constants.addPosterPath(to: &titles)
        return titles
    }
    
    
    
    //MARK: - Fetch Youtube VideoId for Title
    //https://www.googleapis.com/youtube/v3/search?q=Breaking%20Bad%20trailer&key=APIKEY
    func fetchVideoId(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL, let apiKey = youtubeAPIKey else {
            throw NetworkError.missingConfigError
        }
        
        let trailerSearch = title + YoutubeURLString.space.rawValue + YoutubeURLString.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
            URLQueryItem(name: YoutubeURLString.queryShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YoutubeURLString.key.rawValue, value: apiKey)
        ]) else {
            throw NetworkError.urlBuildFailed
        }
        print(fetchVideoURL)
        
        return try await fetchAndDecode(url: fetchVideoURL, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
    }
    
    //MARK: - Helper Functions
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponseError(undelyingError: NSError(domain: "DataFetcher", code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
    
    private func buildURL(media: String, type: String, searchPhrase: String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL, let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfigError
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming"{
            path = "3/\(media)/\(type)"
        } else if type == "search" {
            path = "3/\(type)/\(media)"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        var urlQueryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        if let searchPhrase {
            urlQueryItems.append(URLQueryItem(name: "query", value: searchPhrase))
        }
        
        guard let url = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: urlQueryItems) else {
            throw NetworkError.urlBuildFailed
        }
        
        return url
    }
}
