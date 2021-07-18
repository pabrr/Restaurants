//
//  RestaurantsService.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import Foundation
import Combine

final class RestaurantsService: NetworkProtocol, RestaurantsServiceProtocol {

    // MARK: - Endpoints

    private enum Endpoints {
        case restaurants
        case image(Int)

        var urlString: String {
            switch self {
            case .restaurants: return "/restaurants"
            case .image(let id): return "/restaurants/\(id)/photo"
            }
        }
    }

    // MARK: - RestaurantsServiceProtocol

    func getRestaurants() -> AnyPublisher<[RestaurantResponseModel], BaseError> {
        let urlString = Urls.baseUrl + Endpoints.restaurants.urlString
        return self.loadAuthorized(urlString: urlString, method: .get)
    }

    func getRestaurantDetails(for id: Int) -> AnyPublisher<RestaurantResponseModel, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.restaurants.urlString + "/\(id)"
        return self.loadAuthorized(urlString: urlString, method: .get)
    }

    func saveRestaurant(_ model: RestaurantRequestModel) -> AnyPublisher<RestaurantResponseModel, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.restaurants.urlString
        return self.loadAuthorized(urlString: urlString, method: .post, bodyParameters: model)
    }

    func uploadImage(to restaurantId: Int, imageData: Data, completion: @escaping EmptyClosure) {
        let urlString = Urls.baseUrl + Endpoints.image(restaurantId).urlString
        self.sendImage(urlString: urlString, method: .post, imageData: imageData, completion: completion)
    }

    func updateRestaurant(with id: Int, _ model: RestaurantRequestModel) -> AnyPublisher<RestaurantResponseModel, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.restaurants.urlString + "/\(id)"
        return self.loadAuthorized(urlString: urlString, method: .put, bodyParameters: model)
    }

    func deleteRestaurant(with id: Int) -> AnyPublisher<Void, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.restaurants.urlString + "/\(id)"
        return self.loadAuthorized(urlString: urlString, method: .delete)
    }

}

// MARK: - Private Methods

private extension RestaurantsService {

    func sendImage(urlString: String, method: HttpMethod, imageData: Data, completion: @escaping EmptyClosure) {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let accessToken = KeychainService().getAccessToken() {
            request.addValue("Bearer \(String(describing: accessToken))", forHTTPHeaderField: "Authorization")
        }

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: data, completionHandler: { _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }).resume()
    }

}
