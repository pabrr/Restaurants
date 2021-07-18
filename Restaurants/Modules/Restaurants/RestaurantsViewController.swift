//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import SnapKit

protocol RestaurantsViewOutput {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectReload()
    func didSelectRestaurant(with id: Int)
    func didSelectAddRestaurant()
    func didSelectLogOut()
}

final class RestaurantsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let tableBottomInset: CGFloat = 40
        static let placeholderSideInset: CGFloat = 44
    }

    // MARK: - Views

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: RestaurantCell.cellID)
        tableView.rowHeight = RestaurantCell.cellHeight
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.tableBottomInset, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    private let placeholderView = InfoPlaceholderView()

    // MARK: - Properties

    var output: RestaurantsViewOutput?

    // MARK: - Private Properties

    private var restaurants: [RestaurantCellViewModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.output?.viewWillAppear()
    }

}

// MARK: - RestaurantsViewInput

extension RestaurantsViewController: RestaurantsViewInput {

    func confugureOwnerState() {
        self.configureAddRestaurant()
    }

    func setup(state: RestaurantsViewState) {
        switch state {
        case .loading:
            self.tableView.isHidden = true
            self.placeholderView.isHidden = true
            self.showLoading()
        case .error:
            self.stopLoading()
            self.tableView.isHidden = true
            self.placeholderView.isHidden = false
        case .normal(let restaurants):
            self.stopLoading()
            self.restaurants = restaurants
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.placeholderView.isHidden = true
        }
    }

}

// MARK: - Actions

extension RestaurantsViewController {

    @objc
    func didSelectAddRestaurant() {
        self.output?.didSelectAddRestaurant()
    }

    @objc
    func didSelectLogOut() {
        self.output?.didSelectLogOut()
    }

}

// MARK: - UITableViewDataSource

extension RestaurantsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.cellID) as? RestaurantCell,
              let viewModel = self.restaurants[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)
        cell.onSelectRestaurant = { [weak self] restaurantId in
            self?.output?.didSelectRestaurant(with: restaurantId)
        }
        return cell
    }

}

// MARK: - Private Methods

private extension RestaurantsViewController {

    func setupInitial() {
        self.view.backgroundColor = .white
        self.title = Localizable.Restaurants.title
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.backButtonTitle = " "

        self.configureTableView()
        self.configurePlaceholder()
        self.configureLogOut()
    }

    func configureTableView() {
        self.view.addSubview(self.tableView)

        self.tableView.dataSource = self

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

    func configureAddRestaurant() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.didSelectAddRestaurant))
        self.navigationItem.rightBarButtonItem = addItem
    }

}
