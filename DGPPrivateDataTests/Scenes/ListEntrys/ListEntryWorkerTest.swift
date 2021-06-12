//
//  ListEntryWorkerTest.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 2/6/21.
//

//import Foundation
import XCTest
@testable import DGPPrivateData

class ListEntryWorkerTest: XCTestCase {
    
    var testFilters = [
        Filter(title: "Another",
                              icon: "",
                              state: true),
        Filter(title: "General",
                              icon: "",
                              state: false),
        Filter(title: "SocialNetwork",
                              icon: "",
                              state: true),
        Filter(title: "Email",
                              icon: "",
                              state: false),
        Filter(title: Filter.favoriteFilterName,
                              icon: "",
                              state: true),
    ]
    
    var orderFilter = [
        Filter(title: "Group by Categories", icon: "", state: true),
        Filter(title: "Alphabetically", icon: "", state: true),
    ]
    
    //MARK: - Test Categories
    
    func test_fetchEntrys_noCategories() {
        let (sut, spy) = makeSUT(dataStoreMock: DataStoreMock())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [[]])
    }
    
    func test_fetchEntry_onecategoriesSelected() {
        let dataStore = DataStoreMock()
        dataStore.filterList = [Filter(title: "name", icon: "", state: true)]
        
        let (sut, spy) = makeSUT(dataStoreMock: dataStore)
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [["name"]])
        XCTAssertEqual(spy.requestedIsFavorite, [])
    }
    
    func test_fetchEntry_onecategoriesUnSelected() {
        let dataStore = DataStoreMock()
        dataStore.filterList = [Filter(title: "name", icon: "", state: false)]
        
        let (sut, spy) = makeSUT(dataStoreMock: dataStore)
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [[]])
        XCTAssertEqual(spy.requestedIsFavorite, [])
    }
    
    func test_fetchEntry_multipleValues() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [
            ["Another", "SocialNetwork"]
        ])
    }
    
    func test_fetchEntry_multipleValuesRequestTwice() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        let filtersExpectationTwice = expectation(description: "waiting filters")
        
        sut.fetchEntrys() { (entries) in
            filtersExpectationTwice.fulfill()
        }
        
        wait(for: [filtersExpectationTwice], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [
            ["Another", "SocialNetwork"],
            ["Another", "SocialNetwork"]
        ])
    }
    
    //MARK: - Order
    
    func test_fetchEntry_noOrderSelected() {
        let dataStore = DataStoreMock()
        dataStore.orderList = [Filter(title: "Alphabetically", icon: "", state: false)]
        
        let (sut, spy) = makeSUT(dataStoreMock: dataStore)
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        XCTAssertEqual(spy.requestedOrders, [.default])
        XCTAssertEqual(spy.requestedIsFavorite, [])
    }
    
    func test_fetchEntry_oneOrderSelected() {
        let dataStore = DataStoreMock()
        dataStore.orderList = [Filter(title: "Alphabetically", icon: "", state: true)]
        
        let (sut, spy) = makeSUT(dataStoreMock: dataStore)
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        XCTAssertEqual(spy.requestedOrders, [.alphabetically])
        XCTAssertEqual(spy.requestedIsFavorite, [])
    }
    
    //MARK: - Search
    
    func test_fetchEntries_noTextSearch() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys() { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedTextSearchs, [])
    }
    
    func test_fetchEntries_oneTextSearch() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        let textSearch = "something"
        sut.fetchEntrys(textSearch: textSearch) { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedTextSearchs, [textSearch])
        XCTAssertEqual(spy.requestedIsFavorite, [true])
    }
    
    func test_fetchEntry_multipleValuesGroupedAndSearch_TwiceRequests() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        let textSearch = "something"
        let textSearch2 = "something2"
        sut.fetchEntrys(textSearch: textSearch) { (entries) in
            filtersExpectation.fulfill()
        }
        
        let expectedFilters = ["Another", "SocialNetwork"]
        wait(for: [filtersExpectation], timeout: 2)
        
        let filtersExpectationTwice = expectation(description: "waiting filters")
        
        sut.fetchEntrys(textSearch: textSearch2) { (entries) in
            filtersExpectationTwice.fulfill()
        }
        
        wait(for: [filtersExpectationTwice], timeout: 2)

        XCTAssertEqual(spy.requestedFilters, [expectedFilters, expectedFilters])
        XCTAssertEqual(spy.requestedOrders, [.alphabetically, .alphabetically])
        XCTAssertEqual(spy.requestedTextSearchs, [textSearch, textSearch2])
        XCTAssertEqual(spy.requestedIsFavorite, [true, true])
    }
    
    //MARK: - Helpers
    
    func makeSUT(dataStoreMock: DataStoreMock, file: StaticString = #filePath, line: UInt = #line) -> (sut: ListEntryWorker, spy: DataSourceMock) {
        let spy = DataSourceMock()
        let sut = ListEntryWorker(
            dataStore: dataStoreMock,
            masterDataSource: spy)
        
        self.trackForMemoryLeaks(sut, file: file, line: line)
        self.trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
    
    func getDataStore() -> DataStoreMock {
        let dataStoreMock = DataStoreMock()
        dataStoreMock.filterList = testFilters
        dataStoreMock.orderList = orderFilter
        return dataStoreMock
    }
    
    class DataStoreMock: PreferencesService {
        var isGroupedByCategories: Bool = false
        
        var filterList: [Filter] = []
        var orderList: [Filter] = []
    }
    
    class DataSourceMock: RepositoryService {
        var requestedFilters: [[String]] = []
        var requestedOrders: [Order] = []
        var requestedTextSearchs: [String] = []
        var requestedIsFavorite: [Bool] = []
        
        enum ErrorMock: Error {
            case mockError
        }
        
        func getAllCategories() -> [DGPPrivateData.Category] {
            return []
        }
        
        func createCategory(category: DGPPrivateData.Category) throws -> DGPPrivateData.Category {
            return DGPPrivateData.Category(name: "", icon: "")
        }
        
        func getAllEntries(filters: [FilterType]) -> [Entry] {
            filters.forEach { filterType  in
                switch filterType {
                case .categories(let categoriesName):
                    requestedFilters.append(categoriesName)
                case .order(let orderType):
                    requestedOrders.append(orderType)
                case .search(let text):
                    requestedTextSearchs.append(text)
                case let .isFavorite(value):
                    requestedIsFavorite.append(value)
                }
            }
            
            return []
        }
        
        func createEntry(_ entry: Entry) throws -> Entry {
            throw ErrorMock.mockError
        }
        
        func updateEntry(_ entry: Entry) throws -> Entry {
            throw ErrorMock.mockError
        }
    }

        
}

