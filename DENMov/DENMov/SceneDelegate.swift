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
        window = UIWindow(windowScene: windowScene)
        
        configureRootController()
    }
    
    private func configureRootController() {
        window?.rootViewController = UINavigationController(rootViewController: makeRootController())
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
    
    private func makeRootController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }
}

