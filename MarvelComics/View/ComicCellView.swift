//
//  ComicCell.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    
    var body: some View {
        VStack {
            AsyncImage(url: comic.extractImage()) { image in
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                
            } placeholder: {
                Color.gray
            }
            .frame(width: 180, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding()
        }
        .padding()
    }
}

struct ComicCellView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleComic = Comic(id: 0, title: "Spider-Man", thumbnail: ["" : ""], urls: [["" : ""]])
        
        ComicCellView(comic: exampleComic)
    }
}
