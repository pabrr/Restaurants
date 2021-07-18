//
//  UserServiceProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Combine

protocol UserServiceProtocol {
    func getUsers() -> AnyPublisher<[UserResponseModel], BaseError>
    func updateUser(_ requestModel: UserResponseModel) -> AnyPublisher<Void, BaseError>
    func deleteUser(with id: Int) -> AnyPublisher<Void, BaseError>
}
