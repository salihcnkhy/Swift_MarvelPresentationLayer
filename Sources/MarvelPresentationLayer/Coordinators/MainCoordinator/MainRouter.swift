//
//  File.swift
//  
//
//  Created by 112471 on 4.04.2022.
//

import Foundation
import PresentationLayerBase
import UIKit

public protocol MainRouterProtocol {
    func getNavigationControllers() -> [UINavigationController]
    
}

public final class MainRouter: BaseRouter, MainRouterProtocol {
    
    public func getNavigationControllers() -> [UINavigationController] {
        let characterListCoordinator = MarvelCoordinator.characterList.coordinator
        let comicsListCoordinator = MarvelCoordinator.characterDetail.coordinator
        
        coordinator?.start(with: characterListCoordinator)
        coordinator?.start(with: comicsListCoordinator)

        let characterListNavigationController = UINavigationController(rootViewController: characterListCoordinator.viewController!)
        characterListNavigationController.tabBarItem.selectedImage = UIImage(systemName: "square.and.arrow.up")
        characterListNavigationController.tabBarItem.image = UIImage(systemName: "square.and.arrow.up.fill")
        characterListCoordinator.navigationController = characterListNavigationController
        
        let comicsListNavigationController = UINavigationController(rootViewController: comicsListCoordinator.viewController!)
        comicsListNavigationController.tabBarItem.selectedImage = UIImage(systemName: "square.and.arrow.up")
        comicsListNavigationController.tabBarItem.image = UIImage(systemName: "square.and.arrow.up.fill")
        comicsListCoordinator.navigationController = comicsListNavigationController
        
        return [
            characterListNavigationController,
            comicsListNavigationController
        ]
    }
}
