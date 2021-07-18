//
//  RestaurantPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import Foundation
import Combine

protocol RestaurantViewInput: AlertDisplayable, LoaderDisplayable {
    func configure(with model: RestaurantViewModel)
    func setupLoadingState()
    func setup(reviews: [ReviewCellViewModel])
}

final class RestaurantPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: RestaurantViewInput?

    var onSelectLeaveComment: Closure<RestaurantResponseModel>?
    var onSelectLeaveReply: Closure<(RestaurantResponseModel, ReviewResponseModel)>?

    // MARK: - Private Properties

    private var reviews: [ReviewResponseModel] = []

    private var restaurantModel: RestaurantResponseModel
    private let userRole = KeychainService().getUserRole()

    private let restaurantService: RestaurantsServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(restaurant: RestaurantResponseModel, restaurantService: RestaurantsServiceProtocol) {
        self.restaurantModel = restaurant
        self.restaurantService = restaurantService
    }

    // MARK: - Methods

    func updateComments() {
        self.view?.setupLoadingState()
        self.loadComments()
    }

}

// MARK: - RestaurantViewOutput

extension RestaurantPresenter: RestaurantViewOutput {

    func viewDidLoad() {
        self.updateRestaurantInfo()
        self.view?.setupLoadingState()
        self.loadComments()
    }

    func didSelectLeaveComment() {
        self.onSelectLeaveComment?(self.restaurantModel)
    }

    func didSelectReply(to commentId: Int) {
        guard let review = self.reviews.first(where: { $0.id == commentId }) else {
            return
        }
        self.onSelectLeaveReply?((self.restaurantModel, review))
    }

}

// MARK: - Private Methods

private extension RestaurantPresenter {

    func loadComments() {
        self.restaurantService.getRestaurantDetails(for: self.restaurantModel.id)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { restaurantModel in
                self.handleSuccessLoading(restaurantModel: restaurantModel)
            }.store(in: &subscriptions)
    }

    func handleSuccessLoading(restaurantModel: RestaurantResponseModel) {
        self.restaurantModel = restaurantModel
        self.updateRestaurantInfo()
        self.reviews = restaurantModel.reviews ?? []
        let isSelectable = self.userRole == .owner
        var sortedReviews = restaurantModel.reviews?.sorted(by: { $0.rate > $1.rate }) ?? []
        if sortedReviews.count > 1 {
            let highestReview = sortedReviews.removeFirst()
            let lowestReview = sortedReviews.removeLast()
            sortedReviews.insert(contentsOf: [highestReview, lowestReview], at: 0)
        }
        let reviews = sortedReviews.compactMap { ReviewCellViewModel(with: $0, isSelectable: isSelectable) }
        self.view?.setup(reviews: reviews)
    }

    func updateRestaurantInfo() {
        let restaurantViewModel = RestaurantDetailViewModel(model: self.restaurantModel, hasCommentButton: self.userRole == .user)
        let model = RestaurantViewModel(title: self.restaurantModel.name,
                                        isReviewsSelectable: self.userRole == .owner,
                                        detailModel: restaurantViewModel)
        self.view?.configure(with: model)
    }

}
