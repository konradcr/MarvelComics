//
//  ComicsSearchView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct ComicsSearchView: View {
    @EnvironmentObject var searchDataSource: SearchDataSource

    var body: some View {
        NavigationView {
            List {
                if let comics = searchDataSource.fetchedComics {
                    
                    if comics.isEmpty{
                        // No results...
                        Text("No Comics Found")
                            .padding()
                        
                    } else {
                        // Displaying results....
                        ForEach(comics){ comic in
                            ComicsSearchCellView(comic: comic)
                        }
                    }
                } else {
                    if searchDataSource.searchQuery != "" {
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
            .searchable(text: $searchDataSource.searchQuery, prompt: "Search a comic by title...")
            .navigationTitle("Search Comic")
        }
    }
}

struct ComicsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsSearchView()
    }
}
