//
//  DefaultButton.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

final class DefaultButton: UIButton {

    convenience init(title: String) {
        self.init(type: .custom)

        self.setTitle(title, for: .normal)
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.gray, for: .highlighted)
    }

}
