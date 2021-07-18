//
//  InfoBubbleView.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import SnapKit

final class InfoBubbleView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let infoLabelSideInset: CGFloat = 4
        static let bubbleCornerRadius: CGFloat = 11
    }

    // MARK: - Views

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
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

    func configure(with text: String) {
        self.infoLabel.text = text
    }

}

// MARK: - Private Methods

private extension InfoBubbleView {

    func setupInitial() {
        self.backgroundColor = .red
        self.roundCorners(Constants.bubbleCornerRadius)

        self.addSubview(self.infoLabel)
        self.infoLabel.snp.makeConstraints { make in
            make.top.equalTo(Constants.infoLabelSideInset)
            make.left.equalTo(Constants.infoLabelSideInset)
            make.right.equalTo(-Constants.infoLabelSideInset)
            make.bottom.equalTo(-Constants.infoLabelSideInset)
        }
    }

}
