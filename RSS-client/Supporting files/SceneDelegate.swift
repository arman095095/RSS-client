//
//  SceneDelegate.swift
//  RSS-client
//
//  Created by Arman Davidoff on 11.11.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = Builder.mainWindow(scene: scene)
    }
}

