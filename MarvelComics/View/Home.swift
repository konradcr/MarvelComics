//
//  Home.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var dataSource = ContentDataSource()

    var body: some View {
        
        TabView{
            // Comics View
            ComicsListView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Characters")
                }
                // setting Environment Object
                // so that we can access data on character View...
                .environmentObject(dataSource)
            
            // Favorites View
            Text("Favorites")
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
