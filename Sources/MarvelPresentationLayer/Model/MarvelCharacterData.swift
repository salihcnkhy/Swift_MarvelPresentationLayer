//
//  MarvelCharacterData.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import Foundation

public struct MarvelCharacterData: Hashable {
    public let id: String = UUID().uuidString
    public let name: String
}
