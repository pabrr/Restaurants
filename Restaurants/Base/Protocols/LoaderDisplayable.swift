//
//  LoaderDisplayable.swift
//  Restaurants
//
//  Created by Полина Полухина on 24.06.2021.
//

import UIKit

protocol LoaderDisplayable: UIViewController {
    func showLoading()
    func stopLoading()
}

extension LoaderDisplayable {

    func showLoading() {
        let loadingView = LoaderView()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func stopLoading() {
        guard let loaderView = self.view.subviews.first(where: { $0 is LoaderView }) else {
            return
        }
        loaderView.removeFromSuperview()
    }

}
