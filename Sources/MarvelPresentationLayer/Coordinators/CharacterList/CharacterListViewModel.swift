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
    func getCharacterList(resetOffset: Bool)
    func setSearchText(with text: String?)
    
    func getNetworkImageUseCase() -> NetworkImageUseCaseProtocol
}

public final class CharacterListViewModel: BaseViewModel, CharacterListViewModelProtocol {
    
    private var anyCancellables = Set<AnyCancellable>()
    
    private let fetchLimitCount = 20
    private var characterListOffset = 0
    private var lastSearchText: String? = nil
    
    @Published private var marvelCharacterList = [MarvelCharacterData]()
    
    private let characterListUseCase: CharacterListUseCaseProtocol
    private let networkImageUseCase: NetworkImageUseCaseProtocol
    
    public init(characterListPublisher: CharacterListUseCaseProtocol, networkImageUseCase: NetworkImageUseCaseProtocol) {
        self.characterListUseCase = characterListPublisher
        self.networkImageUseCase = networkImageUseCase
    }
    
    public func subscribeCharacterList(with closure: @escaping ([MarvelCharacterData]) -> Void) {
        $marvelCharacterList.sink(receiveValue: closure).store(in: &anyCancellables)
    }
    
    public func getCharacterList(resetOffset: Bool) {
        if resetOffset {
            characterListOffset = 0
        }
        characterListUseCase
            .publish(request: .init(offset: characterListOffset, limit: fetchLimitCount, nameStartsWith: lastSearchText))
            .format(CharacterListFormatter())
            .handle(receiveValue: { [weak self] model in
                guard let self = self else { return }
                self.characterListOffset += self.fetchLimitCount
                self.marvelCharacterList = model
            }, receiveError: { error in
                print(error)
            })
            .store(in: &anyCancellables)
    }
    
    public func setSearchText(with text: String?) {
        lastSearchText = text
    }
    
    public func getNetworkImageUseCase() -> NetworkImageUseCaseProtocol {
        networkImageUseCase
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
    
    func handle(receiveValue: @escaping (Output) -> Void, receiveError: ((Failure) -> Void)? = nil) -> AnyCancellable {
        self.sink { completion in
            switch completion {
                case .failure(let error):
                    receiveError?(error)
                default:
                    break
            }
        } receiveValue: { output in
            receiveValue(output)
        }
    }
}


struct CharacterListFormatter: ResponseFormatter {
    func format(_ input: MarvelCharacterListResponse) -> [MarvelCharacterData] {
        input.data.results.compactMap { $0 }
        .map {
            let thumbnail = $0.thumbnail
            // TODO: for now, when image not available do not send them to UICollectionViewCells. Later when image is not available show default image
            
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
