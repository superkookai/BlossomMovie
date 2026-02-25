//
//  TitleDetailView.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import SwiftUI
import YouTubePlayerKit
import SwiftData

struct TitleDetailView: View {
    let title: Title
    var titleName: String {
        (title.name ?? title.title) ?? ""
    }
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geo in
            switch viewModel.videoIdStatus {
            case .notStarted:
                EmptyView()
            case .fetching:
                ProgressView()
                    .frame(width: geo.size.width, height: geo.size.height)
            case .success:
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        if let url = URL(string: viewModel.youtubeURLString) {
                            YouTubePlayerView(.init(url: url))
                                .aspectRatio(1.3, contentMode: .fit)
                        } else {
                            Text("No Trailer found!")
                                .font(.largeTitle)
                        }
                        
                        Text(titleName)
                            .font(.title2)
                            .bold()
                            .padding(5)
                        
                        Text(title.overview ?? "")
                            .padding(5)
                        
                        Button {
                            let saveTitle = title
                            saveTitle.title = titleName
                            context.insert(saveTitle)
                            try? context.save()
                            dismiss()
                        } label: {
                            Text(Constants.downloadSting)
                                .ghostButton()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            case .failure(let underlyError):
                Text(underlyError.localizedDescription)
                    .errorMessage()
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .task {
            await viewModel.getVideoId(for: titleName)
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
        .environment(ViewModel())
}
