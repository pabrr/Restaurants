//
//  ReviewPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import Foundation
import Combine

protocol ReviewViewInput: AlertDisplayable, LoaderDisplayable {
    func configure(with title: String)
    func setupLoadingState()
}

final class ReviewPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: ReviewViewInput?

    var onSavedReview: EmptyClosure?

    // MARK: - Private Properties

    private var restaurant: RestaurantResponseModel

    private let reviewsService: ReviewsServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(restaurant: RestaurantResponseModel, reviewsService: ReviewsServiceProtocol) {
        self.restaurant = restaurant
        self.reviewsService = reviewsService
    }

}

// MARK: - ReviewViewOutput

extension ReviewPresenter: ReviewViewOutput {

    func viewDidLoad() {
        self.view?.configure(with: self.restaurant.name)
    }

    func didFinishReview(with text: String, rating: Int, date: Date) {
        guard !text.isEmpty else {
            self.view?.showOkAlert(title: Localizable.Review.Error.EmptyText.title, subtitle: Localizable.Review.Error.EmptyText.subtitle)
            return
        }
        self.view?.setupLoadingState()
        self.saveReview(review: text, rating: rating, date: date)
    }

}

// MARK: - Private Methods

private extension ReviewPresenter {

    func saveReview(review: String, rating: Int, date: Date) {
        let model = ReviewRequestModel(restaurantId: self.restaurant.id,
                                       comment: review,
                                       rate: rating,
                                       dateOfVisit: date.getString(.ddmmyyyyDot))
        self.reviewsService.saveReview(with: model)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { _ in
                self.onSavedReview?()
            }.store(in: &subscriptions)
    }

}
