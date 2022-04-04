//
//  File.swift
//  
//
//  Created by 112471 on 22.02.2022.
//

import PresentationLayerBase

public protocol CharacterListRouterProtocol {
    func presentCharacterDetail(with detailModel: MarvelCharacterData)
}

public final class CharacterListRouter: BaseRouter, CharacterListRouterProtocol {
    public func presentCharacterDetail(with detailModel: MarvelCharacterData) {
        present(with: MarvelCoordinator.characterDetail.coordinator, presentationStyle: .popover, transitionStyle: .crossDissolve)
    }
}
