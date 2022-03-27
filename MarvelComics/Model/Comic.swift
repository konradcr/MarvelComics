//
//  Comic.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 26/03/2022.
//

import Foundation

struct APIComicResult: Codable {
    var data: APIComicData
}

struct APIComicData: Codable {
    var count: Int
    var results: [Comic]
}

struct Comic: Identifiable, Codable, Equatable, Hashable {
    var id: Int
    var title: String
    var description: String?
    var pageCount: Int
    var thumbnail: [String : String]
    var urls: [[String : String]]
    var creators: Creators
}

struct Creators: Codable, Equatable, Hashable {
    var items: [Creator]
}

struct Creator: Codable, Equatable, Hashable {
    var name: String
    var role: String
}


