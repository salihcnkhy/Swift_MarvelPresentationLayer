//
//  File.swift
//  
//
//  Created by 112471 on 4.04.2022.
//

import Foundation
import PresentationLayerBase
import UIKit

public final class MainCoordinator: BaseCoordinator<MainViewModelProtocol, MainRouterProtocol, MainPresenterProtocol> {
    
    public func startApp(window: UIWindow) {
        start()
        let navigationViewController = UINavigationController(rootViewController: viewController!)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.navigationController = navigationViewController
    }
    
    public override func start() {
        viewController = MainTabViewController(viewModel: viewModel, router: router, presenter: presenter)
    }
}
