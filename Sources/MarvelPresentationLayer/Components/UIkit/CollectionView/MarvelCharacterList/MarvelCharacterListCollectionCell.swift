//
//  MarvelCharacterListCollectionCell.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import Foundation
import UIKit
import Swiftlities

final class MarvelCharacterListCollectionCell: UICollectionViewCell, ReusableCellProtocol {
    static let reusableID: String = "MarvelCharacterListCollectionCell"
    
    private lazy var characterImage: NetworkImageContainer = {
        let temp = NetworkImageContainer(presenter: .init())
        temp.clipsToBounds = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var bannerContainer: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .white
        temp.clipsToBounds = true
        temp.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        temp.layer.cornerRadius = 5
        return temp
    }()
    
    private lazy var nameLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.numberOfLines = 1
        temp.lineBreakMode = .byTruncatingTail
        return temp
    }()
    
    private lazy var favoriteIcon: UIImageView = {
        let temp = UIImageView(image: .init(systemName: "heart"))
        temp.tintColor = .red
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setViews() {
        contentView.backgroundColor = .green
        contentView.addBorder(with: 1, and: .quaternaryLabel, round: 6)
        
        characterImage.fill(in: contentView)
        characterImage.addSubview(bannerContainer)
        
        bannerContainer.addSubview(nameLabel)
        bannerContainer.addSubview(favoriteIcon)
        
        bannerContainer.activate(constraints: [
            .height(constantRelation: .equalConstant(60)),
            .bottom(relation: .equal(attribute: .bottom(ofView: characterImage))),
            .leading(relation: .equal(attribute: .leading(ofView: characterImage))),
            .trailing(relation: .equal(attribute: .trailing(ofView: characterImage))),
        ])
        
        nameLabel.activate(constraints: [
            .centerY(relation: .equal(attribute: .centerY(ofView: bannerContainer))),
            .leading(relation: .equal(attribute: .leading(ofView: bannerContainer), 5)),
        ])
        
        favoriteIcon.activate(constraints: [
            .centerY(relation: .equal(attribute: .centerY(ofView: bannerContainer))),
            .leading(relation: .greaterThan(attribute: .trailing(ofView: nameLabel), 5)),
            .trailing(relation: .equal(attribute: .trailing(ofView: bannerContainer), -5)),
            .height(constantRelation: .equalConstant(25)),
            .width(constantRelation: .equalConstant(25))
        ])
        favoriteIcon.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func configure(with model: MarvelCharacterData) {
        nameLabel.text = model.name
        characterImage.stateSubject.send(.init(id: model.id, url: model.image.createUrlString()))
        print(model.image.createUrlString())
    }
}
