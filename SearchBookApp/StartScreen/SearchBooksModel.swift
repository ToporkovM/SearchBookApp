//
//  SearchBooksModel.swift
//  SearchBookApp
//
//  Created by m.toporkov on 12.03.2022.
//

import Foundation

struct SearchBooksModel: Codable {
    var items: [Book]?
    
    init?(data: Data) {
        do {
            self = try JSONDecoder().decode(SearchBooksModel.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct Book: Codable {
    var volumeInfo: VolumeInfoModel
}

struct VolumeInfoModel: Codable {
    var title: String?
    var authors: [String]?
    var publisher: String?
    
}
