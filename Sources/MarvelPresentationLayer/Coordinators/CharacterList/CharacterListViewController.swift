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
    
    private lazy var searchBar: SearchBar = {
        let temp = SearchBar(presenter: presenter.searchbarPresenter)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var characterCollectionView: MarvelCharacterListCollectionView = {
        let temp = MarvelCharacterListCollectionView(presenter: presenter.characterCollectionViewPresenter)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var mainStackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [searchBar, characterCollectionView])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.alignment = .fill
        temp.distribution = .fill
        temp.spacing = 5
        temp.axis = .vertical
        return temp
    }()
    
    var cancellables = Set<AnyCancellable>()
    
    public override func startViewController() {
        setViews()
        view.backgroundColor = .white
        bindComponents()
        bindViewModel()
        getCharacterList()
    }
    
    private func setViews() {
        mainStackView.fill(in: view, with: .init(top: 50, left: 0, bottom: 0, right: 0 ))
    }
    
    private func bindComponents() {
        searchBar.stateSubject
            .filter { $0.old != $0.new }
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] oldText, newText in
                guard let new = newText else { return }
                if new.isEmpty {
                    self?.characterCollectionView.stateSubject.send(.onDeleteAll)
                    self?.getCharacterList(resetOffset: true)
                } else if new.count > 1 {
                    self?.characterCollectionView.stateSubject.send(.onDeleteAll)
                    self?.getCharacterList(newText, resetOffset: true)
                }
            }.store(in: &cancellables)
    }
    
    private func bindViewModel() {
        viewModel.subscribeCharacterList { [weak self] model in
            self?.handleCharacterListResponse(model)
        }
    }
    
    private func getCharacterList(_ startsWith: String? = nil, resetOffset: Bool = false) {
        viewModel.getCharacterList(with: startsWith, resetOffset: resetOffset)
    }
    
    private func handleCharacterListResponse(_ model: [MarvelCharacterData]) {
        characterCollectionView.stateSubject.send(.onAppendItems(model, .allList))
    }
}
