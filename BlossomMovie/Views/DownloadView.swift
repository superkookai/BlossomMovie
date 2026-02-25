//
//  DownloadView.swift
//  BlossomMovie
//
//  Created by Weerawut on 25/2/2569 BE.
//

import SwiftUI
import SwiftData

struct DownloadView: View {
    @Query(sort: \Title.title) var savedTitles: [Title]
    @State private var titlePath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $titlePath) {
            Group {
                if savedTitles.isEmpty {
                    Text("No Downloads")
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                } else {
                    VerticalListView(titles: savedTitles, canDelete: true) { title in
                        titlePath.append(title)
                    }
                }
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)
            }
        }
    }
}

#Preview {
    DownloadView()
}
