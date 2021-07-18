//
//  RestaurantCell.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import SDWebImage

final class RestaurantCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let bubbleTopInset: CGFloat = 8
        static let bubbleSideInset: CGFloat = 10

        static let containerSideInset: CGFloat = 20
        static let containerCornerRadius: CGFloat = 16

        static let ratingContainerRadius: CGFloat = 8

        static let ratingIconLeftInset: CGFloat = 8
        static let ratingIconWidth: CGFloat = 32
        static let ratingIconLabelInset: CGFloat = 10

        static let ratingLabelTopInset: CGFloat = 6
        static let ratingLabelBottomInset: CGFloat = 8
        static let ratingLabelRightInset: CGFloat = 8
    }
    static let cellID = String(describing: RestaurantCell.self)
    static let cellHeight: CGFloat = 150

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
    private let infoBubbleView = InfoBubbleView()

    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    // MARK: - Properties

    var onSelectRestaurant: IntClosure?

    // MARK: - Private Properties

    private var id = 1

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with model: RestaurantCellViewModel) {
        self.id = model.id

        self.ratingLabel.text = model.rating

        if let imageUrlString = model.imageUrlString,
           let url = URL(string: imageUrlString) {
            self.restaurantImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                self?.restaurantImageView.image = image
            }
        } else {
            self.restaurantImageView.image = nil
        }

        if let infoText = model.infoText {
            self.infoBubbleView.configure(with: infoText)
            self.infoBubbleView.isHidden = false
        }
    }

}

// MARK: - Actions

private extension RestaurantCell {

    @objc
    func didSelectRestaurant() {
        self.onSelectRestaurant?(self.id)
    }

}

// MARK: - Private Methods

private extension RestaurantCell {

    func setupInitial() {
        self.selectionStyle = .none

        self.configureContainerView()
        self.configureRestaurantImageView()
        self.configureRatingView()
        self.configureInfoBubble()
        self.configureSelectionAction()
    }

    func configureContainerView() {
        self.contentView.addSubview(self.containerView)

        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(Constants.containerSideInset)
            make.left.equalTo(Constants.containerSideInset)
            make.right.equalTo(-Constants.containerSideInset)
            make.bottom.equalToSuperview()
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
            make.right.equalTo(Constants.ratingContainerRadius)
            make.bottom.equalTo(Constants.ratingContainerRadius)
        }

        ratingView.addSubview(self.ratingIconImageView)
        self.ratingIconImageView.snp.makeConstraints { make in
            make.left.equalTo(Constants.ratingIconLeftInset)
            make.width.equalTo(Constants.ratingIconWidth)
            make.height.equalTo(Constants.ratingIconWidth)
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

    func configureInfoBubble() {
        self.infoBubbleView.isHidden = true

        self.contentView.addSubview(self.infoBubbleView)
        self.infoBubbleView.snp.makeConstraints { make in
            make.top.equalTo(Constants.bubbleTopInset)
            make.left.equalTo(Constants.bubbleSideInset)
            make.right.lessThanOrEqualTo(-Constants.bubbleSideInset)
        }
    }

    func configureSelectionAction() {
        self.actionButton.addTarget(self, action: #selector(self.didSelectRestaurant), for: .touchUpInside)

        self.contentView.addSubview(self.actionButton)
        self.actionButton.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }
    }

}
