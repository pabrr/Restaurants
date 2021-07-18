//
//  ReplyPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import Combine

protocol ReplyViewInput: AlertDisplayable, LoaderDisplayable {
    func configure(with title: String, model: UserCommentViewModel)
}

final class ReplyPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: ReplyViewInput?

    var onEditReview: EmptyClosure?

    // MARK: - Private Properties

    private let restaurant: RestaurantResponseModel
    private let review: ReviewResponseModel

    private let reviewsService: ReviewsServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(restaurant: RestaurantResponseModel, review: ReviewResponseModel, reviewsService: ReviewsServiceProtocol) {
        self.restaurant = restaurant
        self.review = review
        self.reviewsService = reviewsService
    }

}

// MARK: - ReplyViewOutput

extension ReplyPresenter: ReplyViewOutput {

    func viewDidLoad() {
        let userModel = UserCommentViewModel(rate: "\(self.review.rate)",
                                             comment: self.review.comment,
                                             dateDescription: self.review.dateOfVisit,
                                             hasInfo: false)
        self.view?.configure(with: self.restaurant.name, model: userModel)
    }

    func didFinishReply(with text: String) {
        guard !text.isEmpty else {
            self.view?.showOkAlert(title: Localizable.Reply.Error.Empty.title, subtitle: Localizable.Reply.Error.Empty.subtitle)
            return
        }
        self.view?.showLoading()
        self.saveReply(text)
    }

}

// MARK: - Private Methods

private extension ReplyPresenter {

    func saveReply(_ reply: String) {
        let model = ReplyRequestModel(reply: reply)
        self.reviewsService.addReply(to: "\(self.review.id)", with: model)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { _ in
                self.onEditReview?()
            }.store(in: &subscriptions)
    }

}
