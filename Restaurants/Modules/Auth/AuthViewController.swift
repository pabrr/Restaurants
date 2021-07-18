//
//  AuthViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 22.06.2021.
//

import UIKit

protocol AuthViewOutput {
    func viewDidLoad()
    func didSwitchRole(isOwner: Bool)
    func didSelectContinue(login: String, password: String)
}

final class AuthViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let textFieldSideInset: CGFloat = 20
        static let textFieldHeight: CGFloat = 44

        static let loginTopInset: CGFloat = 20
        static let passwordTopInset: CGFloat = 10

        static let roleSelectorTopInset: CGFloat = 24
        static let roleSelectorSideInset: CGFloat = 12

        static let continueButtonTopInset: CGFloat = 20
        static let continueButtonHeight: CGFloat = 44
        static let continueButtonSideInset: CGFloat = 20

        static let maxLoginLength = 50
        static let maxPasswordLength = 50
    }

    // MARK: - Views

    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.Auth.Login.placeholder
        textField.keyboardType = .asciiCapable
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localizable.Auth.Password.placeholder
        textField.keyboardType = .asciiCapable
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    private let roleSelector = RoleSelectorView()
    private let continueButton = DefaultButton(title: Localizable.Auth.Continue.buttonTitle)

    // MARK: - Properties

    var output: AuthViewOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.loginTextField.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.stopLoading()
    }

}

// MARK: - AuthViewInput

extension AuthViewController: AuthViewInput {

    func configureState(isRegister: Bool) {
        self.title = isRegister ? Localizable.Auth.Register.title : Localizable.Auth.Login.title
        self.roleSelector.isHidden = !isRegister

        let bottomConstraint = isRegister ? self.roleSelector.snp.bottom : self.passwordTextField.snp.bottom
        self.continueButton.snp.makeConstraints { make in
            make.top.equalTo(bottomConstraint).inset(-Constants.continueButtonTopInset)
        }
    }

    func setupLoadingState() {
        self.view.endEditing(true)
        self.showLoading()
    }

}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }

        if string.isEmpty {
            return true
        }

        if textField == self.loginTextField {
            return textField.text?.count ?? 0 < Constants.maxLoginLength
        }
        if textField == self.passwordTextField {
            return textField.text?.count ?? 0 < Constants.maxPasswordLength
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.didSelectContinue()
        }
        return true
    }

}

// MARK: - Actions

private extension AuthViewController {

    @objc
    func didSelectContinue() {
        self.output?.didSelectContinue(login: self.loginTextField.text ?? "", password: self.passwordTextField.text ?? "")
    }

}

// MARK: - Private Methods

private extension AuthViewController {

    func setupInitial() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black

        self.configureLoginField()
        self.configurePasswordField()
        self.configureRoleSelector()
        self.configureContinueButton()
    }

    func configureLoginField() {
        self.loginTextField.delegate = self

        self.view.addSubview(self.loginTextField)
        self.loginTextField.snp.makeConstraints { make in
            make.topMargin.equalTo(Constants.loginTopInset)
            make.left.equalTo(Constants.textFieldSideInset)
            make.right.equalTo(-Constants.textFieldSideInset)
            make.height.equalTo(Constants.textFieldHeight)
        }
    }

    func configurePasswordField() {
        self.passwordTextField.delegate = self

        self.view.addSubview(self.passwordTextField)
        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.loginTextField.snp.bottom).inset(-Constants.passwordTopInset)
            make.left.equalTo(Constants.textFieldSideInset)
            make.right.equalTo(-Constants.textFieldSideInset)
            make.height.equalTo(Constants.textFieldHeight)
        }
    }

    func configureRoleSelector() {
        self.roleSelector.onToggleRole = { [weak self] isOwner in
            self?.output?.didSwitchRole(isOwner: isOwner)
        }

        self.view.addSubview(self.roleSelector)
        self.roleSelector.snp.makeConstraints { make in
            make.top.equalTo(self.passwordTextField.snp.bottom).inset(-Constants.roleSelectorTopInset)
            make.left.equalTo(Constants.roleSelectorSideInset)
            make.right.equalTo(-Constants.roleSelectorSideInset)
        }
    }

    func configureContinueButton() {
        self.continueButton.addTarget(self, action: #selector(self.didSelectContinue), for: .touchUpInside)

        self.view.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.continueButtonHeight)
            make.left.equalTo(Constants.continueButtonSideInset)
            make.right.equalTo(-Constants.continueButtonSideInset)
        }
    }

}
