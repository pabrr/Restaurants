//
//  ReviewRequestModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 04.07.2021.
//

struct ReviewRequestModel: Encodable {
    let restaurantId: Int
    let comment: String
    let rate: Int
    let dateOfVisit: String
}
