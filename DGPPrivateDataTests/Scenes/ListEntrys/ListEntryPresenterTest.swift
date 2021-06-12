//
//  ListEntryPresenterTest.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 11/6/21.
//

import Foundation
import XCTest
@testable import DGPPrivateData

class ListEntryPresenterTest: XCTestCase {
    
    let categoryOne = Category(name: "one", icon: "")
    let categoryTwo = Category(name: "two", icon: "")
    let categorythree = Category(name: "three", icon: "")
    
    lazy var entryOne = Entry(title: "entryOne", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: categoryOne)
    lazy var entryTwo = Entry(title: "entryTwo", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: categoryTwo)
    lazy var entryThree = Entry(title: "entryThree", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: categoryTwo)
    lazy var entryFour = Entry(title: "entryFour", username: nil, password: nil, url: nil, notes: nil, favorite: false, category: categorythree)
    
    func test_presentInitialData_isNotGrouped_entriesDifferentCategories_returnOneSectionWithRows() {
        let (sut, spy) = makeSUT()
        
        let responseEmpty = ListEntryScene.Load.Response(entries: [], isGroupedCategories: false)
        sut.presentInitialData(response: responseEmpty)
        XCTAssertEqual(spy.viewModelReceived.count, 1)
        XCTAssertEqual(spy.viewModelReceived.first!.sections.count, 0)
        
        let entriesOne = [entryOne]
        let responseOneEntry = ListEntryScene.Load.Response(
            entries: entriesOne, isGroupedCategories: false)
        sut.presentInitialData(response: responseOneEntry)
        XCTAssertEqual(spy.viewModelReceived.count, 2)
        let sectionOne = spy.viewModelReceived[1].sections.first!
        checkSection(section: sectionOne, range: (0..<1), withEntries: entriesOne)
        
        let entries = makeEntries()
        let responseMultipleEntry = ListEntryScene.Load.Response(
            entries: entries, isGroupedCategories: false)
        sut.presentInitialData(response: responseMultipleEntry)
        XCTAssertEqual(spy.viewModelReceived.count, 3)
        let section = spy.viewModelReceived[2].sections.first!
        checkSection(section: section, range: (0..<4), withEntries: entries)
    }
    
    func checkSection(section: ListEntrySection, range: Range<Int>, withEntries entries: [Entry], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(section.cellsModel.count, range.count, file: file, line: line)
        for i in range {
            XCTAssertEqual(section.cellsModel[i].title, entries[i].title, file: file, line: line)
        }
    }
    
    func test_presentInitialData_isGrouped_entriesDifferentCategories_return3SectionWithRows() {
        let (sut, spy) = makeSUT()
        
        let responseEmpty = ListEntryScene.Load.Response(entries: [], isGroupedCategories: true)
        sut.presentInitialData(response: responseEmpty)
        XCTAssertEqual(spy.viewModelReceived.count, 1)
        XCTAssertEqual(spy.viewModelReceived.first!.sections.count, 0)
        
        let entriesOne = [entryOne]
        let responseOneEntry = ListEntryScene.Load.Response(
            entries: entriesOne, isGroupedCategories: true)
        sut.presentInitialData(response: responseOneEntry)
        XCTAssertEqual(spy.viewModelReceived.count, 2)
        let sectionOne = spy.viewModelReceived[1].sections.first!
        checkSection(section: sectionOne, range: (0..<1), withEntries: entriesOne)
        
        
        let entries = makeEntries()
        let responseMultipleEntry = ListEntryScene.Load.Response(
            entries: entries, isGroupedCategories: true)
        sut.presentInitialData(response: responseMultipleEntry)
        
        XCTAssertEqual(spy.viewModelReceived.count, 3)
        let sections =  spy.viewModelReceived[2].sections
        
        
        XCTAssertEqual(sections.count, 3)
        let sectionCategoryOne = spy.viewModelReceived[2].sections[0]
        checkSection(section: sectionCategoryOne, range: 0..<1, withEntries: Array(entries[0..<1]))
        
        let sectionCategoryTwo = spy.viewModelReceived[2].sections[1]
        checkSection(section: sectionCategoryTwo, range: 0..<2, withEntries: Array(entries[1..<3]))
        
        let sectionCategoryThree = spy.viewModelReceived[2].sections[2]
        checkSection(section: sectionCategoryThree, range: 0..<1, withEntries: Array(entries[3..<4]))

    }
    
    //MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ListEntryPresenter, spy: ListEntryDisplayLogicMock) {
        let sut = ListEntryPresenter()
        let spy = ListEntryDisplayLogicMock()
        sut.viewController = spy
        trackForMemoryLeaks(sut)
        return (sut, spy)
    }
    
    func makeEntries() -> [Entry] {
        return [
            entryOne,
            entryTwo,
            entryThree,
            entryFour
        ]
    }
}

class ListEntryDisplayLogicMock: ListEntryDisplayLogic {
    
    var viewModelReceived = [ListEntryScene.Load.ViewModel]()
    func displayListEntries(viewModel: ListEntryScene.Load.ViewModel) {
        viewModelReceived.append(viewModel)
    }
    
}
