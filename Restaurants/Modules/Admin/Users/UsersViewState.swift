//
//  UsersViewState.swift
//  Restaurants
//
//  Created by Полина Полухина on 03.07.2021.
//

enum UsersViewState {
    case loading
    case error
    case normal([UserCellViewModel])
}
