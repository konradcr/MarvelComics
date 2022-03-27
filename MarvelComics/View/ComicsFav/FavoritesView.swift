//
//  FavoritesView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favComics: FetchedResults<ComicCoreData>
    @EnvironmentObject var dataSource: ContentDataSource
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favComics) { comic in
                    NavigationLink {
                        FavoriteDetailView(comic: comic)
                    } label: {
                        FavoriteRowView(comic: comic)
                    }
                }
                .onDelete(perform: removeFromFav)
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
            .navigationTitle("Favorite Comics")
        }
    }
    
    func removeFromFav(at offsets: IndexSet) {
        for index in offsets {
            let comic = favComics[index]
            moc.delete(comic)
            dataSource.save()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
