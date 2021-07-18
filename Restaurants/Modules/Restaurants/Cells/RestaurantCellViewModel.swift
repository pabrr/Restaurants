//
//  RestaurantCellViewModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import Foundation

struct RestaurantCellViewModel {

    // MARK: - Properties

    let id: Int
    let imageUrlString: String?
    let rating: String
    let infoText: String?

    // MARK: - Init

    init(with model: RestaurantResponseModel, isShowingInfo: Bool) {
        self.id = model.id
        self.imageUrlString = model.imageUrlString
        if let rate = model.averageRate {
            self.rating = String(format: "%.1f", rate)
        } else {
            self.rating = "?"
        }
        if isShowingInfo,
           let unrepliedCount = model.unrepliedComments,
           unrepliedCount > 0 {
            if unrepliedCount == 1 {
                self.infoText = Localizable.Restaurants.InfoBubble.UnansweredReviews._1
            } else {
                self.infoText = Localizable.Restaurants.InfoBubble.UnansweredReviews.many(unrepliedCount)
            }
        } else {
            self.infoText = nil
        }
    }

}
