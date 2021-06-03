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
    
    let defaultCategoryName = "Favorites"
    
    var testFilters = [
        Filter(title: "Favorites",
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
                              state: false)
    ]
    
    var orderFilter = [
        Filter(title: "Group by Categories", icon: "", state: true),
        Filter(title: "Alphabetically", icon: "", state: true),
    ]
    
    //MARK: - Test Categories
    
    func test_fetchEntrys_noCategories() {
        let (sut, spy) = makeSUT(dataStoreMock: DataStoreMock())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys(applyFilters: true) { (entries) in
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
        sut.fetchEntrys(applyFilters: true) { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [["name"]])
    }
    
    func test_fetchEntry_onecategoriesUnSelected() {
        let dataStore = DataStoreMock()
        dataStore.filterList = [Filter(title: "name", icon: "", state: false)]
        
        let (sut, spy) = makeSUT(dataStoreMock: dataStore)
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys(applyFilters: true) { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [[]])
    }
    
    func test_fetchEntry_multipleValues() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys(applyFilters: true) { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [
            ["Favorites", "SocialNetwork"]
        ])
    }
    
    func test_fetchEntry_multipleValuesRequestTwice() {
        let (sut, spy) = makeSUT(dataStoreMock: getDataStore())
        
        let filtersExpectation = expectation(description: "waiting filters")
        sut.fetchEntrys(applyFilters: true) { (entries) in
            filtersExpectation.fulfill()
        }
        
        wait(for: [filtersExpectation], timeout: 2)
        
        let filtersExpectationTwice = expectation(description: "waiting filters")
        
        sut.fetchEntrys(applyFilters: true) { (entries) in
            filtersExpectationTwice.fulfill()
        }
        
        wait(for: [filtersExpectationTwice], timeout: 2)
        
        XCTAssertEqual(spy.requestedFilters, [
            ["Favorites", "SocialNetwork"],
            ["Favorites", "SocialNetwork"]
        ])
    }
    
    //MARK: - Helpers
    
    func makeSUT(dataStoreMock: DataStoreMock) -> (sut: ListEntryWorker, spy: DataSourceMock) {
        let spy = DataSourceMock()
        let sut = ListEntryWorker(
            dataStore: dataStoreMock,
            masterDataSource: spy)
        
        return (sut, spy)
    }
    
    func getDataStore() -> DataStoreMock {
        let dataStoreMock = DataStoreMock()
        dataStoreMock.filterList = testFilters
        dataStoreMock.orderList = orderFilter
        return dataStoreMock
    }
    
    class DataStoreMock: StoreDataSource {
        var filterList: [Filter] = []
        var orderList: [Filter] = []
    }
    
    class DataSourceMock: MasterDataSource {
        
        var requestedFilters: [[String]] = []
        
        enum ErrorMock: Error {
            case mockError
        }
        
        func getAllCategories() -> [DGPPrivateData.Category] {
            return []
        }
        
        func getAllEntrys(filterByCategoryName: [String]) -> [Entry] {
            requestedFilters.append(filterByCategoryName)
            return []
        }
        
        func createEntry(with title: String, username: String?, password: String?, notes: String?, isFavorite: Bool, category: DGPPrivateData.Category) throws -> Entry {
            throw ErrorMock.mockError
        }
        
        func createEntry(_ entry: Entry) throws -> Entry {
            throw ErrorMock.mockError
        }
        
        func updateEntry(_ entry: Entry) throws -> Entry {
            throw ErrorMock.mockError
        }
    }

        
}

