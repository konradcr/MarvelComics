//
//  ComicsSearchCellView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import SwiftUI

struct ComicsSearchCellView: View {
    let comic: Comic
    
    var body: some View {
        HStack {
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
            
            Text(comic.title)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}
