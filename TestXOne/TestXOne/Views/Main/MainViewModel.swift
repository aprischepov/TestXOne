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
    let itemsPerColumn: CGFloat = 3
    var currentLimit: Int = 10
    var currentPage: Int = 0
    var catsBreedData: Cats = [] {
        didSet {
            currentPage += 1
        }
    }
    var catsBreedCount: Int = 0
    let catsApiService: TheCatApiProtocol = TheCatApiService()
    
//    MARK: Methods
//    Fetch Cats Data
    func getData() async {
        do {
            if catsBreedData.isEmpty {
                catsBreedCount = try await catsApiService.getCatsBreedCount()
            }
            let cats = try await catsApiService.getCatsData(limit: currentLimit, page: currentPage)
            catsBreedData.append(contentsOf: cats)
        } catch {
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
