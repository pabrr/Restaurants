//
//  RestaurantDetailView.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

final class RestaurantDetailView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let containerSideInset: CGFloat = 20
        static let containerCornerRadius: CGFloat = 16

        static let imageViewHeight: CGFloat = 200

        static let ratingContainerRadius: CGFloat = 8

        static let ratingIconLeftInset: CGFloat = 8
        static let ratingIconWidth: CGFloat = 32
        static let ratingIconLabelInset: CGFloat = 10

        static let ratingLabelTopInset: CGFloat = 6
        static let ratingLabelBottomInset: CGFloat = 8
        static let ratingLabelRightInset: CGFloat = 8

        static let descriptionTopInset: CGFloat = 10
        static let descriptionSideInset: CGFloat = 20
        static let descriptionBottomInset: CGFloat = 20

        static let commentButtonTopInset: CGFloat = 8
        static let commentButtonSideInset: CGFloat = 20
        static let commentButtonBottomInset: CGFloat = 20
    }

    // MARK: - Views

    private let containerView: UIView = {
        let view = UIView()
        view.roundCorners(Constants.containerCornerRadius)
        return view
    }()
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        return imageView
    }()
    private let ratingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.star.image
        return imageView
    }()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 34)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private let commentButton = DefaultButton(title: Localizable.Restaurant.LeaveComment.buttonTitle)

    // MARK: - Properties

    var onCommentSelected: EmptyClosure?

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with model: RestaurantDetailViewModel) {
        self.ratingLabel.text = model.rating
        self.descriptionLabel.text = model.description

        if let imageUrlString = model.imageUrlString,
           let url = URL(string: imageUrlString) {
            self.restaurantImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                self?.restaurantImageView.image = image
            }
        }

        self.commentButton.isHidden = !model.hasCommentButton
        if model.hasCommentButton {
            self.commentButton.snp.makeConstraints { make in
                make.bottom.equalTo(-Constants.commentButtonBottomInset)
            }
        } else {
            self.descriptionLabel.snp.makeConstraints { make in
                make.bottom.equalTo(-Constants.descriptionBottomInset)
            }
        }
    }

}

// MARK: - Actions

private extension RestaurantDetailView {

    @objc
    func didSelectComment() {
        self.onCommentSelected?()
    }

}

// MARK: - Private Methods

private extension RestaurantDetailView {

    func setupInitial() {
        self.backgroundColor = .white

        self.configureContainerView()
        self.configureRestaurantImageView()
        self.configureRatingView()
        self.configureDescription()
        self.configureCommentButton()
    }

    func configureContainerView() {
        self.addSubview(self.containerView)

        self.containerView.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.containerSideInset)
            make.right.equalTo(-Constants.containerSideInset)
            make.height.equalTo(Constants.imageViewHeight)
        }
    }

    func configureRestaurantImageView() {
        self.containerView.addSubview(self.restaurantImageView)

        self.restaurantImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureRatingView() {
        let ratingView = UIView()
        ratingView.backgroundColor = .white
        ratingView.roundCorners(Constants.ratingContainerRadius)

        self.containerView.addSubview(ratingView)
        ratingView.snp.makeConstraints { make in
            make.right.bottom.equalTo(Constants.ratingContainerRadius)
        }

        ratingView.addSubview(self.ratingIconImageView)
        self.ratingIconImageView.snp.makeConstraints { make in
            make.left.equalTo(Constants.ratingIconLeftInset)
            make.width.height.equalTo(Constants.ratingIconWidth)
            make.centerY.equalToSuperview().inset(Constants.ratingContainerRadius)
        }

        ratingView.addSubview(self.ratingLabel)
        self.ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(Constants.ratingLabelTopInset)
            make.left.equalTo(self.ratingIconImageView.snp.right).offset(Constants.ratingIconLabelInset)
            make.bottom.equalTo(-Constants.ratingLabelBottomInset)
            make.right.equalTo(-Constants.ratingLabelRightInset)
        }
    }

    func configureDescription() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.containerView.snp.bottom).inset(-Constants.descriptionTopInset)
            make.left.equalTo(Constants.descriptionSideInset)
            make.right.equalTo(-Constants.descriptionSideInset)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configureCommentButton() {
        self.commentButton.isHidden = true
        self.commentButton.addTarget(self, action: #selector(self.didSelectComment), for: .touchUpInside)

        self.addSubview(self.commentButton)
        self.commentButton.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).inset(-Constants.commentButtonTopInset)
            make.left.equalTo(Constants.commentButtonSideInset)
            make.right.equalTo(-Constants.commentButtonSideInset)
        }
    }

}
