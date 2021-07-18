//
//  InitialViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

final class InitialViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let titleSideInset: CGFloat = 40

        static let loginButtonTopInset: CGFloat = 32
        static let buttonHeight: CGFloat = 44
        static let buttonSideInset: CGFloat = 20
        static let buttonBetweenInset: CGFloat = 10
    }

    // MARK: - Views

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Localizable.Initial.title
        return label
    }()
    private let loginButton = DefaultButton(title: Localizable.Initial.Login.buttonTitle)
    private let registerButton = DefaultButton(title: Localizable.Initial.Register.buttonTitle)

    // MARK: - Properties

    var onTryLogin: ((String, String) -> Void)?
    var onLogin: EmptyClosure?
    var onRegister: EmptyClosure?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.loginIfNecessary()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

// MARK: - Actions

private extension InitialViewController {

    @objc
    func didSelectLogin() {
        self.onLogin?()
    }

    @objc
    func didSelectRegister() {
        self.onRegister?()
    }

}

// MARK: - Private Methods

private extension InitialViewController {

    func setupInitial() {
        self.view.backgroundColor = .white
        self.navigationItem.backButtonTitle = " "

        self.configureContainerView()
        self.configureTitle()
        self.configureLoginButton()
        self.configureRegisterButton()
    }

    func configureContainerView() {
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configureTitle() {
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(Constants.titleSideInset)
            make.right.equalTo(-Constants.titleSideInset)
        }
    }

    func configureLoginButton() {
        self.loginButton.addTarget(self, action: #selector(self.didSelectLogin), for: .touchUpInside)

        self.containerView.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-Constants.loginButtonTopInset)
            make.left.equalTo(Constants.buttonSideInset)
            make.right.equalTo(-Constants.buttonSideInset)
            make.height.equalTo(Constants.buttonHeight)
        }
    }

    func configureRegisterButton() {
        self.registerButton.addTarget(self, action: #selector(self.didSelectRegister), for: .touchUpInside)

        self.containerView.addSubview(self.registerButton)
        self.registerButton.snp.makeConstraints { make in
            make.top.equalTo(self.loginButton.snp.bottom).inset(-Constants.buttonBetweenInset)
            make.left.equalTo(Constants.buttonSideInset)
            make.right.equalTo(-Constants.buttonSideInset)
            make.height.equalTo(Constants.buttonHeight)
            make.bottom.equalToSuperview()
        }
    }

    func loginIfNecessary() {
        if let (login, password) = KeychainService().getLoginPassword() {
            self.onTryLogin?(login, password)
        }
    }

}
