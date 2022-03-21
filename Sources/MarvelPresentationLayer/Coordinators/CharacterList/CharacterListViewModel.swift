//
//  CharacterListViewModel.swift
//  
//
//  Created by Salihcan Kahya on 22.02.2022.
//

import PresentationLayerBase
import MarvelDomainLayer
import Combine
import SwiftUI

public protocol CharacterListViewModelProtocol {
    func subscribeCharacterList(with closure: @escaping ([MarvelCharacterData]) -> Void)
    func getCharacterList(with searchText: String?, resetOffset: Bool)
}

public final class CharacterListViewModel: BaseViewModel, CharacterListViewModelProtocol {
    
    private var anyCancellables = Set<AnyCancellable>()
    
    private let fetchLimitCount = 10
    private var characterListOffset = 0
    
    @Published private var marvelCharacterList = [MarvelCharacterData]()
    private let characterListUseCase: CharacterListUseCaseProtocol
    
    
    public init(characterListPublisher: CharacterListUseCaseProtocol) {
        self.characterListUseCase = characterListPublisher
    }
    
    public func subscribeCharacterList(with closure: @escaping ([MarvelCharacterData]) -> Void) {
        $marvelCharacterList.sink(receiveValue: closure).store(in: &anyCancellables)
    }
    
    public func getCharacterList(with searchText: String?, resetOffset: Bool) {
        characterListUseCase
            .publish(request: .init(offset: characterListOffset, limit: fetchLimitCount, nameStartsWith: searchText))
            .format(CharacterListFormatter())
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] model in
                guard let self = self else { return }
                if resetOffset {
                    self.characterListOffset = 0
                } else {
                    self.characterListOffset += self.fetchLimitCount
                }
                
                self.marvelCharacterList = model
            }.store(in: &anyCancellables)
    }
}

protocol ResponseFormatter {
    associatedtype Input
    associatedtype Output
    func format(_ input: Input) -> Output
}

extension Publisher {
    func format<ResponseFormatterType: ResponseFormatter, Formatted>(_ formatter: ResponseFormatterType) -> AnyPublisher<Formatted, Failure>
    where Output == ResponseFormatterType.Input, Formatted == ResponseFormatterType.Output {
        self.compactMap { formatter.format($0) }.eraseToAnyPublisher()
    }
}


struct CharacterListFormatter: ResponseFormatter {
    func format(_ input: MarvelCharacterListResponse) -> [MarvelCharacterData] {
        input.data.results.compactMap {
            let thumbnail = $0.thumbnail
            // TODO: for now, when image not available do not send them to UICollectionViewCells. Later when image is not available show default image
            guard thumbnail.thumbnailExtension != .gif
            else { return nil }
            
            return MarvelCharacterData(
                id: "\($0.id)",
                name: $0.name,
                image: .init(
                    path: thumbnail.path,
                    pathExtension: .jpg,
                    variantName: .potraitIncredible
                )
            )
        }
    }
}
