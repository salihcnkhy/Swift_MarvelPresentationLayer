//
//  CollectionView.swift
//  
//
//  Created by Salihcan Kahya on 17.03.2022.
//

import UIKit

open class CollectionView: ViewComponent<CollectionViewStateProtocol, CollectionViewEventProtocol, CollectionViewPresenter>, UICollectionViewDelegate {
    public typealias Section = AnyHashable
    public typealias Item = AnyHashable
    
    public var model: [Item] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    lazy var collectionView: UICollectionView = {
        let temp = UICollectionView(frame: .zero, collectionViewLayout: presenter.createCompositionalLayout())
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.delegate = self
        backgroundColor = .clear
        return temp
    }()
    
    lazy var mainStackView: UIStackView = {
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
    
    // TODO: Think more affective way to handle states. Maybe State could be responsible of handling not there ??
    open override func updateView(with state: CollectionViewStateProtocol) {
        if let state = state as? CollectionViewStateOnAppendItem {
            appendItems(state.items, to: state.section)
        } else if let state = state as? CollectionViewStateOnDeleteItem {
            deleteItems(state.items)
        } else if let _ = state as? CollectionViewStateOnDeleteAll {
            deleteAll()
        } else if let state = state as? CollectionViewStateOnDeleteSections {
            deleteSection(state.sections)
        }
    }
    
    private func createDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    func addSections() {
        fatalError()
    }
    
    func appendItems(_ items: [Item], to section: Section) {
        model.append(contentsOf: items)
        snapshot.appendItems(items, toSection: section)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func deleteItems(_ items: [Item]) {
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
    
    open func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: Item) -> UICollectionViewCell? {
        fatalError()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        eventSubject.send(CollectionViewEventOnItemSelection(item: item))
    }
}
