//
//  CharacterListPresenter.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase
import Combine
import MarvelDomainLayer

public protocol CharacterListPresenterProtocol {
    var characterCollectionViewPresenter: MarvelCharacterListCollectionViewPresenter { get }
    
    func getMarvelListData(_ dto: [MarvelCharacterDataResponse]) -> [MarvelCharacterData]
}

public final class CharacterListPresenter: BasePresenter, CharacterListPresenterProtocol {
    public let characterCollectionViewPresenter: MarvelCharacterListCollectionViewPresenter = .init(rowSpacing: 24, columnCount: 2)
    
    public func getMarvelListData(_ dto: [MarvelCharacterDataResponse]) -> [MarvelCharacterData] {
        dto.compactMap {
            MarvelCharacterData(name: $0.name)
        }
    }
}
