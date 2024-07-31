//
//  SceneDelegate.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import UIKit
import DENMovNetworking
import DENMovNowPlaying
import DENMovNowPlayingiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var navigationController = UINavigationController()
    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    private lazy var config: APIConfig = getConfig(fromPlist: "APIConfig")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureRootController()
        configureFeatures()
    }
}

extension SceneDelegate {
    private func configureRootController() {
        navigationController.setViewControllers([makeNowPlayingController()], animated: false)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
    }
    
    private func makeNowPlayingController() -> UIViewController {
        let client = URLSessionHTTPClient()
        let authenticatedHTTPClient = AuthenticatedHTTPClientDecorator(decoratee: client, config: config)
        let loader = RemoteNowPlayingLoader(baseURL: baseURL, client: authenticatedHTTPClient)
        let vc = NowPlayingUIComposer.compose(loader: loader)
        return vc
    }
}

extension SceneDelegate {
    private func configureFeatures() {
        configureHomeFeature()
    }
}
