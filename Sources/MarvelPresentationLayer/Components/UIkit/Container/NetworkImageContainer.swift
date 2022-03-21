//
//  NetworkImageContainer.swift
//  
//
//  Created by Salihcan Kahya on 20.03.2022.
//

import Combine
import Foundation
import UIKit
import MarvelDomainLayer

public enum NetworkImageState {
    case load(NetworkImageContainerData)
    case setImage(UIImage)
    case onErrorView
    case onLoadingView
}

public struct NetworkImageEvent { }


public struct NetworkImageContainerData {
    let id: String
    let path: String
}

public struct NetworkImageContainerPresenter { }

public final class NetworkImageContainer: ViewComponent<NetworkImageState, NetworkImageEvent, NetworkImageContainerPresenter> {
    
    private var cancellable: AnyCancellable?
    var networkImageUseCase: NetworkImageUseCaseProtocol!
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.clipsToBounds = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var overlayView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .quaternaryLabel.withAlphaComponent(0.2)
        return temp
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView(style: .medium)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var errorView: UIView = {
        let temp = UIView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.backgroundColor = .gray
        return temp
    }()
    
    public override func setupView() {
        imageView.fill(in: self)
        overlayView.fill(in: imageView)
    }
    
    public override func updateView(with state: NetworkImageState) {
        overlayView.subviews.forEach { $0.removeFromSuperview() }
        
        switch state {
            case .setImage(let image):
                self.imageView.image = image
            case .load(let networkImageContainerData):
                loadImage(networkImageContainerData)
            case .onErrorView:
                setErrorView()
            case .onLoadingView:
                setErrorView()
        }
    }
    
    private func setLoadingView() {
        loadingIndicatorView.activate(constraints: [
            .centerX(relation: .equal(attribute: .centerX(ofView: overlayView))),
            .centerY(relation: .equal(attribute: .centerY(ofView: overlayView))),
        ])
    }
    
    private func setErrorView() {
        errorView.fill(in: overlayView)
    }
    
    private func loadImage(_ model: NetworkImageContainerData) {
        
//        if let cacheImage = model.getFromCache() {
//            print("loaded from cache \(model.id)")
//            stateSubject.send(.setImage(cacheImage))
//            return
//        }
//
//        stateSubject.send(.onLoadingView)
//
//        guard let url = URL(string: model.url) else {
//            stateSubject.send(.onErrorView)
//            return
//        }
//
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//            .map { UIImage(data: $0.data) }
//            .sink { [weak self] completion in
//                switch completion {
//                    case .failure(_):
//                        self?.stateSubject.send(.onErrorView)
//                    default:
//                        break
//                }
//            } receiveValue: { [weak self] image in
//                guard let image = image else {
//                    self?.stateSubject.send(.onErrorView)
//                    return
//                }
//                print("loaded from url \(model.id)")
//                model.setToCache(image)
//                self?.stateSubject.send(.setImage(image))
//            }
//
        stateSubject.send(.onLoadingView)
        
        cancellable = networkImageUseCase
            .publish(request: .init(path: model.path))
            .sink { [weak self] completion in
                switch completion {
                    case .failure(_):
                        self?.stateSubject.send(.onErrorView)
                    default:
                        break
                }
            } receiveValue: { [weak self] image in
                guard let image = image else {
                    self?.stateSubject.send(.onErrorView)
                    return
                }
                self?.stateSubject.send(.setImage(image))
            }
    }
}

class ImageCacheProvider {
    
}
