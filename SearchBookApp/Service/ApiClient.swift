//
//  ApiClient.swift
//  SearchBookApp
//
//  Created by m.toporkov on 12.03.2022.
//

import Foundation

protocol ApiClientProtocol {
    func getUrlFromEndpoint(_ endpoint: Endpoint, search forWord: String) -> URL?
}

enum Endpoint {
    case searchBook
    
    var path: String {
        switch self {
        case .searchBook:
            return "/books/v1/volumes"
        }
    }
}

final class ApiClient: ApiClientProtocol {
    
    private var baseUrl: String = "https://www.googleapis.com/"
    
    static let shared = ApiClient()
    
    func getUrlFromEndpoint(_ endpoint: Endpoint, search forWord: String) -> URL? {
        var finalUrl: URL?
        
        switch endpoint {
        case .searchBook:
            let urlString: String = baseUrl + endpoint.path
            var url = URLComponents(string: urlString)
            
            url?.queryItems = [
                URLQueryItem(name: "q", value: forWord)
            ]
            
            finalUrl = url?.url
        }
        
        return finalUrl
    }
}
