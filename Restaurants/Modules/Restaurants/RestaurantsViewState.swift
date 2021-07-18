//
//  RestaurantsViewState.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

enum RestaurantsViewState {
    case loading
    case error
    case normal([RestaurantCellViewModel])
}
