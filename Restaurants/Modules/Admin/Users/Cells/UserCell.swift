//
//  UserCell.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

import UIKit

final class UserCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let sideInset: CGFloat = 20
        static let stackViewInset: CGFloat = 4
    }
    static let cellID = String(describing: UserCell.self)

    // MARK: - Views

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewInset
        stackView.alignment = .leading
        return stackView
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

    func configure(with model: UserCellViewModel) {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let mirror = Mirror(reflecting: model)
        for child in mirror.children  {
            let text = "\(child.label ?? ""): \(child.value)"
            let label = self.getLabel(text: text)
            label.sizeToFit()
            self.stackView.addArrangedSubview(label)
        }
    }

}

// MARK: - Private Methods

private extension UserCell {

    func setupInitial() {
        self.contentView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.sideInset)
            make.right.bottom.equalTo(-Constants.sideInset)
        }
    }

    func getLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = text
        return label
    }

}
