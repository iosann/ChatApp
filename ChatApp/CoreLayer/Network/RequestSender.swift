//
//  RequestSender.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

protocol IRequestSender {
    func send<Parser>(config: RequestConfiguration<Parser>, completion: @escaping(Result<Parser.Model, Error>) -> Void)
}

class RequestSender: IRequestSender {
    
    func send<Parser>(config: RequestConfiguration<Parser>, completion: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.sessionError(error)))
                return
            }
            if let response = response as? HTTPURLResponse, 400..<500 ~= response.statusCode {
                completion(.failure(NetworkError.statusCode(response.statusCode)))
                return
            }
            guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completion(.failure(NetworkError.decodingError))
                return
            }
            completion(.success(parsedModel))
        }
        task.resume()
    }
}
