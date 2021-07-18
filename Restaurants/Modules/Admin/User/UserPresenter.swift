//
//  UserPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Foundation
import Combine

protocol UserViewInput: LoaderDisplayable, AlertDisplayable {
    func configure(user: UserViewModel)
}

final class UserPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: UserViewInput?

    var onUserChanged: EmptyClosure?

    // MARK: - Private Properties

    private var user: UserResponseModel

    private let usersService: UserServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(user: UserResponseModel, usersService: UserServiceProtocol) {
        self.user = user
        self.usersService = usersService
    }

}

// MARK: - UserViewOutput

extension UserPresenter: UserViewOutput {

    func viewDidLoad() {
        let viewModel = UserViewModel(with: self.user)
        self.view?.configure(user: viewModel)
    }

    func didSelectUpdate(model: UserViewModel) {
        if self.user.username == model.login &&
            self.user.role == model.userRole.rawValue {
            self.view?.showOkAlert(title: nil, subtitle: Localizable.User.SaveError.NoChanges.description)
            return
        }
        self.user.username = model.login
        self.user.role = model.userRole.rawValue
        if self.user.username.isEmpty {
            self.view?.showOkAlert(title: Localizable.User.SaveError.EmptyValue.title,
                                   subtitle: Localizable.User.SaveError.EmptyValue.description)
            return
        }

        self.view?.showLoading()
        self.updateUser()
    }

    func didSelectDeleteUser() {
        self.view?.showLoading()
        self.deleteUser()
    }

}

// MARK: - Private Methods

private extension UserPresenter {

    func updateUser() {
        self.usersService.updateUser(self.user)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { _ in
                self.onUserChanged?()
            }.store(in: &subscriptions)
    }

    func deleteUser() {
        self.usersService.deleteUser(with: self.user.id)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { _ in
                self.onUserChanged?()
            }.store(in: &subscriptions)
    }

}
