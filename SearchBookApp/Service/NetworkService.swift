//
//  NetworkService.swift
//  SearchBookApp
//
//  Created by m.toporkov on 12.03.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getBooks(searchWord: String, completion: @escaping (ResultEntity<SearchBooksModel, APIError>) -> Void)
}

enum ResultEntity<T, E> where E: Error, T: Codable {
    case success(T)
    case failure(E)
}

enum APIError: Error {
    case invalidUrl
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        }
    }
}

final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    private let apiClient = ApiClient.shared
    
    func getBooks(searchWord: String, completion: @escaping (ResultEntity<SearchBooksModel, APIError>) -> Void) {
        guard let url = apiClient.getUrlFromEndpoint(.searchBook, search: searchWord) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.responseUnsuccessful))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data,
               let model = SearchBooksModel(data: data) {
                completion(.success(model))
            } else {
                completion(.failure(.jsonParsingFailure))
                return
            }
        }
        task.resume()
    }
}
