//
//  CollectionView.swift
//  
//
//  Created by 112471 on 17.03.2022.
//

import UIKit

public protocol UIStateProtocol {
    associatedtype ComponentData
}

public enum CollectionViewState<SectionType: Hashable & CaseIterable, DataType: Hashable>: UIStateProtocol {
    public typealias ComponentData = DataType
    public typealias Section = SectionType
    
    case empty
    case onAppendItems([ComponentData], Section)
    case onDeleteItems([ComponentData])
    case onDeleteAll
    case onDeleteSections([Section])
    case onWaitingData
    case onWaitingPaginationData
    case noMoreDataForPagination
}

public enum CollectionViewEvent<DataType: Hashable> {
    case onItemSelection(DataType)
    case readyForPagination
}

open class CollectionView<SectionType: CaseIterable & Hashable, DataType: Hashable>: ViewComponent<CollectionViewState<SectionType, DataType>, CollectionViewEvent<DataType>, CollectionViewPresenter<SectionType>>, UICollectionViewDelegate {
    typealias Section = SectionType
    
    public var model: [DataType] = []
    private var paginationOnProcess = false
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, DataType>?
    var snapshot = NSDiffableDataSourceSnapshot<SectionType, DataType>()
    
    private lazy var collectionView: UICollectionView = {
        let temp = UICollectionView(frame: .zero, collectionViewLayout: presenter.createCompositionalLayout())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.delegate = self
        backgroundColor = .clear
        return temp
    }()
    
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
    
    private lazy var mainStackView: UIStackView = {
        let temp = UIStackView(arrangedSubviews: [collectionView])
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.axis = .vertical
        temp.alignment = .fill
        temp.distribution = .fill
        temp.spacing = 15
        temp.backgroundColor = .clear
        return temp
    }()
    
    public override func setupView() {
        backgroundColor = .clear
        registerCells(collectionView)
        createDataSource()
        addSections()
        mainStackView.fill(in: self)
    }
    
    open override func updateView(with state: CollectionViewState<SectionType, DataType>) {
        switch state {
            case .empty:
                break
            case .onAppendItems(let items, let section):
                appendItems(items, to: section)
            case .onDeleteAll:
                deleteAll()
            case .onDeleteItems(let items):
                deleteItems(items)
            case .onDeleteSections(let sections):
                deleteSection(sections)
            case .onWaitingData:
                showWaitingDataLoadingView()
            case .onWaitingPaginationData:
                showPaginationLoadingView()
            case .noMoreDataForPagination:
                hidePaginationLoadingView(isOutOfData: true)
        }
    }
    
    private func createDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
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
    
    func addSections() {
        let sections = Section.allCases as? [Section]
        snapshot.appendSections(sections ?? [])
    }
    
    func appendItems(_ items: [DataType], to section: Section) {
        model.append(contentsOf: items)
        snapshot.appendItems(items, toSection: section)
        dataSource?.applySnapshotUsingReloadData(snapshot)
        hidePaginationLoadingView()
        hideWaitingDataLoadingView()
    }
    
    func deleteItems(_ items: [DataType]) {
        snapshot.deleteItems(items)
        dataSource?.apply(snapshot)
    }
    
    func deleteAll() {
        model.removeAll()
        snapshot.deleteAllItems()
        dataSource?.apply(snapshot)
        addSections()
    }
    
    func deleteSection(_ sections: [Section]) {
        snapshot.deleteSections(sections)
    }
    
    open func registerCells(_ collectionView: UICollectionView) {
        
    }
    
    open func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: DataType) -> UICollectionViewCell? {
        fatalError()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        eventSubject.send(.onItemSelection(item))
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.count - 1, !paginationOnProcess {
            eventSubject.send(.readyForPagination)
        }
    }
}
