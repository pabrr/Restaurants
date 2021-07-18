//
//  RatingSelectorView.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

final class RatingSelectorView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let starsBetweenInset: CGFloat = 10
        static let starsCount = 5
    }

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    private var starViews: [SelectableStarView] = []

    // MARK: - Private Properties

    private var rating = Constants.starsCount

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func getRating() -> Int {
        return self.rating
    }

}

// MARK: - Private Methods

private extension RatingSelectorView {

    func setupInitial() {
        self.configureStackView()
        self.configureStars()

        if let firstStar = self.starViews.first {
            self.snp.makeConstraints { make in
                make.height.equalTo(firstStar.snp.height)
            }
        }

        self.toggleStars(index: Constants.starsCount - 1)
    }

    func configureStackView() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
        }
    }

    func configureStars() {
        for i in 0..<Constants.starsCount {
            let starView = SelectableStarView()
            starView.onStarSelected = { [weak self] in
                self?.toggleStars(index: i)
            }

            self.starViews.append(starView)
            self.stackView.addArrangedSubview(starView)
        }
    }

    func toggleStars(index: Int) {
        self.rating = index + 1
        for (i, star) in self.starViews.enumerated() {
            star.set(isSelected: i <= index)
        }
    }

}
