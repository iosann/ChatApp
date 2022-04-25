//
//  APIManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 25.04.2022.
//

import Foundation

typealias DataResult = Result<Data, NetworkError>
typealias ImagesURLResult = Result<[String], NetworkError>

class APIManager {
    
    private func fetchData(with request: URLRequest, _ completion: @escaping(DataResult) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                completion(.failure(.sessionError(error)))
                return
            }
            if let data = data, let responce = responce as? HTTPURLResponse {
                if 400..<500 ~= responce.statusCode {
                    completion(.failure(.statusCode(responce.statusCode)))
                    return
                }
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func loadImagesList(_ completion: @escaping(ImagesURLResult) -> Void) {
        guard let baseUrl = URL(string: URLConstants.pixabay) else {
            completion(.failure(.invalidURL))
            return
        }
        let queryItems = [
            URLQueryItem(name: "key", value: Tokens.pixabay),
            URLQueryItem(name: "category", value: "animals"),
            URLQueryItem(name: "per_page", value: "100")
        ]
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url, timeoutInterval: 10)
        fetchData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let responce = try JSONDecoder().decode(ImagesResponce.self, from: data)
                    var imagesUrls = [String]()
                    responce.hits?.forEach {
                        if let previewURL = $0.previewURL { imagesUrls.append(previewURL) }
                    }
                    completion(.success(imagesUrls))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
