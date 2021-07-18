//
//  RestaurantResponseModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 25.06.2021.
//

import Foundation

struct RestaurantResponseModel: Decodable {

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageString = "imageData"
        case averageRate
        case unrepliedComments
        case reviews
    }

    // MARK: - Properties

    let id: Int
    let name: String
    let description: String
    let averageRate: Double?
    let imageUrlString: String?
    let unrepliedComments: Int?
    let reviews: [ReviewResponseModel]?

    // MARK: - Init

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try values.decode(Int.self, forKey: CodingKeys.id)
        self.name = try values.decode(String.self, forKey: CodingKeys.name)
        self.description = try values.decode(String.self, forKey: CodingKeys.description)
        self.averageRate = try? values.decode(Double.self, forKey: CodingKeys.averageRate)
        self.imageUrlString = try? values.decode(String.self, forKey: CodingKeys.imageString)
        self.unrepliedComments = try? values.decode(Int.self, forKey: CodingKeys.unrepliedComments)
        self.reviews = try? values.decode([ReviewResponseModel].self, forKey: CodingKeys.reviews)
    }

}
