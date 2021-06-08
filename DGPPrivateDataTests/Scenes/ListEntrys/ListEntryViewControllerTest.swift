//
//  ListEntryViewControllerTest.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 7/6/21.
//

import Foundation
import XCTest
@testable import DGPPrivateData

class ListEntryViewControllerTest: XCTestCase {
    
    func test_searchBar_textDidChange_emptyText() {
        let (sut, spy) = makeSUT()
        let searchText = ""
        sut.searchBar(sut.searchBar!, textDidChange: searchText)
        XCTAssertEqual(spy.requestedFilters,[searchText])
    }
    
    func test_searchBar_textDidChange_multipleText() {
        let (sut, spy) = makeSUT()
        let searchSearchs = ["", "searching", "", "another one"]
        
        searchSearchs.forEach { searchText in
            sut.searchBar(sut.searchBar!, textDidChange: searchText)
        }
        
        XCTAssertEqual(spy.requestedFilters,searchSearchs)
    }
    
    //MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ListEntryViewController, spy: ListEntryInteractorSpy) {
        let sut = ListEntryViewController.instantiate()
        let spy = ListEntryInteractorSpy()
        sut.interactor = spy
        _ = sut.view
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy)
    }
}

class ListEntryInteractorSpy: ListEntryBusinessLogic {
    
    var requestedFilters: [String] = []
    
    func doLoadInitialData(request: ListEntryScene.Load.Request) {
        
    }
    
    func doFilterByText(request: ListEntryScene.FilterBy.Request) {
        requestedFilters.append(request.text)
    }
    
    
}
