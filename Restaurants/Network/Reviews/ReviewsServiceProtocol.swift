//
//  ReviewsServiceProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Combine

protocol ReviewsServiceProtocol {
    func saveReview(with model: ReviewRequestModel) -> AnyPublisher<Void, BaseError>
    func addReply(to reviewId: String, with model: ReplyRequestModel) -> AnyPublisher<Void, BaseError>
}
