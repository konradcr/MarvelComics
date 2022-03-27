//
//  ComicDetailView.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import SwiftUI

struct ComicDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dataSource: ContentDataSource
    
    let comic: Comic
    
    var body: some View {
        ScrollView {
            VStack {
                
                ComicImageView(imageURL: comic.extractImage())
                
                ComicTitleView(title: comic.title)
                
                ComicCreatorsView(comic: comic)
                
                ComicDescriptionView(description: comic.description)
                
                ComicPagesView(pageCount: comic.pageCount)
                
                ComicRessourcesView(urls: comic.urls)
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    try? dataSource.addToFav(comic)
                } label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }
            }
        }
    }
}

struct ComicTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
    }
}

struct ComicImageView: View {
    let imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
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
    let description: String?
    
    var body: some View {
        if let description = description {
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
    let pageCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "bookmark.circle")
            Text("Number of pages :")
                .bold()
            Spacer()
            Text("\(pageCount)")
        }
        
    }
}

struct ComicRessourcesView: View {
    let urls: [[String : String]]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "link.circle")
                Text("Ressources")
                    .bold()
                Spacer()
            }
            ForEach(urls, id: \.self) { data in
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
