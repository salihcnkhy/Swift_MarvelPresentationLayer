//
//  File.swift
//  
//
//  Created by 112471 on 4.04.2022.
//

import Foundation
import UIKit
import PresentationLayerBase

public final class MainTabViewController: BaseViewController<MainViewModelProtocol, MainRouterProtocol, MainPresenterProtocol>, UITabBarControllerDelegate {
    
    public override func startViewController() {
        view.backgroundColor = .white
        setupTabBar()
    }
    
    func setupTabBar() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = router.getNavigationControllers()
        guard let items = tabBarController.tabBar.items else { return }
        for item in items {
            item.imageInsets = .init(top: 10, left: 0, bottom: -5, right: 0)
        }
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tabBarController.didMove(toParent: self)
    }
}
