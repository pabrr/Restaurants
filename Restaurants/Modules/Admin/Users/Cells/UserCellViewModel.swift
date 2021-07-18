//
//  UserCellViewModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 26.06.2021.
//

struct UserCellViewModel {

    // MARK: - Properties

    let id: Int
    let login: String
    let role: UserRole

    // MARK: - Init

    init(with response: UserResponseModel) {
        self.id = response.id
        self.login = response.username
        self.role = UserRole(rawValue: response.role) ?? .user
    }

}
