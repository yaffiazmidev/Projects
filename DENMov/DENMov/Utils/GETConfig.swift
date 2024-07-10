//
//  GETConfig.swift
//  DENMov
//
//  Created by DENAZMI on 11/07/24.
//

import Foundation

public struct APIConfig: Decodable {
    public let secret: String
    
    public init(secret: String) {
        self.secret = secret
    }
}

func getConfig<T: Decodable>(fromPlist resource: String) -> T {
    guard
        let path = Bundle.main.path(forResource: resource, ofType: "plist"),
        let xml = FileManager.default.contents(atPath: path),
        let config = try? PropertyListDecoder().decode(T.self, from: xml)
        else { fatalError("Expected to find \(resource).plist but got nil instead") }
    return config
}
