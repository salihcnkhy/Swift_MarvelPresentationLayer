//
//  ReusableCellProtocol.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit

public protocol ReusableCellProtocol {
    associatedtype CellModel

    static var reusableID: String { get }
    func configure(with model: CellModel)
}
