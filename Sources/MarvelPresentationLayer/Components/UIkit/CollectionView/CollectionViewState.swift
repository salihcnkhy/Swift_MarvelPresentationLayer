//
//  CollectionViewState.swift
//  
//
//  Created by Salihcan Kahya on 1.04.2022.
//

import Foundation

public protocol CollectionViewStateProtocol { }

public struct CollectionViewInit: CollectionViewStateProtocol {}

public struct CollectionViewStateOnAppendItem<Item: Hashable>: CollectionViewStateProtocol {
    let items: [Item]
    let section: AnyHashable
    
    init(items: [Item], section: AnyHashable) {
        self.items = items
        self.section = section
    }
}

public struct CollectionViewStateOnDeleteItem<Item: Hashable>: CollectionViewStateProtocol {
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

public struct CollectionViewStateOnDeleteAll: CollectionViewStateProtocol { }


public struct CollectionViewStateOnDeleteSections: CollectionViewStateProtocol {
    let sections: [AnyHashable]
}
