//
//  GridCollectionView.swift
//  
//
//  Created by Salihcan Kahya on 16.03.2022.
//

import Foundation
import UIKit
import Combine
import MarvelDomainLayer

public final class MarvelCharacterListCollectionView: CollectionView<MarvelCharacterListCollectionViewSection, MarvelCharacterData> {
    
    public override func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    public override func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: MarvelCharacterData) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        print(indexPath)
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.fill(in: cell.contentView)
        cell.backgroundColor = .blue
        label.text = self.model[indexPath.row].name
        return cell
    }
    
    public override func reloadData(with model: [MarvelCharacterData]) {
        for section in MarvelCharacterListCollectionViewSection.allCases {
            snapshot.appendItems(model, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    public override func addSections() {
        snapshot.appendSections(MarvelCharacterListCollectionViewSection.allCases)
    }
}
