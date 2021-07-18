//
//  ReviewResponseModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import Foundation

struct ReviewResponseModel: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rate
        case dateOfVisit
        case reply
    }

    // MARK: - Properies

    let id: Int
    let comment: String
    let rate: Double
    let dateOfVisit: String
    let reply: String?

    // MARK: - Init

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try values.decode(Int.self, forKey: CodingKeys.id)
        self.comment = try values.decode(String.self, forKey: CodingKeys.comment)
        self.rate = try values.decode(Double.self, forKey: CodingKeys.rate)
        self.dateOfVisit = try values.decode(String.self, forKey: CodingKeys.dateOfVisit)
        self.reply = try? values.decode(String.self, forKey: CodingKeys.reply)
    }

}
