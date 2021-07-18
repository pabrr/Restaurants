//
//  LoaderView.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

final class LoaderView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let loaderIconWidth: CGFloat = 24
    }

    // MARK: - Views

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.loader.image
        imageView.tintColor = .gray
        return imageView
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        self.setupInitial()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Methods

private extension LoaderView {

    func setupInitial() {
        self.backgroundColor = .white

        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(Constants.loaderIconWidth)
            make.height.equalTo(Constants.loaderIconWidth)
        }

        self.iconImageView.rotate()
    }

}
