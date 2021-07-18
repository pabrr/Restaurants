//
//  ErrorHandlerProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

protocol ErrorHandlerProtocol {
    func handleBaseError(_ error: BaseError, view: (AlertDisplayable & LoaderDisplayable)?)
}

extension ErrorHandlerProtocol {

    func handleBaseError(_ error: BaseError, view: (AlertDisplayable & LoaderDisplayable)?) {
        view?.stopLoading()
        switch error {
        case .error(message: let message):
            view?.showOkAlert(title: Localizable.Alert.SomethingWentWrong.title, subtitle: message)
        case .unauthorized:
            view?.showOkAlert(title: Localizable.Alert.Unauthorized.title, subtitle: Localizable.Alert.Unauthorized.subtitle)
            KeychainService().clearUser()
        default:
            view?.showSomethingWentWrongAlert()
        }
    }

}
