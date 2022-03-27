//
//  ComicCellView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    
    var body: some View {
        let noImageURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg")
        
        VStack {
            if comic.extractImage() == noImageURL {
                ZStack {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.2))
                    Text(comic.title)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                AsyncImage(url: comic.extractImage()) { image in
                    VStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                } placeholder: {
                    Color.gray
                }
            }
        }
        .frame(width: 180, height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .padding()
    }
}

