//
//  SceneDelegate.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureRootController(with: windowScene)
    }
    
    private func configureRootController(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: makeRootController())
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        self.window = window
    }
    
    private func makeRootController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        return vc
    }
}

