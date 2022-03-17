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
    
    public lazy var characterCollectionView: MarvelCharacterListCollectionView = {
        let temp = MarvelCharacterListCollectionView(presenter: presenter.characterCollectionViewPresenter)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    public override func startViewController() {
        setViews()
        view.backgroundColor = .white
        bindViewModel()
    }
    
    private func setViews() {
        characterCollectionView.fill(in: view)
    }
    
    private func bindViewModel() {
        viewModel.getCharacterList { [weak self] model in
            guard let self = self else { return }
            self.characterCollectionView.modelSubject.send(self.presenter.getMarvelListData(model))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.viewModel.getCharacterList {  model in
                guard let self = self else { return }
                self.characterCollectionView.modelSubject.send(self.presenter.getMarvelListData(model))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.viewModel.getCharacterList {  model in
                guard let self = self else { return }
                self.characterCollectionView.modelSubject.send(self.presenter.getMarvelListData(model))
            }
        }
    }
}
