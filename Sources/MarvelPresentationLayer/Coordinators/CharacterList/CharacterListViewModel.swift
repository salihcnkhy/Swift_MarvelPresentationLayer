//
//  CharacterListViewModel.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase
import MarvelDomainLayer
import Combine
import SwiftUI

public protocol CharacterListViewModelProtocol {
    func getCharacterList(assign: inout Published<CharacterListModel>.Publisher)
}

public final class CharacterListViewModel: CharacterListViewModelProtocol {
    
    private let characterListPublisher: CharacterListUseCasePublisher
    
    public init(characterListPublisher: CharacterListUseCasePublisher) {
        self.characterListPublisher = characterListPublisher
    }
    
    public func getCharacterList(assign: inout Published<CharacterListModel>.Publisher) {
        characterListPublisher
            .setRequest(.init())
            .compactMap { characterListResponse in CharacterListModel() }
            .eraseToAnyPublisher()
            .assign(to: &assign)
    }
}
