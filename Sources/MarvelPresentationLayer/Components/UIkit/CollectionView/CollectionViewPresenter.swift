//
//  CollectionViewPresenter.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit

open class CollectionViewPresenter {

    init(itemHeight: CGFloat = 250, rowSpacing: CGFloat = 8, columnSpacing: CGFloat = 4, columnCount: Int = 2, layoutConfig: UICollectionViewCompositionalLayoutConfiguration = .init()) {
        self.layoutConfig = layoutConfig
        self.columnCount = columnCount
        self.itemHeight = itemHeight
    }
    
    public var layoutConfig: UICollectionViewCompositionalLayoutConfiguration
    public var columnCount: Int
    public var itemHeight: CGFloat
    
    open func createSection(with sectionIndex: Int, and environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        fatalError()
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
            self.createSection(with: sectionIndex, and: environment)
        }, configuration: layoutConfig)
        return layout
    }
}
