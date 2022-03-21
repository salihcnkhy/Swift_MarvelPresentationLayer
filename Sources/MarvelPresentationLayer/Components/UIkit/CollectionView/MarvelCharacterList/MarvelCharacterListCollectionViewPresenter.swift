//
//  MarvelCharacterListCollectionViewPresenter.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit

public final class MarvelCharacterListCollectionViewPresenter: CollectionViewPresenter {
    public override func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)
        layoutGroup.interItemSpacing = .fixed(10)

        layoutGroup.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        return layoutSection
    }
}
