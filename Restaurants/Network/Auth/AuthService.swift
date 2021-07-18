//
//  AuthService.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import Foundation
import Combine

final class AuthService: NetworkProtocol, AuthServiceProtocol {

    // MARK: - Endpoints

    private enum Endpoints {
        case auth
        case register

        var urlString: String {
            switch self {
            case .auth: return "/auth/signin"
            case .register: return "/auth/signup"
            }
        }
    }

    // MARK: - AuthServiceProtocol

    func auth(with login: String, password: String) -> AnyPublisher<AuthResponseModel, BaseError> {
        let requestModel = SignInRequestModel(username: login, password: password)
        let urlString = Urls.baseUrl + Endpoints.auth.urlString
        return self.load(urlString: urlString, method: .post, bodyParameters: requestModel)
    }

    func register(with login: String, password: String, isOwner: Bool) -> AnyPublisher<AuthResponseModel, BaseError> {
        let requestModel = RegisterRequestModel(username: login, password: password, isRestaurantOwner: isOwner)
        let urlString = Urls.baseUrl + Endpoints.register.urlString
        return self.load(urlString: urlString, method: .post, bodyParameters: requestModel)
    }

}
