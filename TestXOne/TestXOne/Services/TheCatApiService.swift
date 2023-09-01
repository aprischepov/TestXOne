//
//  TheCatApiService.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import Foundation

protocol TheCatApiProtocol {
    func getCatsData(limit: Int, page: Int) async throws -> [CatModel]
}

final class TheCatApiService: TheCatApiProtocol {
    //    MARK: Properties
    var session = URLSession.shared
    let decoder = JSONDecoder()
    let catsListComponents = URLComponents(string: "https://api.thecatapi.com/v1/breeds")
    let cache = URLCache.shared
    
    //    MARK: Methods
    //    Get Cats Data
    func getCatsData(limit: Int, page: Int) async throws -> [CatModel] {
        guard var catsListComponents else { return [] }
        catsListComponents.queryItems = [URLQueryItem(name: "limit",
                                                      value: limit.description),
                                         URLQueryItem(name: "page",
                                                      value: page.description)]
        guard let catsListUrl = catsListComponents.url else { return [] }
        
        if cache.cachedResponse(for: URLRequest(url: catsListUrl)) != nil {
            guard let cachedData = try await loadFromCache(url: catsListUrl) else { return [] }
            return try decoder.decode([CatModel].self, from: cachedData)
        } else {
            let (data, _) = try await session.data(from: catsListUrl)
            try await cashedData(url: catsListUrl)
            return try decoder.decode([CatModel].self, from: data)
        }
    }
    
    func loadFromCache(url: URL) async throws -> Data? {
        return cache.cachedResponse(for: URLRequest(url: url))?.data
    }
    
    func cashedData(url:  URL) async throws {
        let (data, response) = try await session.data(from: url)
        _ = CachedURLResponse(response: response, data: data)
        cache.cachedResponse(for: URLRequest(url: url))
    }
}
