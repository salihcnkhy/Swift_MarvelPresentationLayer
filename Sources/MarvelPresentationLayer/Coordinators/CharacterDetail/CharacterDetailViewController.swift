//
//  File.swift
//  
//
//  Created by 112471 on 3.04.2022.
//

import Foundation
import PresentationLayerBase

public final class CharacterDetailViewController: BaseViewController<CharacterDetailViewModelProtocol, CharacterDetailRouterProtocol, CharacterDetailPresenterProtocol> {
    public override func startViewController() {
        view.backgroundColor = .blue
    }
}
