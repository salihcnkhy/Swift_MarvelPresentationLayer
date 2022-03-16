import XCTest
import MarvelDomainLayer
import DomainLayerBase
import Combine

@testable import MarvelPresentationLayer

final class MarvelPresentationLayerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//
//        let expectation = self.expectation(description: "combine")
//        let repository = MockRepository()
//        let usecaseListener = MockListener()
//        let publisher = CharacterListUseCasePublisher(repository: repository, useCaseListener: usecaseListener)
//        let router = CharacterListRouter()
//        let presenter = CharacterListPresenter()
//        let viewModel = CharacterListViewModel(characterListPublisher: publisher)
//        let viewController = CharacterListViewController(viewModel: viewModel, router: router, presenter: presenter)
//        viewController.startViewController()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            print(viewController.characterLabel.text)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10)
    }
}

//
//final class MockRepository: CharacterRepositoryProtocol {
//    func getCharacterList(with request: CharacterListRequest) -> AnyPublisher<MarvelCharacterListResponse, Error> {
//        Future { promise in
//            promise(.success(MarvelCharacterListResponse()))
//        }.eraseToAnyPublisher()
//    }
//}
//
//final class MockListener: UseCaseListenerProtocol {
//    func onPreCall() {
//        print("onPre")
//    }
//
//    func onPostCall() {
//        print("onPost")
//    }
//
//    func onError(with error: Error) {
//        print("On error ", error)
//    }
//
//}
