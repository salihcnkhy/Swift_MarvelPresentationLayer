//
//  Assembler+.swift
//  MarvelApp
//
//  Created by Salihcan Kahya on 16.03.2022.
//

import Foundation
import Swinject

public extension Assembler {
    static let sharedAssembler: Assembler = {
        let container = Container()
        let assembler = Assembler()
        return assembler
    }()
}
