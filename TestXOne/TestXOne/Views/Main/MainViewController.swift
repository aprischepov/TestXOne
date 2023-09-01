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
        collectionView.backgroundColor = .customWhite
        return collectionView
    }()
    private var vm: MainViewModel = MainViewModel()
    
    //    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customWhite
        view.addSubview(catsByBreedCollectionView)
        Task {
            do {
                try await vm.getData()
                catsByBreedCollectionView.reloadData()
            } catch {
                let alert = UIAlertController(title: "Something was wrong",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: .default))
                present(alert, animated: true)
            }
        }
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
        vm.catsBreedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatInfoCollectionViewCell.key,
                                                         for: indexPath) as? CatInfoCollectionViewCell {
            let title = vm.catsBreedData[indexPath.row].name
            let image = vm.catsBreedData[indexPath.row].image
            cell.setData(image: image, title: title)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WikipediaViewController()
        vc.url = vm.catsBreedData[indexPath.row].url ?? ""
        vc.title = vm.catsBreedData[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == vm.catsBreedData.count - 1 {
            Task {
                do {
                    try await vm.getData()
                    catsByBreedCollectionView.reloadData()
                } catch {
                    let alert = UIAlertController(title: "Something was wrong",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: .default))
                }
            }
        }
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

