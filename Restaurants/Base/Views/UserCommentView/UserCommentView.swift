//
//  UserCommentView.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

final class UserCommentView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let ratingSideInset: CGFloat = 10
        static let ratingIconWidth: CGFloat = 28

        static let ratingLabelTopInset: CGFloat = 8
        static let ratingLabelBottomInset: CGFloat = 5
        static let ratingLabelSideInset: CGFloat = 8

        static let infoWidth: CGFloat = 10

        static let dateRightInset: CGFloat = 10

        static let commentTopInset: CGFloat = 10
        static let commentSideInset: CGFloat = 20
        static let commentBottomInset: CGFloat = 10
    }

    // MARK: - Views

    private let ratingView = UIView()
    private let ratingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.star.image
        return imageView
    }()
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with model: UserCommentViewModel) {
        self.ratingLabel.text = model.rate
        self.dateLabel.text = model.dateDescription
        self.commentLabel.text = model.comment

        self.infoView.isHidden = !model.hasInfo
    }

}

// MARK: - Private Methods

private extension UserCommentView {

    func setupInitial() {
        self.configureRatingView()
        self.configureDate()
        self.configureComment()
    }


    func configureRatingView() {
        self.addSubview(self.ratingView)
        self.ratingView.snp.makeConstraints { make in
            make.top.equalTo(Constants.ratingSideInset)
            make.left.equalTo(Constants.ratingSideInset)
        }

        self.ratingView.addSubview(self.ratingIconImageView)
        self.ratingIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(Constants.ratingIconWidth)
            make.height.equalTo(Constants.ratingIconWidth)
            make.centerY.equalToSuperview()
        }

        self.ratingView.addSubview(self.ratingLabel)
        self.ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(Constants.ratingLabelTopInset)
            make.left.equalTo(self.ratingIconImageView.snp.right)
            make.bottom.equalTo(-Constants.ratingLabelBottomInset)
        }

        self.ratingView.addSubview(self.infoView)
        self.infoView.roundCorners(Constants.infoWidth / 2)
        self.infoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.ratingLabel.snp.right).inset(-Constants.ratingLabelSideInset)
            make.width.equalTo(Constants.infoWidth)
            make.height.equalTo(Constants.infoWidth)
        }
    }

    func configureDate() {
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.right.equalTo(-Constants.dateRightInset)
            make.bottom.equalTo(self.ratingLabel.snp.bottom)
        }
    }

    func configureComment() {
        self.addSubview(self.commentLabel)
        self.commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.ratingView.snp.bottom).inset(-Constants.commentTopInset)
            make.left.equalTo(Constants.commentSideInset)
            make.right.equalTo(-Constants.commentSideInset)
            make.bottom.equalTo(-Constants.commentBottomInset)
        }
    }

}
