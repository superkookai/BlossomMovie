//
//  VerticalListView.swift
//  BlossomMovie
//
//  Created by Weerawut on 25/2/2569 BE.
//

import SwiftUI
import SwiftData

struct VerticalListView: View {
    var titles: [Title]
    let canDelete: Bool
    @Environment(\.modelContext) private var modelContext
    let onSelect: (Title) -> Void
    
    var body: some View {
        List(titles) { title in
            AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                HStack {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(5)
                    
                    Text((title.name ?? title.title) ?? "")
                        .font(.system(size: 14))
                        .bold()
                }
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            .onTapGesture {
                onSelect(title)
            }
            .swipeActions(edge: .trailing) {
                if canDelete {
                    Button {
                        modelContext.delete(title)
                        try? modelContext.save()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VerticalListView(titles: Title.previewTitles, canDelete: true, onSelect: {_ in })
            .environment(ViewModel())
    }
}
