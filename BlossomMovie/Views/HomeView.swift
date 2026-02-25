//
//  HomeView.swift
//  BlossomMovie
//
//  Created by Weerawut on 24/2/2569 BE.
//

import SwiftUI
import OSLog
import SwiftData

struct HomeView: View {
    @Environment(ViewModel.self) private var viewModel
    @State private var titleDetailPath = NavigationPath()
    
    @Environment(\.modelContext) private var context
    
    init () {
        Logger().debug("HomeView init")
    }
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
            GeometryReader { geo in
                ScrollView {
                    switch viewModel.homeStatus {
                    case .notStarted:
                        EmptyView()
                    case .fetching:
                        ProgressView()
                            .frame(width: geo.size.width, height: geo.size.height)
                    case .success:
                        LazyVStack {
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .overlay {
                                        LinearGradient(
                                            stops: [Gradient.Stop(color: .clear, location: 0.8), Gradient.Stop(color: .gradient, location: 1)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: geo.size.width, height: geo.size.height*0.85)
                            
                            HStack {
                                Button {
                                    titleDetailPath.append(viewModel.heroTitle)
                                } label: {
                                    Text(Constants.playSting)
                                        .ghostButton()
                                }
                                
                                Button {
                                    context.insert(viewModel.heroTitle)
                                    try? context.save()
                                } label: {
                                    Text(Constants.downloadSting)
                                        .ghostButton()
                                }
                            }
                            
                            HorizontalListView(header: Constants.trendingMovieSting, titles: viewModel.trendingMovies) {
                                title in titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.trendingTVString, titles: viewModel.trendingTV) {
                                title in titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.topRatedMovieString, titles: viewModel.topRatedMovies) {
                                title in titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.topRatedTVString, titles: viewModel.topRatedTV) {
                                title in titleDetailPath.append(title)
                            }
                        }
                    case let .failure(underlyError: error):
                        Text(error.localizedDescription)
                            .errorMessage()
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                    
                }
                .task {
                    await viewModel.getTitles()
                }
                .navigationDestination(for: Title.self) { title in
                    TitleDetailView(title: title)
                }
                .onDisappear {
                    Logger().debug("HomeView onDisappear")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(ViewModel())
}
