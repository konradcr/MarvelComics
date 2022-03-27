//
//  SearchDataSource.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import Foundation
import Combine
import CryptoKit

class SearchDataSource: ObservableObject {
    @Published var searchQuery = ""
    
    // Combine Framework Search Bar....
    
    // used to cancel the search publisher when ever we need....
    var searchCancellable: AnyCancellable? = nil
    
    // fetched Data....
    @Published var fetchedComics: [Comic]? = nil
    
    init() {
        // since SwiftUI uses @published so its a publisher...
        // so we dont need to explicitly define publisher...
        searchCancellable = $searchQuery
            // removing duplicate typings...
            .removeDuplicates()
            // we dont need to fetch for every typing....
            // so it will wait for 0.4 after user ends typing...
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                
                if str == ""{
                    // reset Data....
                    self.fetchedComics = nil
                }
                else{
                    self.fetchedComics = nil
                    // search Data...
                    self.searchComic()
                }
            })
    }
    
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
                
                // decoding API Data....
                
                let comics = try JSONDecoder().decode(APIComicResult.self, from: APIData)
                
                DispatchQueue.main.async {
                    
                    if self.fetchedComics == nil{
                        self.fetchedComics = comics.data.results
                    }
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
    }
}
