//
//  FavoriteDetailView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct FavoriteDetailView: View {
    let comic: ComicCoreData
    
    var body: some View {
        ScrollView {
            VStack {
                ComicImageView(imageURL: comic.wrappedImageURL)
                
                ComicTitleView(title: comic.wrappedTitle)
                
                ComicCreatorsCDView(creators: comic.creatorsArray)
                
                ComicDescriptionView(description: comic.comicDescription)
                
                ComicPagesView(pageCount: comic.wrappedPageCount)
                
            }
            .padding(.horizontal)
        }
    }
}

struct ComicCreatorsCDView: View {
    let creators: [CreatorCoreData]
    
    var body: some View {
        VStack {
            ForEach(creators, id: \.self) { creator in
                Text("\(creator.wrappedRole.capitalized) : \(creator.wrappedName)")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom)
    }
}
