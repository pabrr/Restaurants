//
//  AuthResponseModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

struct AuthResponseModel: Decodable {
    let userId: Int
    let username: String
    let accessToken: String
    let role: UserRole
}
