//
//  RegisterRequestModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

struct RegisterRequestModel: Encodable {
    let username: String
    let password: String
    let isRestaurantOwner: Bool
}
