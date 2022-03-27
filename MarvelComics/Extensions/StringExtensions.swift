//
//  StringExtensions.swift
//  MarvelComics
//
//  Created by Konrad Cureau on 27/03/2022.
//

import Foundation

extension String {
    func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: nil).string
    }
}
