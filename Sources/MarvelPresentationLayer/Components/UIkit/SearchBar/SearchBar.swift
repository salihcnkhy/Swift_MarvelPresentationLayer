//
//  SearchBar.swift
//  
//
//  Created by Salihcan Kahya on 20.03.2022.
//

import Combine
import Foundation
import UIKit

public struct SearchBarPresenter { }

final class SearchBar: ViewComponent<(old: String?, new: String?), SearchBarPresenter> {
    
    private var cancelables = Set<AnyCancellable>()
    private var lastTextOfSearchBar: String? = nil
    
    private var container: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private var searchField: UITextField = {
        let temp = UITextField()
        temp.backgroundColor = .green
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private var filterIcon: UIImageView = {
        let temp = UIImageView(image: .init(systemName: "slider.horizontal.3"))
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.tintColor = .black
        return temp
    }()
    
    override func setupView() {
        backgroundColor = .blue
        self.activate(constraints: [
            .height(constantRelation: .equalConstant(80))
        ])
        
        container.fill(in: self)
        
        container.addSubview(searchField)
        container.addSubview(filterIcon)
        
        searchField.activate(constraints: [
            .top(relation: .equal(attribute: .top(ofView: container))),
            .bottom(relation: .equal(attribute: .bottom(ofView: container))),
            .leading(relation: .equal(attribute: .leading(ofView: container))),
            .trailing(relation: .greaterThan(attribute: .leading(ofView: filterIcon), -10))
        ])
        
        filterIcon.activate(constraints: [
            .centerY(relation: .equal(attribute: .centerY(ofView: container))),
            .trailing(relation: .equal(attribute: .trailing(ofView: container), -10)),
            .width(constantRelation: .equalConstant(25)),
            .height(constantRelation: .equalConstant(25))
        ])
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchField)
            .map { ($0.object as? UITextField)?.text }
            .filter { $0 != nil }
            .sink { text in
                self.stateSubject.send((old: self.lastTextOfSearchBar, new: text))
                self.lastTextOfSearchBar = text
            }.store(in: &cancelables)
    }
}
