//
//  CharacterListPresenter.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase
import Combine

public protocol CharacterListPresenterProtocol {
    var characterListPublisher: Published<CharacterListModel>.Publisher { get set }
}

public final class CharacterListPresenter: BasePresenter, CharacterListPresenterProtocol {
    @Published private var characterList: CharacterListModel = CharacterListModel()
    
    public var characterListPublisher: Published<CharacterListModel>.Publisher {
        get { $characterList }
        set { $characterList = newValue }
    }
}
