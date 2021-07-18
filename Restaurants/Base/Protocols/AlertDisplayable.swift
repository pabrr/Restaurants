//
//  AlertDisplayable.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

protocol AlertDisplayable: UIViewController {
    func showOkAlert(title: String?, subtitle: String?)
    func showSomethingWentWrongAlert()
}

extension AlertDisplayable {

    func showOkAlert(title: String?, subtitle: String?) {
        let okAction = UIAlertAction(title: Localizable.Alert.Ok.buttonTitle, style: .cancel, handler: nil)

        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alertController.addAction(okAction)
        alertController.view.tintColor = .black

        self.navigationController?.present(alertController, animated: true, completion: nil)
    }

    func showSomethingWentWrongAlert() {
        self.showOkAlert(title: Localizable.Alert.SomethingWentWrong.title, subtitle: Localizable.Alert.SomethingWentWrong.subtitle)
    }

}
