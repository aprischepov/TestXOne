//
//  MainViewModel.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import Foundation
import UIKit

final class MainViewModel {
//    MARK: Properties
    typealias Cats = [CatModel]
    let itemsPerRow: CGFloat = 2
    let itemSpacing: CGFloat = 8
    var catsData = Cats()
    let catsApiService: TheCatApiProtocol = TheCatApiService()
    
    init() {
        Task {
            await fetchData()
        }
    }
    
    
//    MARK: Methods
//    Fetch Cats Data
    func fetchData() async {
        do {
            let cats = try await catsApiService.getCatsData(limit: 10, page: 0)
            await MainActor.run {
                catsData = cats
            }
        } catch let error {
            print(error)
        }
    }
    
//    Get Image
    func getCatImage(imageName: String) async -> UIImage? {
        do {
            let data = try await catsApiService.getImage(imageName: imageName)
            return UIImage(data: data)
        } catch let error {
            print(error)
            return nil
        }
    }
}
