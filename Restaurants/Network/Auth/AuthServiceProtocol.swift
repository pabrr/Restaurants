//
//  AuthServiceProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import Combine

protocol AuthServiceProtocol {
    func auth(with login: String, password: String) -> AnyPublisher<AuthResponseModel, BaseError>
    func register(with login: String, password: String, isOwner: Bool) -> AnyPublisher<AuthResponseModel, BaseError>
}
