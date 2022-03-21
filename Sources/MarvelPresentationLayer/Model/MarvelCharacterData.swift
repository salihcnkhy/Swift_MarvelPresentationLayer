//
//  MarvelCharacterData.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import Foundation

public struct MarvelCharacterData: Hashable {
    public let id: String
    public let name: String
    public let image: MarvelCharacterImageData
}

public struct MarvelCharacterImageData: Hashable {
    public let path: String
    public let pathExtension: MarvelCharacterImagePathExtension
    public let variantName: MarvelCharacherImageVariant
    
    public func createUrlString() -> String {
        "\(path)/\(variantName.rawValue).\(pathExtension)"
    }
}

public enum MarvelCharacterImagePathExtension: String {
    case jpg
    case gif
}

public enum MarvelCharacherImageVariant: String {
    
    // MARK: - Portaits
    /// 50x75
    case potraitSmall = "portrait_small"
    /// 100x150
    case potraitMedium = "portrait_medium"
    /// 216x324
    case potraitIncredible = "portrait_incredible"
    
    // MARK: - Standards
    /// 65x45
    case standardSmall = "standard_small"
    /// 100x100
    case standardMedium = "standart_medium"
    
    // MARK: - Landscape
    /// 190x140
    case landScapeLarge = "landscape_large"
}
