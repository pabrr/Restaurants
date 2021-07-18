//
//  UsersPresenter.swift
//  UsersPresenter
//
//  Created by Полина Полухина on 26.06.2021.
//

import Foundation
import Combine

protocol UsersViewInput: AlertDisplayable, LoaderDisplayable {
    func setup(state: UsersViewState)
}

final class UsersPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: UsersViewInput?

    var onSelectUser: Closure<UserResponseModel>?
    var onSelectLogOut: EmptyClosure?

    // MARK: - Private Properties

    private var users: [UserResponseModel] = []

    private let usersService: UserServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(usersService: UserServiceProtocol) {
        self.usersService = usersService
    }

    // MARK: - Methods

    func updateUsers() {
        self.view?.setup(state: .loading)
        self.reloadUsers()
    }

}

// MARK: - UsersViewOutput

extension UsersPresenter: UsersViewOutput {

    func viewDidLoad() {
        self.view?.setup(state: .loading)
        self.reloadUsers()
    }

    func didSelectReload() {
        self.view?.setup(state: .loading)
        self.reloadUsers()
    }

    func didSelectUser(with id: Int) {
        guard let user = self.users.first(where: { $0.id == id }) else {
            self.view?.showSomethingWentWrongAlert()
            return
        }
        self.onSelectUser?(user)
    }

    func didSelectLogOut() {
        KeychainService().clearUser()
        self.onSelectLogOut?()
    }

}

// MARK: - Private Methods

private extension UsersPresenter {

    func reloadUsers() {
        self.usersService.getUsers()
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { response in
                self.handleSuccessLoading(users: response)
            }.store(in: &subscriptions)
    }

    func handleSuccessLoading(users: [UserResponseModel]) {
        self.users = users

        let usersViewModel = users.map { UserCellViewModel(with: $0) }
        self.view?.setup(state: .normal(usersViewModel))
    }

}
