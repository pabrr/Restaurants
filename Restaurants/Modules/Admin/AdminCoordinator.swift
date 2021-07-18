//
//  AdminCoordinator.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

import UIKit

final class AdminCoordinator {

    // MARK: - Private Properties

    private var navigationController: UINavigationController?

    private let tabController = UITabBarController()

    // MARK: - Methods

    func start(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.configureTabs()
        self.navigationController?.present(self.tabController, animated: true, completion: nil)
    }

}

// MARK: - Private Methods

private extension AdminCoordinator {

    func configureTabs() {
        let usersTab = self.getUsers()
        usersTab.tabBarItem = UITabBarItem(title: Localizable.Users.title, image: nil, tag: 0)

        let restaurantsTab = self.getRestaurants()
        restaurantsTab.tabBarItem = UITabBarItem(title: Localizable.Restaurants.title, image: nil, tag: 1)

        self.tabController.viewControllers = [
            usersTab,
            restaurantsTab
        ]

        self.tabController.tabBar.tintColor = .black
        self.tabController.modalPresentationStyle = .fullScreen
    }

    func getUsers() -> UIViewController {
        let controller = UsersViewController()
        let presenter = UsersPresenter(usersService: UserService())

        presenter.onSelectUser = { [weak self] user in
            self?.showUser(user: user) {
                presenter.updateUsers()
            }
        }
        presenter.onSelectLogOut = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }

        controller.output = presenter
        presenter.view = controller

        return UINavigationController(rootViewController: controller)
    }

    func showUser(user: UserResponseModel, didEdited: EmptyClosure?) {
        let controller = UserViewController()
        let presenter = UserPresenter(user: user, usersService: UserService())

        presenter.onUserChanged = { [weak self] in
            didEdited?()
            (self?.tabController.viewControllers?[0] as? UINavigationController)?.popViewController(animated: true)
        }

        controller.output = presenter
        presenter.view = controller

        (self.tabController.viewControllers?[0] as? UINavigationController)?.pushViewController(controller, animated: true)
    }

    func getRestaurants() -> UIViewController {
        let controller = RestaurantsViewController()
        let presenter = RestaurantsPresenter(restaurantsService: RestaurantsService())

        presenter.onSelectRestaurant = { [weak self] restaurant in
            self?.showRestaurant(restaurant: restaurant) {
                presenter.updateRestaurants()
            }
        }
        presenter.onLogOut = { [weak self] in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }

        controller.output = presenter
        presenter.view = controller

        return UINavigationController(rootViewController: controller)
    }

    func showRestaurant(restaurant: RestaurantResponseModel, didEdited: EmptyClosure?) {
        let controller = NewRestaurantViewController()
        let presenter = NewRestaurantPresenter(restaurant: restaurant, restaurantsService: RestaurantsService())

        presenter.onChangedRestaurant = { [weak self] in
            didEdited?()
            (self?.tabController.viewControllers?[1] as? UINavigationController)?.popViewController(animated: true)
        }

        controller.output = presenter
        presenter.view = controller

        (self.tabController.viewControllers?[1] as? UINavigationController)?.pushViewController(controller, animated: true)
    }

}
