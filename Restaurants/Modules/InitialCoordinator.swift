//
//  InitialCoordinator.swift
//  Restaurants
//
//  Created by Полина Полухина on 22.06.2021.
//

import UIKit

final class InitialCoordinator {

    // MARK: - Private Properties

    private var navigationController: UINavigationController?
    private let adminCoordinator = AdminCoordinator()

    // MARK: - Methods

    func start() -> UIViewController {
        self.navigationController = self.getInitialFlow() as? UINavigationController
        return self.navigationController ?? UINavigationController()
    }

}

// MARK: - Private Methods

private extension InitialCoordinator {

    func getInitialFlow() -> UIViewController {
        let controller = InitialViewController()

        controller.onTryLogin = { [weak self] (login, password) in
            self?.showAuthLoginFlow(login, password)
        }
        controller.onLogin = { [weak self] in
            self?.showAuthLogin(isRegister: false)
        }
        controller.onRegister = { [weak self] in
            self?.showAuthLogin(isRegister: true)
        }

        return UINavigationController(rootViewController: controller)
    }

    func showAuthLoginFlow(_ login: String, _ password: String) {
        let controller = AuthViewController()
        let presenter = AuthPresenter(login: login, password: password, authService: AuthService())

        presenter.onRestaurantsShow = { [weak self] in
            self?.showRestaurants()
        }
        presenter.onAdminFlowShow = { [weak self] in
            self?.goToAdmin()
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showAuthLogin(isRegister: Bool) {
        let controller = AuthViewController()
        let presenter = AuthPresenter(isRegister: isRegister, authService: AuthService())

        presenter.onRestaurantsShow = { [weak self] in
            self?.showRestaurants()
        }
        presenter.onAdminFlowShow = { [weak self] in
            self?.goToAdmin()
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showRestaurants() {
        let controller = RestaurantsViewController()
        let presenter = RestaurantsPresenter(restaurantsService: RestaurantsService())

        presenter.onSelectRestaurant = { [weak self] restaurant in
            self?.showRestaurant(restaurant: restaurant)
        }
        presenter.onAddRestaurant = { [weak self] in
            self?.addRestaurant() {
                presenter.updateRestaurants()
            }
        }
        presenter.onLogOut = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func addRestaurant(didAdd: EmptyClosure?) {
        let controller = NewRestaurantViewController()
        let presenter = NewRestaurantPresenter(restaurantsService: RestaurantsService())

        presenter.onChangedRestaurant = { [weak self] in
            didAdd?()
            self?.navigationController?.popViewController(animated: true)
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showRestaurant(restaurant: RestaurantResponseModel) {
        let controller = RestaurantViewController()
        let presenter = RestaurantPresenter(restaurant: restaurant, restaurantService: RestaurantsService())

        presenter.onSelectLeaveComment = { [weak self] restaurant in
            self?.showReview(restaurant: restaurant, didEdited: {
                presenter.updateComments()
            })
        }
        presenter.onSelectLeaveReply = { [weak self] reviewData in
            self?.showReply(restaurant: reviewData.0, review: reviewData.1, comment: nil) {
                presenter.updateComments()
            }
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showReview(restaurant: RestaurantResponseModel, didEdited: EmptyClosure?) {
        let controller = ReviewViewController()
        let presenter = ReviewPresenter(restaurant: restaurant, reviewsService: ReviewsService())

        presenter.onSavedReview = { [weak self] in
            didEdited?()
            self?.navigationController?.popViewController(animated: true)
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func showReply(restaurant: RestaurantResponseModel, review: ReviewResponseModel, comment: Any?, didEdited: EmptyClosure?) {
        let controller = ReplyViewController()
        let presenter = ReplyPresenter(restaurant: restaurant, review: review, reviewsService: ReviewsService())

        presenter.onEditReview = { [weak self] in
            didEdited?()
            self?.navigationController?.popViewController(animated: true )
        }

        controller.output = presenter
        presenter.view = controller

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func goToAdmin() {
        self.adminCoordinator.start(with: self.navigationController)
    }

}
