//
//  CatInfoCollectionViewCell.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import UIKit
import SnapKit
import SDWebImage

final class CatInfoCollectionViewCell: UICollectionViewCell {
    static let key: String = "CatInfoCollectionViewCell"
    private let  api: TheCatApiProtocol = TheCatApiService()
    private lazy var catImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    var breedTitle: UILabel = {
        return UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(catImage)
        contentView.addSubview(breedTitle)
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        catImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
        breedTitle.snp.makeConstraints { make in
            make.top.equalTo(catImage.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(4)
        }
        super.updateConstraints()
    }
    
    public func setData(image: String?, title: String) {
        if let image = image {
            let imagePath = "https://cdn2.thecatapi.com/images/\(image).jpg"
            catImage.sd_setImage(with: URL(string: imagePath))
        } else {
            catImage.image = UIImage(named: "error")
        }
        breedTitle.text = title
    }
}
