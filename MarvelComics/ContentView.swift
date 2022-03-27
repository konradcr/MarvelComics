//
//  ContentView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ContentView: View {
    // ViewModel
    @StateObject var dataSource = ContentDataSource()
    
    var body: some View {
        Home()
            // Set dataModel into the env
            .environmentObject(dataSource)
            // Set Core Data context into the env
            .environment(\.managedObjectContext, dataSource.container.viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
