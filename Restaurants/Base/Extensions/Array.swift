//
//  Array.swift
//  Restaurants
//
//  Created by Полина Полухина on 23.06.2021.
//

extension Array {

    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }

}
