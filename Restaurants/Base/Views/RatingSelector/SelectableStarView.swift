//
//  SelectableStarView.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

final class SelectableStarView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let starWidth: CGFloat = 30
    }

    // MARK: - Views

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.emptyStar.image
        return imageView
    }()
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    // MARK: - Properties

    var onStarSelected: EmptyClosure?

    // MARK: - Private Properties

    private var isSelected = false

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func set(isSelected: Bool) {
        self.isSelected = isSelected
        self.starImageView.image = self.isSelected ? Asset.star.image : Asset.emptyStar.image
    }

}

// MARK: - Actions

private extension SelectableStarView {

    @objc
    func didToggle() {
        self.onStarSelected?()
    }

}

// MARK: - Private Methods

private extension SelectableStarView {

    func setupInitial() {
        self.configureStarView()
        self.configureAction()
    }

    func configureStarView() {
        self.addSubview(self.starImageView)
        self.starImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(Constants.starWidth)
        }
    }

    func configureAction() {
        self.actionButton.addTarget(self, action: #selector(self.didToggle), for: .touchUpInside)

        self.addSubview(self.actionButton)
        self.actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
