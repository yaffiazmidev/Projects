//
//  SceneDelegate.swift
//  DENMovieNowPlayingApps
//
//  Created by DENAZMI on 22/05/24.
//

import UIKit
import DENMovieNowPlayingiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    lazy var navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootViewController = NowPlayingController()
        navigationController.setViewControllers([rootViewController], animated: false)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

