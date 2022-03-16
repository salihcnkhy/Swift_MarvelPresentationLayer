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
    func getCharacterList()
}

public final class CharacterListViewModel: BaseViewModel, CharacterListViewModelProtocol {
    
    
    private var anyCancellables = Set<AnyCancellable>()
    private let characterListPublisher: CharacterListUseCasePublisher
    
    public init(characterListPublisher: CharacterListUseCasePublisher) {
        self.characterListPublisher = characterListPublisher
    }
    
    public func getCharacterList() {
        characterListPublisher
            .setRequest(.init(offset: 0, limit: 10))
            .sink { completion in
                print(completion)
            } receiveValue: { listResponse in
                print(listResponse)
            }
            .store(in: &anyCancellables)
    }
}
