//
//  ComicExtension.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import Foundation

extension Comic {
    // Convert Comic thumbnail to HTTPS Image URL
    func extractImage() -> URL {
        // combining both and forming image...
        let path = self.thumbnail["path"] ?? ""
        let ext = self.thumbnail["extension"] ?? ""
        let httpURL = URL(string: "\(path).\(ext)")!
        
        // convert http url to https url
        var comps = URLComponents(url: httpURL, resolvingAgainstBaseURL: false)!
        comps.scheme = "https"
        
        return comps.url!
    }
}
