//
//  CatInfoCollectionViewCell.swift
//  TestXOne
//
//  Created by Artem Prischepov on 1.09.23.
//

import UIKit
import SnapKit

class CatInfoCollectionViewCell: UICollectionViewCell {
    static let key: String = "CatInfoCollectionViewCell"
    lazy var catImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    lazy var breedTitle: UILabel = {
        let title = UILabel()
        return title
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
}
