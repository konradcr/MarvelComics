//
//  ComicsListView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ComicsListView: View {
    @EnvironmentObject var dataSource: ContentDataSource
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(dataSource.comics.removingDuplicates()) { comic in
                        NavigationLink {
                            ComicDetailView(comic: comic)
                                .navigationTitle(comic.title)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            ComicCellView(comic: comic)
                                .padding()
                                .onAppear {
                                    dataSource.loadMoreContentIfNeeded(currentItem: comic)
                                }
                                
                        }
                        .buttonStyle(.plain)
                    }
                }
                if dataSource.isLoadingComics {
                    ProgressView()
                }
            }
            .navigationTitle("Marvel's Comics")
        }
    }
}

struct ComicsListView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsListView()
    }
}
