//
//  RoleSelectorView.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

final class RoleSelectorView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let checkboxWidth: CGFloat = 28
        static let descriptionLeftInset: CGFloat = 10
        static let sideInset: CGFloat = 14
    }

    // MARK: - Views

    private let checkboxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.uncheck.image
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = Localizable.Auth.roleDescription
        return label
    }()
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    // MARK: - Properties

    var onToggleRole: BoolClosure?

    // MARK: - Private Properties

    private var isToggled = false

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with isOwner: Bool) {
        if isOwner {
            self.didToggle()
        }
    }

}

// MARK: - Actions

private extension RoleSelectorView {

    @objc
    func didToggle() {
        self.isToggled.toggle()
        self.checkboxImageView.image = self.isToggled ? Asset.check.image : Asset.uncheck.image
        self.onToggleRole?(self.isToggled)
    }

}

// MARK: - Private Methods

private extension RoleSelectorView {

    func setupInitial() {
        self.backgroundColor = .white

        self.configureCheckbox()
        self.configureDescription()
        self.configureAction()
    }

    func configureCheckbox() {
        self.addSubview(self.checkboxImageView)
        self.checkboxImageView.snp.makeConstraints { make in
            make.left.equalTo(Constants.sideInset)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.checkboxWidth)
            make.width.equalTo(Constants.checkboxWidth)
        }
    }

    func configureDescription() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(Constants.sideInset)
            make.left.equalTo(self.checkboxImageView.snp.right).inset(-Constants.descriptionLeftInset)
            make.right.equalTo(Constants.sideInset)
            make.bottom.equalTo(-Constants.sideInset)
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
