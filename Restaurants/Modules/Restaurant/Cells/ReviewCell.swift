//
//  ReviewCell.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import SnapKit

final class ReviewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let containerSideInset: CGFloat = 10
        static let replyLeftInset: CGFloat = 50
    }
    static let cellID = String(describing: ReviewCell.self)

    // MARK: - Views

    private let containerView = UIView()
    private let userComment = UserCommentView()
    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    // MARK: - Private Properties

    private var reviewId: Int = -1

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with model: ReviewCellViewModel) {
        self.reviewId = model.id
        self.selectionStyle = model.isSelectable ? .default : .none

        self.userComment.configure(with: model.userCommentViewModel)

        self.replyLabel.isHidden = model.reply == nil
        if let reply = model.reply {
            self.replyLabel.text = reply
        }
    }

    func getReviewId() -> Int {
        return self.reviewId
    }

}

// MARK: - Private Methods

private extension ReviewCell {

    func setupInitial() {
        self.configureContainerView()
        self.configureUserComment()
        self.configureReply()
    }

    func configureContainerView() {
        self.contentView.addSubview(self.containerView)

        self.containerView.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.containerSideInset)
            make.right.bottom.equalTo(-Constants.containerSideInset)
        }
    }

    func configureUserComment() {
        self.containerView.addSubview(self.userComment)
        self.userComment.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configureReply() {
        self.containerView.addSubview(self.replyLabel)
        self.replyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userComment.snp.bottom)
            make.left.equalTo(Constants.replyLeftInset)
            make.right.bottom.equalToSuperview()
        }
    }

}
