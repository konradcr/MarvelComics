//
//  ContentDataSource.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import Foundation
import Combine
import CryptoKit
import CoreData

class ContentDataSource: ObservableObject {
    @Published var comics = [Comic]()
    @Published var searchedComics: [Comic]? = nil
    @Published var searchQuery = ""
    @Published var isLoadingComics = false
    
    private var offset = 0
    private var canLoadMoreComics = true
    
    // Used to cancel the search publisher when ever we need
    var searchCancellable: AnyCancellable? = nil
    
    // Core Data container used to save Favorites Comcis
    let container = NSPersistentContainer(name: "ComicCoreData")
    
    init() {
        loadMoreContent()
        // Initialize Core Data container
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        searchCancellable = $searchQuery
            // Removing duplicate typings...
            .removeDuplicates()
            // Wait for 0.4s after user ends typing
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == ""{
                    // Reset Data
                    self.searchedComics = nil
                }
                else{
                    self.searchedComics = nil
                    // Search Data
                    self.searchComic()
                }
            })
    }
    
    // Load more comics when the user is at the end of the list
    func loadMoreContentIfNeeded(currentItem item: Comic?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = comics.index(comics.endIndex, offsetBy: -5)
        if comics.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
    
    // Load Comics from MarvelAPI
    private func loadMoreContent() {
        guard !isLoadingComics && canLoadMoreComics else {
            return
        }
        
        isLoadingComics = true
        
        let ts = String(Date().timeIntervalSince1970)
        let stringToHash = ts + privateKey + publicKey
        let hash = stringToHash.MD5
        
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/comics?limit=100&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            // Decoding API Data
            .decode(type: APIComicResult.self, decoder: JSONDecoder())
            // Reveive on main thread
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                // If data.count is not equal to 100, it means that it is the last page
                if response.data.count != 100 {
                    self.canLoadMoreComics = false
                }
                self.isLoadingComics = false
                // Add offset to load new comics page
                self.offset += 100
            })
            .map({ response in
                return self.comics + response.data.results
            })
            // Remove duplicates
            .removeDuplicates()
            .catch({ _ in Just(self.comics) })
                .assign(to: &$comics)
    }
    
    // Search comic by title from the API
    func searchComic() {
        let ts = String(Date().timeIntervalSince1970)
        let stringToHash = ts + privateKey + publicKey
        let hash = stringToHash.MD5
        
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        
        let url = "https://gateway.marvel.com:443/v1/public/comics?titleStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            guard let APIData = data else{
                print("no data found")
                return
            }
            
            do{
                // Decoding API Data....
                let comics = try JSONDecoder().decode(APIComicResult.self, from: APIData)
                
                DispatchQueue.main.async {
                    if self.searchedComics == nil {
                        self.searchedComics = comics.data.results
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    // Add Comic to Core Data favorites
    func addToFav(_ comic: Comic) throws {
        let viewContext = container.viewContext
        
        let comicToSave = ComicCoreData(context: viewContext)
        comicToSave.id = Int32(comic.id)
        comicToSave.title = comic.title
        comicToSave.comicDescription = comic.description
        comicToSave.pageCount = Int16(comic.pageCount)
        comicToSave.image = comic.extractImage().absoluteString
        
        comic.creators.items.forEach { creator in
            let creatorCoreData = CreatorCoreData(context: viewContext)
            creatorCoreData.role = creator.role
            creatorCoreData.name = creator.name
            creatorCoreData.comic = comicToSave
        }
        save()
    }
    
    // Save Core Data
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
