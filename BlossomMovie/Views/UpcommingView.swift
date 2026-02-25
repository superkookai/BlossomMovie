//
//  UpcommingView.swift
//  BlossomMovie
//
//  Created by Weerawut on 25/2/2569 BE.
//

import SwiftUI

struct UpcommingView: View {
    @Environment(ViewModel.self) private var viewModel
    @State private var titlePath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $titlePath) {
            GeometryReader { geo in
                switch viewModel.upcomingStatus {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    VerticalListView(titles: viewModel.upcomingMovies, canDelete: false) { title in
                        titlePath.append(title)
                    }
                case .failure(let underlyError):
                    Text(underlyError.localizedDescription)
                        .errorMessage()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .task {
                await viewModel.getUpcomingMovies()
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)
            }
        }
    }
}

#Preview {
    UpcommingView()
        .environment(ViewModel())
}
