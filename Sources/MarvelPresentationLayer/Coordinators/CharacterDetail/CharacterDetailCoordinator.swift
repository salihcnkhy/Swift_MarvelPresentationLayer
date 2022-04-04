//
//  File.swift
//  
//
//  Created by 112471 on 3.04.2022.
//

import Foundation
import PresentationLayerBase

public final class CharacterDetailCoordinator: BaseCoordinator<CharacterDetailViewModelProtocol, CharacterDetailRouterProtocol, CharacterDetailPresenterProtocol> {
    public override func start() {
        viewController = CharacterDetailViewController(viewModel: viewModel, router: router, presenter: presenter)
    }
}
