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
    private let catsApiService: TheCatApiProtocol = TheCatApiService()
    
    //    MARK: Methods
    //    Fetch Cats Data
    func getData() async {
        do {
            let cats = try await catsApiService.getCatsData(limit: currentLimit,
                                                            page: currentPage)
            if !cats.isEmpty {
                catsBreedData.append(contentsOf: cats)
            }
        } catch {
            print(error)
        }
    }
    
//    Load More
    func loadMore(index: Int) async {
        if index == catsBreedData.count - 1 {
            await getData()
        }
    }
}
