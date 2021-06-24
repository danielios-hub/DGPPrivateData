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
    
    //MARK: - TableView
    
    func test_displayListEntries_withZeroSections_doesNotRenderSections() {
        let (sut, _) = makeSUT()
        
        let viewModel = ListEntryScene.Load.ViewModel(sections: [], displaySections: true)
        sut.displayListEntries(viewModel: viewModel)
        XCTAssertEqual(sut.tableView.numberOfSections, 0)
    }
    
    func test_displayListEntries_withOneSections_withNoRows_renderZeroRows() {
        let (sut, _) = makeSUT()
        
        let section = ListEntrySection(name: "", icon: "", cellsModel: [])
        let viewModel = ListEntryScene.Load.ViewModel(sections: [section], displaySections: true)
        
        sut.displayListEntries(viewModel: viewModel)
        XCTAssertEqual(sut.tableView.numberOfSections, 1)
        XCTAssertEqual(sut.tableView.numberOfRows(section: 0), 0)
    }
    
    func test_displayListEntries_withOneSections_withOneRows_renderRow() {
        let (sut, _) = makeSUT()
        
        let section = ListEntrySection(name: "", icon: "", cellsModel: [
            ListEntryCellViewModel(title: "", icon: "", categoryDescription: "")
        ])
        
        let viewModel = ListEntryScene.Load.ViewModel(sections: [section], displaySections: true)
        
        sut.displayListEntries(viewModel: viewModel)
        XCTAssertEqual(sut.tableView.numberOfSections, 1)
        XCTAssertEqual(sut.tableView.numberOfRows(section: 0), 1)
    }
    
    func test_displayListEntries_withTwoSections_multipleRows_renderCell() {
        let (sut, _) = makeSUT()
        
        let section = ListEntrySection(name: "", icon: "", cellsModel: [
            ListEntryCellViewModel(title: "title", icon: "default_icon", categoryDescription: "description")
        ])
        
        let section2 = ListEntrySection(name: "", icon: "", cellsModel: [
            ListEntryCellViewModel(title: "title2", icon: "default_icon", categoryDescription: "description2"),
            ListEntryCellViewModel(title: "title3", icon: "default_icon", categoryDescription: "description3")
        ])
        
        
        
        let viewModel = ListEntryScene.Load.ViewModel(sections: [section, section2], displaySections: true)
        sut.displayListEntries(viewModel: viewModel)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        XCTAssertEqual(sut.tableView.numberOfRows(section: 0), 1)
        XCTAssertEqual(sut.tableView.numberOfRows(section: 1), 2)
        
        let cell = sut.tableView.cell(at: 0) as? ListEntryViewCell
        checkCell(cell: cell, title: "title", description: "description")
        
        let cell2 = sut.tableView.cell(at: 0, section: 1) as? ListEntryViewCell
        checkCell(cell: cell2, title: "title2", description: "description2")
        
        let cell3 = sut.tableView.cell(at: 1, section: 1) as? ListEntryViewCell
        checkCell(cell: cell3, title: "title3", description: "description3")
    }
    
    
    
    func checkCell(cell: ListEntryViewCell?, title: String, description: String, file: StaticString = #filePath, line: UInt = #line) {
        
        XCTAssertNotNil(cell, file: file, line: line)
        XCTAssertEqual(cell!.titleLabel.text, title)
        XCTAssertEqual(cell!.titleCategory.text, description, file: file, line: line)
        XCTAssertNotNil(cell!.iconView.image, file: file, line: line)
    }
    
    
    
    
    
    
    //MARK: - Search
    
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
