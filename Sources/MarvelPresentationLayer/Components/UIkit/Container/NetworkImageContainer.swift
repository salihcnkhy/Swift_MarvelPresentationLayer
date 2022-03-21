//
//  NetworkImageContainer.swift
//  
//
//  Created by Salihcan Kahya on 20.03.2022.
//

import Combine
import Foundation
import UIKit

public struct NetworkImageContainerData {
    let id: String
    let url: String
}
public struct NetworkImageContainerPresenter { }

public final class NetworkImageContainer: ViewComponent<NetworkImageContainerData, NetworkImageContainerPresenter> {
    
    var cancellable: AnyCancellable?
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.clipsToBounds = true
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    public override func setupView() {
        imageView.fill(in: self)
    }
    
    public override func updateView(with model: NetworkImageContainerData) {
        guard let url = URL(string: model.url) else { return }
        print(url)
        cancellable = URLSession.shared.dataTaskPublisher(for: url).handleEvents { _ in
            Swift.print("image subs received")
            DispatchQueue.main.async {
                self.imageView.image = UIImage(systemName: "paperplane.fill")
            }
        } receiveOutput: { data, response in
            Swift.print("image output")
        } receiveCompletion: { completion in
            Swift.print("image Completion")
        }
        .sink { completion in
            Swift.print("image Completion sink")
        } receiveValue: { output in
            Swift.print("image output sink")
            guard let image = UIImage(data: output.data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                
            }
        }
    }
}
