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
        collectionView.register(MarvelCharacterListCollectionCell.self, forCellWithReuseIdentifier: MarvelCharacterListCollectionCell.reusableID)
    }
    
    public override func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: MarvelCharacterData) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCharacterListCollectionCell.reusableID, for: indexPath) as! MarvelCharacterListCollectionCell
        cell.configure(with: model[indexPath.row])
        return cell
    }
}
