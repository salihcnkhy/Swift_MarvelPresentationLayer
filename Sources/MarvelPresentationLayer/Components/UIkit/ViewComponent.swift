//
//  ViewComponent.swift
//  
//
//  Created by Salihcan Kahya on 18.03.2022.
//

import UIKit
import Combine

open class ViewComponent<ComponentModel: Hashable, ComponentPresenter>: UIView {
    var modelSubject: CurrentValueSubject<ComponentModel?, Never> = .init(nil)
    
    var presenter: ComponentPresenter
    private var cancellable: AnyCancellable? = nil
    
    init(presenter: ComponentPresenter, model: ComponentModel? = nil, frame: CGRect = .zero) {
        self.presenter = presenter
        super.init(frame: frame)
        
        cancellable = self.modelSubject.sink { [weak self] model in
            guard let model = model else {
                return
            }
            
            self?.updateView(with: model)
        }
        
        self.modelSubject.send(model)
        
        setupView()
    }
    
    open func setupView() { }
    open func updateView(with model: ComponentModel) { }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
