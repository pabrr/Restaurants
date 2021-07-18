//
//  SceneDelegate.swift
//  Restaurants
//
//  Created by Полина Полухина on 22.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let coordinator = InitialCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        self.window = UIWindow(windowScene: windowScene)
        self.window?.overrideUserInterfaceStyle = .light

        let viewController = coordinator.start()

        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

}
