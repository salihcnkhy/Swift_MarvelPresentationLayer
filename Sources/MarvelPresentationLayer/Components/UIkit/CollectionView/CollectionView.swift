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
    
    case onAppendItems([ComponentData], Section)
    case onDeleteItems([ComponentData])
    case onDeleteAll
    case onDeleteSections([Section])
}

open class CollectionView<SectionType: CaseIterable & Hashable, DataType: Hashable>: ViewComponent<CollectionViewState<SectionType, DataType>, CollectionViewPresenter> {
    typealias Section = SectionType
    
    public var model: [DataType] = []
    
    var dataSource: UICollectionViewDiffableDataSource<SectionType, DataType>?
    var snapshot = NSDiffableDataSourceSnapshot<SectionType, DataType>()
    
    private lazy var collectionView: UICollectionView = {
        let temp = UICollectionView(frame: .zero, collectionViewLayout: presenter.createCompositionalLayout())
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    public override func setupView() {
        registerCells(collectionView)
        createDataSource()
        addSections()
        collectionView.fill(in: self)
    }
    
    open override func updateView(with state: CollectionViewState<SectionType, DataType>) {
        switch state {
            case .onAppendItems(let items, let section):
                appendItems(items, to: section)
            case .onDeleteAll:
                deleteAll()
            case .onDeleteItems(let items):
                deleteItems(items)
            case .onDeleteSections(let sections):
                deleteSection(sections)
        }
    }
    
    private func createDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    func addSections() {
        let sections = Section.allCases as? [Section]
        snapshot.appendSections(sections ?? [])
    }
    
    func appendItems(_ items: [DataType], to section: Section) {
        model.append(contentsOf: items)
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot)
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
}
