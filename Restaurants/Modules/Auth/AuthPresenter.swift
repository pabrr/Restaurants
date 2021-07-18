//
//  AuthPresenter.swift
//  Restaurants
//
//  Created by Полина Полухина on 22.06.2021.
//

import Foundation
import Combine

protocol AuthViewInput: AlertDisplayable, LoaderDisplayable {
    func configureState(isRegister: Bool)
    func setupLoadingState()
}

final class AuthPresenter: BaseResponseHandlerProtocol {

    // MARK: - Properties

    weak var view: AuthViewInput?

    var onRestaurantsShow: EmptyClosure?
    var onAdminFlowShow: EmptyClosure?

    // MARK: - Private Properties

    private let isRegister: Bool

    private let authService: AuthServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    private var isOwner = false
    private var login: String?
    private var password: String?

    // MARK: - Init

    init(login: String? = nil, password: String? = nil, authService: AuthServiceProtocol) {
        self.isRegister = false

        self.login = login
        self.password = password

        self.authService = authService
    }

    init(isRegister: Bool, authService: AuthServiceProtocol) {
        self.isRegister = isRegister

        self.authService = authService
    }

}

// MARK: - AuthViewOutput

extension AuthPresenter: AuthViewOutput {

    func viewDidLoad() {
        self.view?.configureState(isRegister: self.isRegister)

        if let login = self.login,
           let password = self.password {
            self.view?.setupLoadingState()
            self.loginUser(login: login, password: password)
            return
        }
    }

    func didSwitchRole(isOwner: Bool) {
        self.isOwner = isOwner
    }

    func didSelectContinue(login: String, password: String) {
        self.login = login
        self.password = password

        guard !login.isEmpty,
            !password.isEmpty else {
            self.view?.showOkAlert(title: Localizable.Auth.Error.EmptyData.title, subtitle: Localizable.Auth.Error.EmptyData.subtitle)
            return
        }

        self.view?.setupLoadingState()
        isRegister ?
            self.registerUser(login: login, password: password, isOwner: self.isOwner) :
            self.loginUser(login: login, password: password)
    }

}

// MARK: - Private Methods

private extension AuthPresenter {

    func loginUser(login: String, password: String) {
        self.authService.auth(with: login, password: password)
            .sink { completion in
                if case .failure(.unauthorized) = completion {
                    self.handleUnauthorizedErrorOnAuth()
                } else {
                    self.handle(completion: completion, view: self.view)
                }
            } receiveValue: { response in
                self.handleSuccess(response)
            }.store(in: &subscriptions)
    }

    func registerUser(login: String, password: String, isOwner: Bool) {
        self.authService.register(with: login, password: password, isOwner: isOwner)
            .sink { completion in
                self.handle(completion: completion, view: self.view)
            } receiveValue: { response in
                self.handleSuccess(response)
            }.store(in: &subscriptions)
    }

    func handleSuccess(_ response: AuthResponseModel) {
        KeychainService().save(login: self.login ?? "", password: self.password ?? "")
        KeychainService().save(userRole: response.role)
        KeychainService().save(accessToken: response.accessToken)

        if response.role == .admin {
            self.onAdminFlowShow?()
        } else {
            self.onRestaurantsShow?()
        }
    }

    func handleUnauthorizedErrorOnAuth() {
        self.view?.stopLoading()
        self.view?.showOkAlert(title: Localizable.Auth.Error.Incorrect.title, subtitle: Localizable.Auth.Error.Incorrect.subtitle)
    }

}
