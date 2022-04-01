//
//  MarvelCharacterListCollectionView.swift
//  
//
//  Created by Salihcan Kahya on 16.03.2022.
//

import Foundation
import UIKit
import Combine
import MarvelDomainLayer

public final class MarvelCharacterListCollectionView: CollectionView {
    
    var networkImageUseCase: NetworkImageUseCaseProtocol!
    private var paginationOnProcess = false
    
    private lazy var footerLoadingIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .medium)
        temp.color = .black
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .large)
        temp.color = .black
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    public override func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(MarvelCharacterListCollectionCell.self, forCellWithReuseIdentifier: MarvelCharacterListCollectionCell.reusableID)
    }
    
    public override func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: AnyHashable) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelCharacterListCollectionCell.reusableID, for: indexPath) as? MarvelCharacterListCollectionCell,
              let item = model[indexPath.row] as? MarvelCharacterData
        else { return nil}
        
        cell.configure(with: item, and: networkImageUseCase)
        return cell
    }
    
    public override func updateView(with state: CollectionViewStateProtocol) {
        super.updateView(with: state)
        if state is CollectionViewStateOnAppendItem {
            hideWaitingDataLoadingView()
            hidePaginationLoadingView()
        } else if state is MarvelCharacterCollectionViewStateOnWaitingData {
            showWaitingDataLoadingView()
        } else if state is MarvelCharacterCollectionViewStateOnWaitingPaginationData {
            showPaginationLoadingView()
        } else if state is MarvelCharacterCollectionViewStateOnNoMoreDataForPagination {
            hidePaginationLoadingView(isOutOfData: true)
        }
    }
    
    override func addSections() {
        snapshot.appendSections(MarvelCharacterListCollectionViewSection.allCases)
    }
    
    func showWaitingDataLoadingView() {
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.fill(in: mainStackView)
    }
    
    func hideWaitingDataLoadingView() {
        loadingIndicatorView.removeFromSuperview()
    }
    
    func showPaginationLoadingView() {
        paginationOnProcess = true
        footerLoadingIndicatorView.startAnimating()
        mainStackView.addArrangedSubview(footerLoadingIndicatorView)
    }
    
    func hidePaginationLoadingView(isOutOfData: Bool = false) {
        paginationOnProcess = isOutOfData
        footerLoadingIndicatorView.removeFromSuperview()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1, !paginationOnProcess {
            eventSubject.send(MarvelCharacterCollectionViewEventStartPagination())
        }
    }
}
