//
//  MarvelCoordinator.swift
//  MarvelApp
//
//  Created by Salihcan Kahya on 4.04.2022.
//

import Foundation
import PresentationLayerBase

public protocol CoordinatorIdentifier {
    var coordinator: CoordinatorProtocol { get }
}

public enum MarvelCoordinator: CoordinatorIdentifier, AssemblerResolverProtocol {
    
    case app
    case tabBar
    case characterList
    case characterDetail
    case comicsList
    
    public var coordinator: CoordinatorProtocol {
        switch self {
            case .app:
                return generateCoordinator(AppCoordinator.self)
            case .tabBar:
                return generateCoordinator(MainCoordinator.self)
            case .characterList:
                return generateCoordinator(CharacterListCoordinator.self)
            case .characterDetail:
                return generateCoordinator(CharacterDetailCoordinator.self)
            case .comicsList:
                return generateCoordinator(CharacterListCoordinator.self)
        }
    }
    
    private func generateCoordinator<Coordinator: CoordinatorProtocol>(_ type: Coordinator.Type) -> Coordinator {
        guard let coordinator = returnResolver().resolve(Coordinator.self) else { fatalError("Coordinator Resolve error") }
        return coordinator
    }
}
