//
//  AddEditEntryUseCaseTests.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 20/6/21.
//

import XCTest
@testable import DGPPrivateData

class AddEditEntryUseCaseTests: XCTestCase {

    func test_saveEntry_withNoTitle_displayError() {
        let (sut, _, presenter) = makeSUT()
        sut.loadInitialData()
        sut.saveEntry()

        XCTAssertEqual(presenter.receivedErrors.count, 1)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: AddEditEntryViewController, interactor: AddEditEntryInteractor, presenter: AddEditPresenterSpy) {
        let sut = AddEditEntryViewController.instantiate()
        let interactor = AddEditEntryInteractor()
        let presenter = AddEditPresenterSpy()
        
        sut.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = sut
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(interactor, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        
        _ = sut.view
        
        return (sut, interactor, presenter)
    }
    
    private class AddEditPresenterSpy: AddEditEntryPresenter {
        
        var receivedErrors: [Error] = []
        
        override func presentError(error: Error) {
            receivedErrors.append(error)
        }
    }

}
