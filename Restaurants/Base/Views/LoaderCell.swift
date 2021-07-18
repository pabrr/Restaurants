//
//  LoaderCell.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import UIKit

final class LoaderCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let loaderWidth: CGFloat = 24
        static let topInset: CGFloat = 20
    }
    static let cellID = String(describing: LoaderCell.self)

    // MARK: - Views

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.loader.image
        imageView.tintColor = .gray
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func startRotation() {
        self.iconImageView.rotate()
    }

}

// MARK: - Private Methods

private extension LoaderCell {

    func setupInitial() {
        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.loaderWidth)
            make.top.equalTo(Constants.topInset)
            make.bottom.equalTo(-Constants.topInset)
            make.centerX.equalToSuperview()
        }
    }

}
