//
//  RestaurantsPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import Combine

protocol RestaurantsViewInput: AlertDisplayable, LoaderDisplayable {
    func confugureOwnerState()
    func setup(state: RestaurantsViewState)
}

final class RestaurantsPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: RestaurantsViewInput?

    var onSelectRestaurant: Closure<RestaurantResponseModel>?
    var onAddRestaurant: EmptyClosure?
    var onLogOut: EmptyClosure?

    // MARK: - Private Properties

    private let userRole = KeychainService().getUserRole()

    private let restaurantsService: RestaurantsServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    private var restaurantsModels: [RestaurantResponseModel] = []

    // MARK: - Init

    init(restaurantsService: RestaurantsServiceProtocol) {
        self.restaurantsService = restaurantsService
    }

    // MARK: - Methods

    func updateRestaurants() {
        self.view?.setup(state: .loading)
        self.reloadRestaurants()
    }
    
}

// MARK: - RestaurantsViewOutput

extension RestaurantsPresenter: RestaurantsViewOutput {

    func viewDidLoad() {
        if self.userRole == .owner {
            self.view?.confugureOwnerState()
        }
        self.view?.setup(state: .loading)
    }

    func viewWillAppear() {
        self.reloadRestaurants()
    }

    func didSelectReload() {
        self.view?.setup(state: .loading)
        self.reloadRestaurants()
    }

    func didSelectRestaurant(with id: Int) {
        guard let restaurantModel = self.restaurantsModels.first(where: { $0.id == id }) else {
            self.view?.showSomethingWentWrongAlert()
            self.view?.setup(state: .error)
            return
        }
        self.onSelectRestaurant?(restaurantModel)
    }

    func didSelectAddRestaurant() {
        self.onAddRestaurant?()
    }

    func didSelectLogOut() {
        KeychainService().clearUser()
        self.onLogOut?()
    }

}

// MARK: - Private Methods

private extension RestaurantsPresenter {

    func reloadRestaurants() {
        self.restaurantsService.getRestaurants()
            .sink { completion in
                self.handle(completion: completion, view: self.view)
                if case .failure = completion {
                    self.view?.setup(state: .error)
                }
            } receiveValue: { response in
                self.handleSuccess(response: response)
            }.store(in: &subscriptions)
    }

    func handleSuccess(response: [RestaurantResponseModel]) {
        self.restaurantsModels = response
        let isShowingInfo = self.userRole == .owner
        let viewModels = response
            .sorted(by: { $0.averageRate ?? 0 > $1.averageRate ?? 0 })
            .map { RestaurantCellViewModel(with: $0, isShowingInfo: isShowingInfo) }
        self.view?.setup(state: .normal(viewModels))
    }

}
