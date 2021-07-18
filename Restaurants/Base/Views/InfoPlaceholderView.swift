//
//  InfoPlaceholderView.swift
//  Restaurants
//
//  Created by Полина Полухина on 03.07.2021.
//

import UIKit

final class InfoPlaceholderView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let labelButtonBetweenInset: CGFloat = 8
    }

    // MARK: - Views

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = Localizable.Placeholder.description
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let reloadButton = DefaultButton(title: Localizable.Placeholder.Reload.buttonTitle)

    // MARK: - Properties

    var onReload: EmptyClosure?

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Actions

extension InfoPlaceholderView {

    @objc
    func didSelectReload() {
        self.onReload?()
    }

}

// MARK: - Private Methods

private extension InfoPlaceholderView {

    func setupInitial() {
        self.backgroundColor = .white

        self.configureDescription()
        self.configureReloadButton()
    }

    func configureDescription() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }

    func configureReloadButton() {
        self.reloadButton.addTarget(self, action: #selector(self.didSelectReload), for: .touchUpInside)

        self.addSubview(self.reloadButton)
        self.reloadButton.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).inset(-Constants.labelButtonBetweenInset)
            make.left.right.bottom.equalToSuperview()
        }
    }

}
