//
//  CharacterListViewController.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase
import UIKit
import Combine
import Swiftlities

public final class CharacterListViewController: BaseViewController<CharacterListViewModelProtocol, CharacterListRouterProtocol, CharacterListPresenterProtocol> {
    
    
    public lazy var characterLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.addBorder(with: 1, and: .black)
        return temp
    }()
    
    public override func startViewController() {
        setViews()
        bindViewModel()
    }
    
    private func setViews() {
        view.addSubview(characterLabel)
        characterLabel.addCenterXConstraint()
        characterLabel.addCenterYConstraint()
        characterLabel.activate(constraints: [
            .height(constantRelation: .equalConstant(80)),
            .width(constantRelation: .equalConstant(200))
        ])
    }
    
    private func bindViewModel() {
        viewModel.getCharacterList()
    }
}
