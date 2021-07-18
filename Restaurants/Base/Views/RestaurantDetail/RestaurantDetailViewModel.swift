//
//  RestaurantDetailViewModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import Foundation

struct RestaurantDetailViewModel {

    // MARK: - Properties

    let imageUrlString: String?
    let rating: String
    let description: String
    let hasCommentButton: Bool

    // MARK: - Init

    init(model: RestaurantResponseModel, hasCommentButton: Bool) {
        self.imageUrlString =  model.imageUrlString
        if let rate = model.averageRate {
            self.rating = String(format: "%.1f", rate)
        } else {
            self.rating = "?"
        }
        self.description =  model.description

        self.hasCommentButton = hasCommentButton
    }

}
