//
//  YoutubePlayer.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
//    let webView = WKWebView()
    let videoId: String
    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let baseURLString = youtubeBaseURL,
                let baseURL = URL(string: baseURLString) else {
            return
        }
        let fullURL = baseURL.appending(path: videoId)
        webView.load(URLRequest(url: fullURL))
    }
}
