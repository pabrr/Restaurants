//
//  KeychainService.swift
//  Restaurants
//
//  Created by Полина Полухина on 22.06.2021.
//

import KeychainSwift

final class KeychainService {

    // MARK: - Constants

    private enum Keys: String {
        case passwordKey
        case loginKey
        case userRoleKey
        case accessToken
    }

    // MARK: - Private Properties

    private let keychainService = KeychainSwift()

    // MARK: - Methods

    func save(login: String, password: String) {
        self.save(key: Keys.loginKey.rawValue, value: login)
        self.save(key: Keys.passwordKey.rawValue, value: password)
    }

    func getLoginPassword() -> (login: String, password: String)? {
        guard let login = self.load(key: Keys.loginKey.rawValue),
              let password = self.load(key: Keys.passwordKey.rawValue) else {
            return nil
        }
        return (login, password)
    }

    func save(userRole: UserRole) {
        self.save(key: Keys.userRoleKey.rawValue, value: userRole.rawValue)
    }

    func getUserRole() -> UserRole? {
        guard let userRoleRaw = self.load(key: Keys.userRoleKey.rawValue) else {
            return nil
        }
        return UserRole(rawValue: userRoleRaw)
    }

    func save(accessToken: String) {
        self.save(key: Keys.accessToken.rawValue, value: accessToken)
    }

    func getAccessToken() -> String? {
        return self.load(key: Keys.accessToken.rawValue)
    }

    func clearUser() {
        self.removeData()
    }

}

// MARK: - Private Methods

private extension KeychainService {

    func removeData() {
        self.keychainService.clear()
    }

    func save(key: String, value: String) {
        self.keychainService.set(value, forKey: key)
    }

    func load(key: String) -> String? {
        return self.keychainService.get(key)
    }

}
