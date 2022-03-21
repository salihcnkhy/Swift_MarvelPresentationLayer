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
    var searchbarPresenter: SearchBarPresenter { get }
}

public final class CharacterListPresenter: BasePresenter, CharacterListPresenterProtocol {
    public let characterCollectionViewPresenter: MarvelCharacterListCollectionViewPresenter = .init(rowSpacing: 24, columnCount: 2)
    public let searchbarPresenter: SearchBarPresenter = .init()
}
