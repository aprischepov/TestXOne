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
        collectionView.backgroundColor = .lightGray
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
//            cell.catImage.image =
            cell.breedTitle.text = vm.catsData[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
}

//    MARK: CollectionViewLayuot Extension
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGFloat(view.frame.width / vm.itemsPerRow - vm.itemSpacing * 1.5)
        return CGSize(width: size,
                      height: size)
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

