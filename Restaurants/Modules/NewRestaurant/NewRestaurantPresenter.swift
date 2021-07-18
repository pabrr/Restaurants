//
//  NewRestaurantPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

import UIKit
import Combine

protocol NewRestaurantViewInput: LoaderDisplayable, AlertDisplayable {
    func setupLoadingState()
    func setupInitialState()
    func configureAdminState(with restaurant: RestaurantResponseModel)
}

final class NewRestaurantPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: NewRestaurantViewInput?

    var onChangedRestaurant: EmptyClosure?

    // MARK: - Private Properties

    private var imageData: Data?

    private var restaurant: RestaurantResponseModel?

    private let userRole = KeychainService().getUserRole()

    private let restaurantsService: RestaurantsServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(restaurant: RestaurantResponseModel? = nil, restaurantsService: RestaurantsServiceProtocol) {
        self.restaurant = restaurant
        self.restaurantsService = restaurantsService
    }

}

// MARK: - NewRestaurantViewOutput

extension NewRestaurantPresenter: NewRestaurantViewOutput {

    func viewDidLoad() {
        if let restaurant = self.restaurant {
            self.view?.configureAdminState(with: restaurant)
        }
    }

    func didSelect(image: UIImage) {
        self.imageData = image.pngData()
    }

    func didSelectSave(with name: String, description: String) {
        guard !name.isEmpty, !description.isEmpty else {
            self.view?.showOkAlert(title: Localizable.NewRestaurant.Error.title, subtitle: Localizable.NewRestaurant.Error.subtitle)
            self.view?.setupInitialState()
            return
        }
        if self.userRole == .owner {
            if let imageData = self.imageData {
                self.view?.setupLoadingState()
                self.saveRestaurant(name: name, description: description, imageData: imageData)
            } else {
                self.view?.showOkAlert(title: Localizable.NewRestaurant.Error.title, subtitle: Localizable.NewRestaurant.Error.subtitle)
            }
        }
        if self.userRole == .admin {
            self.view?.setupLoadingState()
            self.updateRestaurant(name: name, description: description)
        }
    }

    func didSelectDelete() {
        guard let restaurantId = self.restaurant?.id else {
            return
        }
        self.view?.setupLoadingState()
        self.deleteRestaurant(with: restaurantId)
    }

}

// MARK: - Private Methods

private extension NewRestaurantPresenter {

    func saveRestaurant(name: String, description: String, imageData: Data) {
        let requestModel = RestaurantRequestModel(name: name, description: description)
        self.restaurantsService.saveRestaurant(requestModel)
            .sink { completion in
                self.view?.setupInitialState()
                self.handle(completion: completion, view: self.view)
            } receiveValue: { response in
                self.restaurantsService.uploadImage(to: response.id, imageData: imageData, completion: { [weak self] in
                    self?.handleSuccess(response)
                })
            }.store(in: &subscriptions)
    }

    func updateRestaurant(name: String, description: String) {
        let requestModel = RestaurantRequestModel(name: name, description: description)
        self.restaurantsService.updateRestaurant(with: self.restaurant?.id ?? 0, requestModel)
            .sink { completion in
                self.view?.setupInitialState()
                self.handle(completion: completion, view: self.view)
            } receiveValue: { response in
                self.handleSuccess(response)
            }.store(in: &subscriptions)
    }

    func handleSuccess(_ response: RestaurantResponseModel) {
        self.onChangedRestaurant?()
    }

    func deleteRestaurant(with id: Int) {
        self.restaurantsService.deleteRestaurant(with: id)
            .sink { completion in
                self.view?.setupInitialState()
                self.handle(completion: completion, view: self.view)
            } receiveValue: { response in
                self.onChangedRestaurant?()
            }.store(in: &subscriptions)
    }

}
