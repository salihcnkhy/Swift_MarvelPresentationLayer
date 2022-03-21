//
//  ViewComponent.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit
import Combine

open class ViewComponent<ComponentState, ComponentPresenter>: UIView {
    var stateSubject = PassthroughSubject<ComponentState, Never>()
    
    var presenter: ComponentPresenter
    private var anyCancellables = Set<AnyCancellable>()
    
    init(presenter: ComponentPresenter, state: ComponentState? = nil, frame: CGRect = .zero) {
        self.presenter = presenter
        super.init(frame: frame)
        setupView()
        
        stateSubject.sink { [weak self] state in
            self?.updateView(with: state)
        }.store(in: &anyCancellables)
        
        if let state = state {
            self.stateSubject.send(state)
        }
    }
    
    open func setupView() { }
    open func updateView(with state: ComponentState) { }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
