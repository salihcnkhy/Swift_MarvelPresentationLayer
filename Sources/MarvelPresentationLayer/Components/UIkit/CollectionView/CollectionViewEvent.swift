//
//  CollectionViewEvent.swift
//  
//
//  Created by Salihcan Kahya on 1.04.2022.
//

import Foundation

public protocol CollectionViewEventProtocol { }

public struct CollectionViewEventOnItemSelection: CollectionViewEventProtocol {
    let item: AnyHashable
    
    init(item: AnyHashable) {
        self.item = item
    }
}
