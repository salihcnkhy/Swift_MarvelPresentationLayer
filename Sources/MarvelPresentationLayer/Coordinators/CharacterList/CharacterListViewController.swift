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
    
    private var cancellables = Set<AnyCancellable>()

    public lazy var characterLabel: TestView = {
        let temp = TestView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.addBorder(with: 1, and: .black)
        return temp
    }()
    
    public override func startViewController() {
        setViews()
        bindViewModel()
    }
    
    private func setViews() {
        characterLabel.setData(binder: presenter.characterListPublisher).store(in: &cancellables)
        
        view.addSubview(characterLabel)
        characterLabel.addCenterXConstraint()
        characterLabel.addCenterYConstraint()
        characterLabel.activate(constraints: [
            .height(constantRelation: .equalConstant(80)),
            .width(constantRelation: .equalConstant(200))
        ])
        
        presenter.characterListPublisher.sink { model in
            print(model)
        }.store(in: &cancellables)
    }
    
    private func bindViewModel() {
        viewModel.getCharacterList(assign: &presenter.characterListPublisher)
    }
}


public final class TestView: UILabel {
    func setData(binder: Published<CharacterListModel>.Publisher) -> AnyCancellable {
        binder.compactMap { $0.id }.assign(to: \.text, on: self)
    }
}
