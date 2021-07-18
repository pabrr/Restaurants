//
//  UserViewModel.swift
//  Restaurants
//
//  Created by Полина Полухина on 28.06.2021.
//

struct UserViewModel {

    // MARK: - Properties

    var id: Int?
    var login: String
    var userRole: UserRole

    // MARK: - Init

    init(with response: UserResponseModel) {
        self.id = response.id
        self.login = response.username
        self.userRole = UserRole(rawValue: response.role) ?? .user
    }

}
