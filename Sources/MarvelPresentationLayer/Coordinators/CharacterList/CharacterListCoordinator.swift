//
//  CharacterListCoordinator.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase

public final class CharacterListCoordinator: BaseCoordinator<CharacterListViewModelProtocol, CharacterListRouterProtocol, CharacterListPresenterProtocol> {
    public override func start() {
        viewController = CharacterListViewController(viewModel: viewModel, router: router, presenter: presenter)
    }
}
