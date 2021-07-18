//
//  BaseError.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

enum BaseError: Error {
    case wrongUrl
    case error(message: String)
    case badServerResponse
    case unknowned(error: Error?)
    case unauthorized
}
