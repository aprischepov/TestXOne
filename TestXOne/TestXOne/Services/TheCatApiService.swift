//
//  TheCatApiService.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import Foundation

protocol TheCatApiProtocol {
    func getCatsData(limit: Int, page: Int) async throws -> [CatModel]
    func getImage(imageName: String) async throws -> Data
}

final class TheCatApiService: TheCatApiProtocol {
    var session = URLSession.shared
    let decoder = JSONDecoder()
    let catsListComponents = URLComponents(string: "https://api.thecatapi.com/v1/breeds")
    
    func getCatsData(limit: Int, page: Int) async throws -> [CatModel] {
        guard var catsListComponents,
              var catsListUrl = catsListComponents.url else { return [] }
        catsListComponents.queryItems = [URLQueryItem(name: "limit",
                                               value: limit.description),
                                         URLQueryItem(name: "page",
                                               value: page.description)]
        let (data, _) = try await session.data(from: catsListUrl)
        return try decoder.decode([CatModel].self, from: data)
    }
    
    func getImage(imageName: String) async throws -> Data {
        var catImage = "https://cdn2.thecatapi.com/images/\(imageName).jpg"
        guard let url = URL(string: catImage) else { return Data() }
        let request =  URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        return data
    }
}
