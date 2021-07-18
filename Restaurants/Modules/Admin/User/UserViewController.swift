//
//  UserViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import UIKit

protocol UserViewOutput {
    func viewDidLoad()
    func didSelectUpdate(model: UserViewModel)
    func didSelectDeleteUser()
}

final class UserViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let defaultSideInset: CGFloat = 20
        static let idTag = 1
        static let loginTag = 2
        static let textFieldHeight: CGFloat = 44
    }

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Constants.defaultSideInset
        return stackView
    }()
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .black
        textField.tag = Constants.loginTag
        textField.placeholder = Localizable.User.Login.placeholder
        return textField
    }()
    private let roleSelector = RoleSelectorView()

    // MARK: - Properties

    var output: UserViewOutput?

    // MARK: - Private Properties

    private var user: UserViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

}

// MARK: - UserViewInput

extension UserViewController: UserViewInput {

    func configure(user: UserViewModel) {
        self.user = user

        let idTextField = UITextField()
        idTextField.tintColor = .black
        idTextField.tag = Constants.idTag
        idTextField.text = user.id != nil ? "\(user.id ?? 0)" : ""
        idTextField.placeholder = Localizable.User.Id.placeholder
        idTextField.keyboardType = .numberPad
        idTextField.isEnabled = true
        self.stackView.addArrangedSubview(idTextField)

        self.loginTextField.text = user.login
        self.stackView.addArrangedSubview(self.loginTextField)

        self.stackView.arrangedSubviews.forEach { view in
            view.snp.makeConstraints { make in
                make.height.equalTo(Constants.textFieldHeight)
                make.left.right.equalToSuperview()
            }
        }

        self.roleSelector.configure(with: user.userRole == .owner)
    }

}

// MARK: - Actions

extension UserViewController {

    @objc
    func didSelectSaveChanges() {
        self.user?.login = self.loginTextField.text ?? ""
        guard let user = self.user else {
            return
        }
        self.output?.didSelectUpdate(model: user)
    }

    @objc
    func didSelectDelete() {
        self.output?.didSelectDeleteUser()
    }

}

// MARK: - Private Methods

private extension UserViewController {

    func setupInitial() {
        self.view.backgroundColor = .white
        self.title = Localizable.User.title
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backButtonTitle = " "

        self.configureStackView()
        self.configureRoleSelector()
        self.configureBarItems()
    }

    func configureStackView() {
        self.view.addSubview(self.stackView)

        self.stackView.snp.makeConstraints { make in
            make.topMargin.equalTo(Constants.defaultSideInset)
            make.left.equalTo(Constants.defaultSideInset)
            make.right.equalTo(-Constants.defaultSideInset)
        }
    }

    func configureRoleSelector() {
        self.roleSelector.onToggleRole = { [weak self] isOwner in
            self?.user?.userRole = isOwner ? .owner : .user
        }

        self.view.addSubview(self.roleSelector)
        self.roleSelector.snp.makeConstraints { make in
            make.top.equalTo(self.stackView.snp.bottom).inset(-Constants.defaultSideInset)
            make.left.equalTo(Constants.defaultSideInset)
            make.right.equalTo(-Constants.defaultSideInset)
        }
    }

    func configureBarItems() {
        let saveChangesItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didSelectSaveChanges))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.didSelectDelete))
        self.navigationItem.rightBarButtonItems = [saveChangesItem, deleteItem]
    }

}
