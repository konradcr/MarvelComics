//
//  ComicDetailView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ComicDetailView: View {
    let comic: Comic
    
    var body: some View {
        ScrollView {
            
            AsyncImage(url: comic.extractImage()) { image in
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
            } placeholder: {
                Color.gray
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding()
            
            ForEach(comic.urls, id: \.self) { data in
                NavigationLink(
                    destination: WebView(url: URL(string: data["url"] ?? "")!)
                        .navigationTitle(data["type"]?.capitalized ?? ""),
                    label: {
                        Text(data["type"]?.capitalized ?? "")
                    })
            }
        }
    }
}
