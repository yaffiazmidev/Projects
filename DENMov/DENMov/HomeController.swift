//
//  HomeController.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import UIKit
import DENMovNetworking

class HomeController: UIViewController {
    
    private let client: HTTPClient
    private let request: URLRequest
    
    init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client.load(request: request) { result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success((data, response)):
                print(String(data: data, encoding: .utf8) ?? "", response)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
