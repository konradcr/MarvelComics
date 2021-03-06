//
//  ComicsSearchView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct ComicsSearchView: View {
    @EnvironmentObject var dataSource: ContentDataSource

    var body: some View {
        NavigationView {
            List {
                if let comics = dataSource.searchedComics {
                    
                    if comics.isEmpty{
                        // No results...
                        Text("No Comics Found")
                            .padding()
                        
                    } else {
                        // Displaying results....
                        ForEach(comics) { comic in
                            NavigationLink {
                                ComicDetailView(comic: comic)
                                    .navigationTitle(comic.title)
                                    .navigationBarTitleDisplayMode(.inline)
                            } label: {
                                ComicsSearchCellView(comic: comic)
                            }
                        }
                    }
                } else {
                    if dataSource.searchQuery != "" {
                        // Loading Screem...
                        HStack() {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            .searchable(text: $dataSource.searchQuery, prompt: "Search a comic by title...")
            .navigationTitle("Search Comic")
        }
    }
}

struct ComicsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsSearchView()
    }
}
