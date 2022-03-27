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
            VStack {
                ComicImageView(comic: comic)
                
                ComicTitleView(comic: comic)
                
                ComicCreatorsView(comic: comic)
                
                ComicDescriptionView(comic: comic)
                
                ComicPagesView(comic: comic)
                
                ComicRessourcesView(comic: comic)
            }
            .padding(.horizontal)
        }
    }
}

struct ComicTitleView: View {
    let comic: Comic
    
    var body: some View {
        Text(comic.title)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
    }
}

struct ComicImageView: View {
    let comic: Comic
    
    var body: some View {
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
        .padding(.horizontal, 100)
        .padding()
        .shadow(radius: 5)
    }
}

struct ComicDescriptionView: View {
    let comic: Comic
    
    var body: some View {
        if let description = comic.description {
            if !description.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "book.closed.circle")
                        Text("Description")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    Text(description.htmlToString())
                }
                .padding(.vertical)
            }
        }
    }
}

struct ComicCreatorsView: View {
    let comic: Comic
    
    var body: some View {
        VStack {
            ForEach(comic.creators.items, id: \.self) { creator in
                Text("\(creator.role.capitalized) : \(creator.name)")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom)
    }
}

struct ComicPagesView: View {
    let comic: Comic
    
    var body: some View {
        HStack {
            Image(systemName: "bookmark.circle")
            Text("Number of pages :")
                .bold()
            Spacer()
            Text("\(comic.pageCount)")
        }
        
    }
}

struct ComicRessourcesView: View {
    let comic: Comic
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "link.circle")
                Text("Ressources")
                    .bold()
                Spacer()
            }
            ForEach(comic.urls, id: \.self) { data in
                NavigationLink(
                    destination: WebView(url: URL(string: data["url"] ?? "")!)
                        .navigationTitle(data["type"]?.capitalized ?? ""),
                    label: {
                        Text(data["type"]?.capitalized ?? "")
                            .padding(10)
                    }
                )
                .background(Capsule()
                    .stroke(lineWidth: 2)
                    .fill(.blue)
                )
            }
            
        }
        .padding(.vertical)
    }
}
