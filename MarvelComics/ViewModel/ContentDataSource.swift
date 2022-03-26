//
//  ContentDataSource.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import Foundation
import Combine
import CryptoKit

class ContentDataSource: ObservableObject {
    @Published var comics = [Comic]()
    
    @Published var isLoadingComics = false
    
    private var offset = 0
    private var canLoadMoreComics = true
    
    init() {
        loadMoreContent()
    }
    
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
    
    private func loadMoreContent() {
        guard !isLoadingComics && canLoadMoreComics else {
            return
        }
        
        isLoadingComics = true
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/comics?limit=100&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            // decoding API Data
            .decode(type: APIComicResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                if response.data.count != 100 {
                    self.canLoadMoreComics = false
                }
                self.isLoadingComics = false
                self.offset += 100
            })
            .map({ response in
                return self.comics + response.data.results
            })
            .removeDuplicates()
            .catch({ _ in Just(self.comics) })
            .assign(to: &$comics)
                    
    }
    
    
    func MD5(data: String)->String {
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
