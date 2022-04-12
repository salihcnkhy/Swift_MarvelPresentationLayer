//
//  File.swift
//  
//
//  Created by 112471 on 12.04.2022.
//

import UIKit
import PresentationLayerBase

public protocol MarvelAppRouterProtocol: AppRouterProtocol {
    
}

public final class MarvelAppRouter: BaseRouter, MarvelAppRouterProtocol {
    public var window: UIWindow?
    
    
}
