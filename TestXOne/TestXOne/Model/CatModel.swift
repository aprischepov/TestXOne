//
//  CatModel.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import Foundation

struct CatModel: Decodable {
    let id: String
    let name: String
    let url: URL
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case url = "wikipedia_url"
        case image = "reference_image_id"
    }
}
