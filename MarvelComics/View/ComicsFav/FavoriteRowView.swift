//
//  FavoriteRowView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct FavoriteRowView: View {
    let comic: ComicCoreData
    
    var body: some View {
        HStack {
            AsyncImage(url: comic.wrappedImageURL) { image in
                VStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Text(comic.wrappedTitle)
            Spacer()
        }
    }
}
