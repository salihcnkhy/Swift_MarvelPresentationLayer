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
    func getCharacterList(callback: @escaping ([MarvelCharacterDataResponse]) -> Void)
}

public final class CharacterListViewModel: BaseViewModel, CharacterListViewModelProtocol {
    
    private var anyCancellables = Set<AnyCancellable>()
    private let characterListPublisher: CharacterListUseCaseProtocol
    
    private var characterListOffset = 0
    
    public init(characterListPublisher: CharacterListUseCaseProtocol) {
        self.characterListPublisher = characterListPublisher
    }
    
    public func getCharacterList(callback: @escaping ([MarvelCharacterDataResponse]) -> Void) {
        characterListPublisher
            .publish(request: .init(offset: characterListOffset, limit: 10))
            .sink { completion in
                //print(completion)
            } receiveValue: { [weak self] listResponse in
                //print(listResponse)
                callback(listResponse.data.results)
                self?.characterListOffset += 10
            }
            .store(in: &anyCancellables)
    }
}
