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
    
    //    MARK: Methods
    //    Get Cats Data
    func getCatsData(limit: Int, page: Int) async throws -> [CatModel] {
        guard var catsListComponents else { return [] }
        catsListComponents.queryItems = [URLQueryItem(name: "limit",
                                                      value: limit.description),
                                         URLQueryItem(name: "page",
                                                      value: page.description)]
        guard let catsListUrl = catsListComponents.url else { return [] }
        let (data, _) = try await session.data(from: catsListUrl)
        return try decoder.decode([CatModel].self, from: data)
    }
}
