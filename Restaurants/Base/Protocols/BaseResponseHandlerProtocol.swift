//
//  BaseResponseHandlerProtocol.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Combine

protocol BaseResponseHandlerProtocol: ErrorHandlerProtocol {
    func handle(completion: Subscribers.Completion<BaseError>, view: (AlertDisplayable & LoaderDisplayable)?)
}

extension BaseResponseHandlerProtocol {

    func handle(completion: Subscribers.Completion<BaseError>, view: (AlertDisplayable & LoaderDisplayable)?) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            self.handleBaseError(error, view: view)
        }
    }

}
