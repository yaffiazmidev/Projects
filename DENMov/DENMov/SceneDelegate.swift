//
//  SceneDelegate.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import UIKit
import DENMovNetworking

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
    private lazy var config: APIConfig = getConfig(fromPlist: "APIConfig")
    
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
        let client = URLSessionHTTPClient()
        let vc = HomeController(client: client, request: makeNowPlayingRequest())
        return vc
    }
    
    private func makeNowPlayingRequest() -> URLRequest {
        return .url(baseURL)
            .path("/3/movie/now_playing")
            .queries([
                .init(name: "page", value: "\(1)"),
                .init(name: "query", value: ""),
                .init(name: "language", value: "ID-id"),
                .init(name: "api_key", value: config.secret)
            ])
            .build()
    }
}

