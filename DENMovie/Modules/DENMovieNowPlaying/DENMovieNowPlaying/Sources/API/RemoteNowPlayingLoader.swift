//
//  RemoteNowPlayingLoader.swift
//  DENMovieNowPlaying
//
//  Created by DENAZMI on 20/05/24.
//

import Foundation
import DENMovieNetworking

public final class RemoteNowPlayingLoader: NowPlayingLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidResponse
    }
    
    public typealias Result = NowPlayingLoader.Result
    
    private let baseURL: URL
    private let client: HTTPClient
    private var task: HTTPClientTask?
    
    public init(
        baseURL: URL,
        client: HTTPClient
    ) {
        self.baseURL = baseURL
        self.client = client
    }
    
    public func execute(_ request: PagedNowPlayingRequest, completion: @escaping (Result) -> Void) {
        let request = enrich(baseURL: baseURL, request: request)
        
        task = client.request(request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteNowPlayingLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    public func cancel() {
        task?.cancel()
    }
}

private extension RemoteNowPlayingLoader {
    private func enrich(baseURL: URL, request: PagedNowPlayingRequest) -> URLRequest {
        return URLRequest.url(baseURL)
            .path("/3/movie/now_playing")
            .queries([
                .init(name: "page", value: "\(request.page)"),
                .init(name: "query", value: request.query),
                .init(name: "language", value: request.language)
            ])
            .build()
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let item = try NowPlayingItemsMapper.map(data: data, from: response)
            return .success(item.asPageDTO())
        } catch {
            return .failure(error)
        }
    }
}

private extension RemoteNowPlayingFeed {
    
    func asPageDTO() -> NowPlayingFeed {
        return .init(
            items: results.compactMap({
                NowPlayingItem(
                    id: $0.id,
                    title: $0.original_title,
                    imagePath: $0.poster_path ?? "",
                    releaseDate: $0.release_date ?? "",
                    genreIds: $0.genre_ids?.compactMap({ Int($0) }) ?? []
                )
            }),
            page: page,
            totalPages: total_pages
        )
    }
}
