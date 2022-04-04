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
        temp.networkImageUseCase = viewModel.getNetworkImageUseCase()
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
    
    private var cancellables = Set<AnyCancellable>()
    
    public override func startViewController() {
        overrideUserInterfaceStyle = .light
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        let apperance = UINavigationBarAppearance()
        apperance.configureWithOpaqueBackground()
        apperance.backgroundColor = .white
        apperance.titleTextAttributes = [.foregroundColor: UIColor.black]
        apperance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Character List"
        
        setViews()
        bindComponents()
        bindViewModel()
        getCharacterList(resetOffset: true)
    }
    
    private func setViews() {
        mainStackView.fill(in: view, with: .init(top: 0, left: 10, bottom: 50, right: 10))
    }
    
    private func bindComponents() {
        bindSearchBar()
        bindCollectionView()
    }
}

// MARK: - ViewModel Bindings -

extension CharacterListViewController {
    private func bindViewModel() {
        viewModel.subscribeCharacterList { [weak self] model in
            self?.handleCharacterListResponse(model)
        }
    }
    
    private func getCharacterList(resetOffset: Bool = false) {
        if resetOffset {
            characterCollectionView.stateSubject.send(MarvelCharacterCollectionViewStateOnWaitingData())
        }
        viewModel.getCharacterList(resetOffset: resetOffset)
    }
    
    private func handleCharacterListResponse(_ model: [MarvelCharacterData]) {
        if !model.isEmpty {
            characterCollectionView.stateSubject.send(CollectionViewStateOnAppendItem(items: model, section: MarvelCharacterListCollectionViewSection.allList))
        } else {
            characterCollectionView.stateSubject.send(MarvelCharacterCollectionViewStateOnNoMoreDataForPagination())
        }
    }
}

// MARK: - Component Bindings -

// MARK: - SearchBar functions
extension CharacterListViewController {
    private func bindSearchBar() {
        searchBar.stateSubject
            .filter { $0.old != $0.new }
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] oldText, newText in
                guard let new = newText else { return }
                self?.handleSearchedText(with: new)
            }.store(in: &cancellables)
    }
    
    private func handleSearchedText(with newText: String) {
        if newText.isEmpty {
            characterCollectionView.stateSubject.send(CollectionViewStateOnDeleteAll())
            viewModel.setSearchText(with: nil)
            getCharacterList(resetOffset: true)
        } else if newText.count > 1 {
            characterCollectionView.stateSubject.send(CollectionViewStateOnDeleteAll())
            viewModel.setSearchText(with: newText)
            getCharacterList(resetOffset: true)
        }
    }
}

// MARK: - CollectionView functions
extension CharacterListViewController {
    private func bindCollectionView() {
        characterCollectionView.eventSubject.sink { [weak self] event in
            if let event = event as? CollectionViewEventOnItemSelection {
                if let item = event.item as? MarvelCharacterData {
                    self?.onCollectionViewItemSelection(item)
                }
            } else if let _ = event as? MarvelCharacterCollectionViewEventStartPagination {
                self?.onCollectionViewStartPagination()
            }
        }.store(in: &cancellables)
    }
    
    private func onCollectionViewItemSelection(_ item: MarvelCharacterData) {
        router.presentCharacterDetail(with: item)
        print("http://i.annihil.us/u/prod/marvel/i/mg/\(item.image.createPathString())")
    }
    
    private func onCollectionViewStartPagination() {
        characterCollectionView.stateSubject.send(MarvelCharacterCollectionViewStateOnWaitingPaginationData())
        getCharacterList()
    }
}
