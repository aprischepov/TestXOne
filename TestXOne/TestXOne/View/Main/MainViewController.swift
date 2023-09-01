//
//  ViewController.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
//    MARK: Properties
    private lazy var catsByBreedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CatInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: CatInfoCollectionViewCell.key)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private var vm: MainViewModel = MainViewModel()
    
//    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(catsByBreedCollectionView)
        updateViewConstraints()
    }
    
//    MARK: ViewConstraints
    override func updateViewConstraints() {
        catsByBreedCollectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        Task {
            await vm.fetchData()
            catsByBreedCollectionView.reloadData()
        }
        super.updateViewConstraints()
    }
}

//    MARK: CollectionView Extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.catsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatInfoCollectionViewCell.key,
                                                         for: indexPath) as? CatInfoCollectionViewCell {
            Task {
                cell.catImage.image = await vm.getCatImage(imageName: vm.catsData[indexPath.row].image ?? "")
            }
            cell.breedTitle.text = vm.catsData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WikipediaViewController()
        vc.url = vm.catsData[indexPath.row].url ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

//    MARK: CollectionViewLayuot Extension
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(view.frame.width / vm.itemsPerRow - vm.itemSpacing * 1.5)
        let height = CGFloat(view.frame.height / vm.itemsPerColumn - vm.itemSpacing * 1.5)
        return CGSize(width: width,
                      height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: vm.itemSpacing,
                            left: vm.itemSpacing,
                            bottom: vm.itemSpacing,
                            right: vm.itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return vm.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return vm.itemSpacing
    }
}

