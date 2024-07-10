//
//  SceneDelegate.swift
//  DENMovie
//
//  Created by DENAZMI on 20/05/24.
//

import UIKit
import DENMovieNetworking
import DENMovieNowPlaying
import DENMovieNowPlayingiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var navigationController = UINavigationController()
    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    private lazy var config: APIConfig = getConfig(fromPlist: "APIConfig")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        navigationController.setViewControllers([makeNowPlayingScane()], animated: false)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    func makeNowPlayingScane() -> NowPlayingController {
        let client = URLSessionHTTPClient()
        let authenticatedHTTPClient = AuthenticatedHTTPClientDecorator(decoratee: client, config: config)
        let loader = RemoteNowPlayingLoader(baseURL: baseURL, client: authenticatedHTTPClient)
        let controller = NowPlayingController(loader: loader)
        return controller
    }
}

