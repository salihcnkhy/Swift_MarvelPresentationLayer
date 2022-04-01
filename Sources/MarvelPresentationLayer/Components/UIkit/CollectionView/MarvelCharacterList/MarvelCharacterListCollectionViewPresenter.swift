//
//  MarvelCharacterListCollectionViewPresenter.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit

public final class MarvelCharacterListCollectionViewPresenter: CollectionViewPresenter {
    public override func createSection(with sectionIndex: Int, and environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = MarvelCharacterListCollectionViewSection.allCases[sectionIndex]
        switch section {
            case .allList:
                return generateAllListSection()
        }
    }
    
    private func generateAllListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 2)
        layoutGroup.interItemSpacing = .fixed(10)
        
        layoutGroup.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        return layoutSection
    }
}
