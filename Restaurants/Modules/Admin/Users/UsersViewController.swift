//
//  UsersViewController.swift
//  UsersViewController
//
//  Created by Полина Полухина on 26.06.2021.
//

import UIKit

protocol UsersViewOutput {
    func viewDidLoad()
    func didSelectReload()
    func didSelectUser(with id: Int)
    func didSelectLogOut()
}

final class UsersViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let tableBottomInset: CGFloat = 40
        static let placeholderSideInset: CGFloat = 44
    }

    // MARK: - Views

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.cellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.tableBottomInset, right: 0)
        return tableView
    }()
    private let placeholderView = InfoPlaceholderView()

    // MARK: - Properties

    var output: UsersViewOutput?

    // MARK: - Private Properties

    private var users: [UserCellViewModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }

}

// MARK: - UsersViewInput

extension UsersViewController: UsersViewInput {

    func setup(state: UsersViewState) {
        switch state {
        case .loading:
            self.tableView.isHidden = true
            self.placeholderView.isHidden = true
            self.showLoading()
        case .error:
            self.stopLoading()
            self.tableView.isHidden = true
            self.placeholderView.isHidden = false
        case .normal(let userModels):
            self.users = userModels
            self.stopLoading()
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.placeholderView.isHidden = true
        }
    }

}

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellID) as? UserCell,
              let viewModel = self.users[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
              let user = self.users[safe: indexPath.row] else {
            return
        }
        cell.isSelected = false
        self.output?.didSelectUser(with: user.id)
    }

}

// MARK: - Actions

extension UsersViewController {

    @objc
    func didSelectLogOut() {
        self.output?.didSelectLogOut()
    }

}

// MARK: - Private Methods

private extension UsersViewController {

    func setupInitial() {
        self.title = Localizable.Users.title
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backButtonTitle = " "

        self.configureTableView()
        self.configurePlaceholder()
        self.configureLogOut()
    }

    func configureTableView() {
        self.view.addSubview(self.tableView)

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configurePlaceholder() {
        self.placeholderView.isHidden = true
        self.placeholderView.onReload = { [weak self] in
            self?.output?.didSelectReload()
        }

        self.view.addSubview(self.placeholderView)
        self.placeholderView.snp.makeConstraints { make in
            make.left.equalTo(Constants.placeholderSideInset)
            make.right.equalTo(-Constants.placeholderSideInset)
            make.centerY.equalToSuperview()
        }
    }

    func configureLogOut() {
        let logOutItem = UIBarButtonItem(title: Localizable.Restaurants.LogOut.buttonTitle,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.didSelectLogOut))
        self.navigationItem.leftBarButtonItem = logOutItem
    }

}
