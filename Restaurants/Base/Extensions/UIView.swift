//
//  UIView.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

import UIKit

extension UIView {

    func rotate() {
        guard layer.animation(forKey: CommonConstants.rotationAnimationKey.rawValue) == nil else {
            return
        }
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2.0
        rotationAnimation.duration = 2
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity

        layer.add(rotationAnimation, forKey: CommonConstants.rotationAnimationKey.rawValue)
    }

    func stopRotating() {
        if layer.animation(forKey: CommonConstants.rotationAnimationKey.rawValue) != nil {
            layer.removeAnimation(forKey: CommonConstants.rotationAnimationKey.rawValue)
        }
    }

    func roundCorners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

}
