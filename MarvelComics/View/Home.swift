//
//  Home.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct Home: View {

    var body: some View {
        
        TabView{
            // Comics View
            ComicsListView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Characters")
                }
            
            // Search View
            ComicsSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            // Favorites View
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
