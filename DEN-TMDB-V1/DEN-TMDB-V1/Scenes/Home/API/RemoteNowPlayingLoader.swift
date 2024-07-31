//
//  RemoteNowPlayingLoader.swift
//  DEN-TMDB-V1
//
//  Created by DENAZMI on 16/04/24.
//

import Foundation

class RemoteNowPlayingLoader: NowPlayingLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidResponse
    }
    
    typealias Result = NowPlayingLoader.Result
    
    let baseURL: URL
    let client: HTTPClient
    
    init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
    
    func execute(_ req: NowPlayingRequest, completion: @escaping (Result) -> Void) {
        let request = enrich(baseURL, with: req)
        
        client.request(from: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteNowPlayingFeedMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

extension RemoteNowPlayingLoader {
    func enrich(_ url: URL, with req: NowPlayingRequest) -> URLRequest {
        return URLRequest
            .url(url)
            .path("/3/movie/now_playing")
            .queries([
                .init(name: "page", value: "\(req.page)")
            ])
            .build()
    }
}
