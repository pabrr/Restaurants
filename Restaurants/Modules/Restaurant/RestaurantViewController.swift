//
//  RestaurantViewController.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import UIKit

protocol RestaurantViewOutput {
    func viewDidLoad()
    func didSelectLeaveComment()
    func didSelectReply(to commentId: Int)
}

final class RestaurantViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let tableBottomInset: CGFloat = 40
    }

    // MARK: - Views

    private let restaurantDetailView = RestaurantDetailView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.cellID)
        tableView.register(LoaderCell.self, forCellReuseIdentifier: LoaderCell.cellID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.tableBottomInset, right: 0)
        return tableView
    }()

    // MARK: - Properties

    var output: RestaurantViewOutput?

    // MARK: - Private Properties

    private var reviews: [ReviewCellViewModel] = []
    private var isReviewsSelectable = false

    private var isLoading = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInitial()
        self.output?.viewDidLoad()
    }

}

// MARK: - RestaurantViewInput

extension RestaurantViewController: RestaurantViewInput {

    func configure(with model: RestaurantViewModel) {
        self.title = model.title
        self.isReviewsSelectable = model.isReviewsSelectable
        self.restaurantDetailView.configure(with: model.detailModel)
    }

    func setupLoadingState() {
        self.isLoading = true
        self.reviews = []
        self.tableView.reloadData()
    }

    func setup(reviews: [ReviewCellViewModel]) {
        self.isLoading = false
        self.reviews = reviews
        self.tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource

extension RestaurantViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isLoading ? 1 : self.reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isLoading,
           let cell = tableView.dequeueReusableCell(withIdentifier: LoaderCell.cellID) as? LoaderCell {
            cell.startRotation()
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.cellID) as? ReviewCell,
              let viewModel = self.reviews[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.restaurantDetailView
    }

}

// MARK: - UITableViewDelegate

extension RestaurantViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.isReviewsSelectable,
              let cell = tableView.cellForRow(at: indexPath) as? ReviewCell else {
            return
        }
        cell.isSelected = false
        self.output?.didSelectReply(to: cell.getReviewId())
    }

}

// MARK: - Private Methods

private extension RestaurantViewController {

    func setupInitial() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backButtonTitle = " "

        self.configureDetailView()
        self.configureTableView()
    }

    func configureDetailView() {
        self.restaurantDetailView.onCommentSelected = { [weak self] in
            self?.output?.didSelectLeaveComment()
        }
    }

    func configureTableView() {
        self.view.addSubview(self.tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
