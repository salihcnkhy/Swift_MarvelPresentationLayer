//
//  CollectionView.swift
//  
//
//  Created by 112471 on 17.03.2022.
//

import UIKit

open class CollectionView<SectionType: Hashable, DataType: Hashable>: ViewComponent<[DataType], CollectionViewPresenter> {
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
    
    public override func updateView(with model: [DataType]) {
        self.model.append(contentsOf: model)
        reloadData(with: model)
    }
    
    private func createDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    open func addSections() {
        fatalError()
    }
    
    open func registerCells(_ collectionView: UICollectionView) {
        
    }
    
    open func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: DataType) -> UICollectionViewCell? {
        fatalError()
    }
    
    open func reloadData(with model: [DataType]) {
        fatalError()
    }
}
