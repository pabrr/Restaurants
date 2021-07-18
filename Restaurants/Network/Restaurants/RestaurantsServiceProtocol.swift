//
//  RestaurantsServiceProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import Foundation
import Combine

protocol RestaurantsServiceProtocol {
    func getRestaurants() -> AnyPublisher<[RestaurantResponseModel], BaseError>
    func getRestaurantDetails(for id: Int) -> AnyPublisher<RestaurantResponseModel, BaseError>
    func saveRestaurant(_ model: RestaurantRequestModel) -> AnyPublisher<RestaurantResponseModel, BaseError>
    func uploadImage(to restaurantId: Int, imageData: Data, completion: @escaping EmptyClosure)
    func updateRestaurant(with id: Int, _ model: RestaurantRequestModel) -> AnyPublisher<RestaurantResponseModel, BaseError>
    func deleteRestaurant(with id: Int) -> AnyPublisher<Void, BaseError>
}
