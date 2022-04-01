//
//  CollectionViewState.swift
//  
//
//  Created by Salihcan Kahya on 1.04.2022.
//

import Foundation

public protocol CollectionViewStateProtocol { }

public struct CollectionViewInit: CollectionViewStateProtocol {}

public struct CollectionViewStateOnAppendItem: CollectionViewStateProtocol {
    let items: [AnyHashable]
    let section: AnyHashable
    
    init(items: [AnyHashable], section: AnyHashable) {
        self.items = items
        self.section = section
    }
}

public struct CollectionViewStateOnDeleteItem: CollectionViewStateProtocol {
    let items: [AnyHashable]
    
    init(items: [AnyHashable]) {
        self.items = items
    }
}

public struct CollectionViewStateOnDeleteAll: CollectionViewStateProtocol { }


public struct CollectionViewStateOnDeleteSections: CollectionViewStateProtocol {
    let sections: [AnyHashable]
}
