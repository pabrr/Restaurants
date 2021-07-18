//
//  ReviewsService.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Combine

final class ReviewsService: NetworkProtocol, ReviewsServiceProtocol {

    // MARK: - Endpoints

    private enum Endpoints {
        case reviews
        case reply

        var urlString: String {
            switch self {
            case .reviews: return "/reviews"
            case .reply: return "/reviews/%@/reply"
            }
        }
    }

    // MARK: - ReviewsServiceProtocol

    func saveReview(with model: ReviewRequestModel) -> AnyPublisher<Void, BaseError> {
        let urlString = Urls.baseUrl + Endpoints.reviews.urlString
        return self.loadAuthorized(urlString: urlString, method: .post, bodyParameters: model)
    }

    func addReply(to reviewId: String, with model: ReplyRequestModel) -> AnyPublisher<Void, BaseError> {
        let urlString = Urls.baseUrl + String(format: Endpoints.reply.urlString, arguments: [reviewId])
        return self.loadAuthorized(urlString: urlString, method: .post, bodyParameters: model)
    }

}
