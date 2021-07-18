//
//  Date.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

import Foundation

extension Date {

    // MARK: - Enums

    enum DateFormat: String {
        case ddmmyyyyDot = "dd.MM.yyyy"
    }

    // MARK: - Mehtods

    func getString(_ dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.string(from: self)
    }

}

extension String {

    // MARK: - Mehtods

    func getDate(_ dateFormat:Date.DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        dateFormatter.dateFormat = dateFormat.rawValue
        return dateFormatter.date(from: self)
    }

}
