//
//  NetworkProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

import Foundation
import Combine

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}

protocol NetworkProtocol {
    func load<T: Encodable, U: Decodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<U, BaseError>
    func loadAuthorized(urlString: String, method: HttpMethod) -> AnyPublisher<Void, BaseError>
    func loadAuthorized<T: Encodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<Void, BaseError>
    func loadAuthorized<U: Decodable>(urlString: String, method: HttpMethod) -> AnyPublisher<U, BaseError>
    func loadAuthorized<T: Encodable, U: Decodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<U, BaseError>
}

extension NetworkProtocol {

    func load<T: Encodable, U: Decodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<U, BaseError> {
        guard var request = self.getRequest(urlString: urlString, method: method, isAuthorized: false) else {
            return Fail(error: BaseError.wrongUrl).eraseToAnyPublisher()
        }

        let jsonData = try? JSONEncoder().encode(bodyParameters)
        request.httpBody = jsonData

        return self.load(request: request)
    }

    func loadAuthorized(urlString: String, method: HttpMethod) -> AnyPublisher<Void , BaseError> {
        guard let request = self.getRequest(urlString: urlString, method: method, isAuthorized: true) else {
            return Fail(error: BaseError.wrongUrl).eraseToAnyPublisher()
        }
        return self.load(request: request)
    }

    func loadAuthorized<T: Encodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<Void, BaseError> {
        guard var request = self.getRequest(urlString: urlString, method: method, isAuthorized: true) else {
            return Fail(error: BaseError.wrongUrl).eraseToAnyPublisher()
        }

        let jsonData = try? JSONEncoder().encode(bodyParameters)
        request.httpBody = jsonData

        return self.load(request: request)
    }

    func loadAuthorized<U: Decodable>(urlString: String, method: HttpMethod) -> AnyPublisher<U, BaseError> {
        guard let request = self.getRequest(urlString: urlString, method: method, isAuthorized: true) else {
            return Fail(error: BaseError.wrongUrl).eraseToAnyPublisher()
        }
        return self.load(request: request)
    }

    func loadAuthorized<T: Encodable, U: Decodable>(urlString: String, method: HttpMethod, bodyParameters: T) -> AnyPublisher<U, BaseError> {
        guard var request = self.getRequest(urlString: urlString, method: method, isAuthorized: true) else {
            return Fail(error: BaseError.wrongUrl).eraseToAnyPublisher()
        }

        let jsonData = try? JSONEncoder().encode(bodyParameters)
        request.httpBody = jsonData

        return self.load(request: request)
    }

}

// MARK: - Private Methods

private extension NetworkProtocol {

    func getRequest(urlString: String, method: HttpMethod, isAuthorized: Bool) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if isAuthorized,
           let accessToken = KeychainService().getAccessToken() {
            request.addValue("Bearer \(String(describing: accessToken))", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func load<U: Decodable>(request: URLRequest) -> AnyPublisher<U, BaseError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                let httpResponse = try self.getHttpResponse(from: element)
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    return element.data
                }
                try self.handleBaseError(in: httpResponse, data: element.data)
                return element.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: U.self, decoder: JSONDecoder())
            .mapError({ error in
                self.mapError(error)
            })
            .eraseToAnyPublisher()
    }

    func load(request: URLRequest) -> AnyPublisher<Void, BaseError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Void in
                let httpResponse = try self.getHttpResponse(from: element)
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    return
                }
                try self.handleBaseError(in: httpResponse, data: element.data)
            }
            .receive(on: DispatchQueue.main)
            .mapError({ error in
                self.mapError(error)
            })
            .eraseToAnyPublisher()
    }

    func getHttpResponse(from element: URLSession.DataTaskPublisher.Output) throws -> HTTPURLResponse {
        guard let httpResponse = element.response as? HTTPURLResponse else {
            if let message = (try JSONSerialization.jsonObject(with: element.data, options: []) as? [String: Any])?["message"] as? String {
                throw BaseError.error(message: message)
            } else {
                throw BaseError.badServerResponse
            }
        }
        return httpResponse
    }

    func handleBaseError(in response: HTTPURLResponse, data: Data) throws {
        if response.statusCode == 400,
           let message = (((try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["message"]) as? [String])?.first {
            throw BaseError.error(message: message)
        }

        if response.statusCode == 422,
           let message = (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["message"] as? String {
            throw BaseError.error(message: message)
        }

        if response.statusCode == 401 {
            throw BaseError.unauthorized
        }

        throw BaseError.unknowned(error: nil)
    }

    func mapError(_ error: Error) -> BaseError {
        if let baseError = error as? BaseError {
            return baseError
        }
        return BaseError.unknowned(error: error)
    }

}
