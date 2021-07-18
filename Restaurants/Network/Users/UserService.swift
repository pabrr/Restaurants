//
//  UserService.swift
//  Restaurants
//
//  Created by Полина Полухина on 04.07.2021.
//

import Combine

final class UserService: NetworkProtocol, UserServiceProtocol {

    // MARK: - Endpoints

    private enum Endpoints {
        case users

        var urlString: String {
            switch self {
            case .users: return "/users"
            }
        }
    }

    // MARK: - UserServiceProtocol


    func getUsers() -> AnyPublisher<[UserResponseModel], BaseError> {
        let urlString = Urls.baseUrl + Endpoints.users.urlString
        return self.loadAuthorized(urlString: urlString, method: .get)
    }

    func updateUser(_ requestModel: UserResponseModel) -> AnyPublisher<Void, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.users.urlString + "/\(requestModel.id)"
        return self.loadAuthorized(urlString: urlString, method: .put, bodyParameters: requestModel)
    }

    func deleteUser(with id: Int) -> AnyPublisher<Void, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.users.urlString + "/\(id)"
        return self.loadAuthorized(urlString: urlString, method: .delete)
    }

}
