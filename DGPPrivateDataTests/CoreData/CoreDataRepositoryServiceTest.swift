//
//  CoreDataRepositoryServiceTest.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 5/6/21.
//

import XCTest
import DGPPrivateData
import CoreData


class CoreDataRepositoryServiceTest: XCTestCase {

    let categoriesConstants = [
        (name: "General", icon: "folder"),
        (name: "SocialNetwork", icon: "social"),
        (name: "Email", icon: "email"),
        (name: "Network", icon: "wifi"),
        (name: "Internet", icon: "internet"),
        (name: "Bank", icon: "creditcard")
    ].sorted {
        $0.name < $1.name
    }
    
    lazy var defaultCategories = categoriesConstants.map { Category(name: $0.name, icon: $0.icon )}
    
    //MARK: - Test Categories
    
    func test_getAllCategories_noCategories_returnDefaultCategories() {
        let sut = makeSUT()
        let result = sut.getAllCategories()
        XCTAssertEqual(result, defaultCategories)
    }
    
    func test_getAllCategories_withCategories_returnDefaultCategories() {
        let sut = makeSUT()
        let _ = sut.getAllCategories()
        let result = sut.getAllCategories()
        XCTAssertEqual(result, defaultCategories)
    }
    
    func test_createCategory_NoCategories_returnDefaultPlusAddedCategories() {
        let sut = makeSUT()
        let category = makeCategory(sut: sut)
        
        let _ = sut.getAllCategories()
        let result = sut.getAllCategories()
        
        defaultCategories.append(category)
        XCTAssertEqual(result, defaultCategories)
    }
    
    func test_getAllEntries_noEntries_doesNotReturnEntries() {
        let sut = makeSUT()
        let result = sut.getAllEntries(filters: [])
        XCTAssert(result.isEmpty)
    }
    
    func test_getAllEntries_noEntries_addFilters_doesNotReturnEntries() {
        let sut = makeSUT()
        
        let filters: [FilterType] = [
            FilterType.search("something"),
            FilterType.order(.alphabetically)
        ]
        
        let results = sut.getAllEntries(filters: filters)
        XCTAssert(results.isEmpty)
    }

    func test_getAllEntries_withEntries_noFilters_returnAllEntries() {
        let sut = makeSUT()
        let entry = makeEntry(sut: sut)
        let result = sut.getAllEntries(filters: [])
        XCTAssertEqual(result, [entry])
    }
    
    func test_getAllEntries_withMultipleEntries_noFilters_returnAllEntries() {
        let sut = makeSUT()
        let entry = makeEntry(sut: sut)
        let entry2 = makeEntry(sut: sut, title: "2")
        let result = sut.getAllEntries(filters: [])
        XCTAssertEqual(result, [entry2, entry])
    }
    
    func test_getAllEntries_withMultipleEntries_filterByOneCategories() {
        let sut = makeSUT()
        let (filters, categories) = makeCategoriesInfo(sut: sut, categoryNames: ["name"])
        let entry = makeEntry(sut: sut, title: "entry1", category: categories[0])
        _ = makeEntry(sut: sut, title: "entry2")
        
        XCTAssertEqual(sut.getAllEntries(filters: filters), [entry])
    }
    
    func test_getAllEntries_withMultipleEntries_filterByMultipleCategories() {
        let sut = makeSUT()
        let (filters, categories) = makeCategoriesInfo(sut: sut, categoryNames: ["name", "name2"])

        let entry = makeEntry(sut: sut, title: "entry1", category: categories[0])
        _ = makeEntry(sut: sut, title: "entry2")
        let entry3 = makeEntry(sut: sut, title: "entry3", category: categories[1])
        
        XCTAssertEqual(sut.getAllEntries(filters: filters), [entry, entry3])
    }
    
    func test_getAllEntries_withNoFavoritesEntry_filterByFavoriteCategory_returnNoEntries() {
        let sut = makeSUT()
        let filter = FilterType.isFavorite(true)
        
        _ = makeEntry(sut: sut, title: "entry1", isFavorite: false)
        _ = makeEntry(sut: sut, title: "entry2", isFavorite: false)
        _ = makeEntry(sut: sut, title: "entry3", isFavorite: false)
        
        XCTAssert(sut.getAllEntries(filters: [filter]).isEmpty)
    }
    
    func test_getAllEntries_witlMultipleEntries_filterByFavoriteCategory_returnFavoritesEntries() {
        let sut = makeSUT()
        let filter = FilterType.isFavorite(true)
        
        let entry = makeEntry(sut: sut, title: "entry1", isFavorite: true)
        _ = makeEntry(sut: sut, title: "entry2")
        let entry3 = makeEntry(sut: sut, title: "entry3", isFavorite: true)
        
        XCTAssertEqual(sut.getAllEntries(filters: [filter]), [entry, entry3])
    }
    
    //MARK: - Test Order
    
    func test_getAllEntries_withNoEntries_orders() {
        let sut = makeSUT()
        
        let filter = FilterType.order(.default)
        let orderFilter = FilterType.order(.alphabetically)
        
        XCTAssert(sut.getAllEntries(filters: [filter]).isEmpty)
        XCTAssert(sut.getAllEntries(filters: [orderFilter]).isEmpty)
    }
    
    func test_getAllEntries_withEntries_defaultOrder() {
        let sut = makeSUT()
        let entry = makeEntry(sut: sut)
        let entry2 = makeEntry(sut: sut, title: "2")
        let filter = FilterType.order(.default)
        let result = sut.getAllEntries(filters: [filter])
        XCTAssertEqual(result, [entry2, entry])
    }
    
    func test_getAllEntries_withEntries_alphabeticallyOrder_returlEntriesOrdererALphabetically() {
        let sut = makeSUT()
        let entry = makeEntry(sut: sut, title: "a")
        let entry2 = makeEntry(sut: sut, title: "b")
        let entry3 = makeEntry(sut: sut, title: "c")
        let filter = FilterType.order(.alphabetically)
        let result = sut.getAllEntries(filters: [filter])
        XCTAssertEqual(result, [entry, entry2, entry3])
    }
    
    //MARK: - Test Search
    
    func test_getAllEntries_withNoEntries_search_doesNotReturnEntries() {
        let sut = makeSUT()
        let filter = FilterType.search("something")
        XCTAssert(sut.getAllEntries(filters: [filter]).isEmpty)
    }
    
    func test_getAllEntries_withEntries_searchEmpty_returnAllEntries() {
        let sut = makeSUT()
        let filter = FilterType.search("")
        let entry = makeEntry(sut: sut, title: "a")
        let entry2 = makeEntry(sut: sut, title: "b")
        let result = sut.getAllEntries(filters: [filter])
        XCTAssertEqual(result, [entry2, entry])
    }
    
    func test_getAllEntries_withEntries_searchByText_withNoMatches_returnNoEntries() {
        let sut = makeSUT()
        let filter = FilterType.search("something")
        let _ = makeEntry(sut: sut, title: "a")
        let _ = makeEntry(sut: sut, title: "b")
        let result = sut.getAllEntries(filters: [filter])
        XCTAssert(result.isEmpty)
    }
    
    func test_getAllEntries_withEntries_searchByText_withMatches_returnEntriesMatch() {
        let sut = makeSUT()
        let filter = FilterType.search("some")
        let entry = makeEntry(sut: sut, title: "something")
        let _ = makeEntry(sut: sut, title: "another")
        let entry3 = makeEntry(sut: sut, title: "somethingOther")
        let result = sut.getAllEntries(filters: [filter])
        XCTAssertEqual(result, [entry, entry3])
    }
    
    //MARK: - All Filters Combine
    
    func test_getAllEntries_withMultipleEntries_combineAllFiltersWithSearch() {
        let sut = makeSUT()
        let favoriteFilter = FilterType.isFavorite(true)
        let searchFilter = FilterType.search("searc")
        let orderFilter = FilterType.order(.alphabetically)
        let (filters, categories) = makeCategoriesInfo(sut: sut, categoryNames: ["name", "name2"])
        
        let _ = makeEntry(sut: sut, title: "entry1", category: categories[0])
        _ = makeEntry(sut: sut, title: "entry2")
        let entry4 = makeEntry(sut: sut, title: "searched", category: categories[1], isFavorite: false)
        let entry5 = makeEntry(sut: sut, title: "searchedz", category: categories[1], isFavorite: true)
        
        var combinedFilter = [favoriteFilter, searchFilter, orderFilter]
        combinedFilter.append(contentsOf: filters)
        
        let result = sut.getAllEntries(filters: combinedFilter)
        XCTAssertEqual(result, [entry4, entry5])
    }
    
    func test_getAllEntries_withMultipleEntries_combineCategoryFavoriteFilter() {
        let sut = makeSUT()
        
        let favoriteFilter = FilterType.isFavorite(true)
       
        let orderFilter = FilterType.order(.alphabetically)
        let (filters, categories) = makeCategoriesInfo(sut: sut, categoryNames: ["name"])
        
        let entry1 = makeEntry(sut: sut, title: "entry1", category: categories[0])
        _ = makeEntry(sut: sut, title: "entry2")
        let entry3 = makeEntry(sut: sut, title: "entry3", isFavorite: true)
        let entry4 = makeEntry(sut: sut, title: "entry4", category: categories[0], isFavorite: true)
        
        var combinedFilter = [favoriteFilter, orderFilter]
        combinedFilter.append(contentsOf: filters)
        
        let result = sut.getAllEntries(filters: combinedFilter)
        XCTAssertEqual(result, [entry1, entry3, entry4])
    }
    
    
    //MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataRepositoryService {
        let inMemoryStack = CoreDataInMemoryStackTest()
        let sut = CoreDataRepositoryService(stack: inMemoryStack)
        self.trackForMemoryLeaks(sut, file: file, line: line)
        self.trackForMemoryLeaks(inMemoryStack, file: file, line: line)
        return sut
    }
    
    func makeEntry(sut: CoreDataRepositoryService, title: String = "default", category: DGPPrivateData.Category? = nil, isFavorite: Bool = false) -> Entry {
        let categoryEntry = category ?? sut.getAllCategories().first!
        var entry = Entry(category: categoryEntry)
        entry.title = title
        entry.favorite = isFavorite
        return try! sut.createEntry(entry)
    }
    
    func makeCategory(sut: CoreDataRepositoryService, name: String = "categoryDefault", icon: String = "iconDefault") -> DGPPrivateData.Category {
        let category = DGPPrivateData.Category(name: name, icon: icon)
        return try! sut.createCategory(category: category)
    }
    
    func makeCategoriesInfo(sut: CoreDataRepositoryService, categoryNames: [String]) ->  (filters: [FilterType], categories: [DGPPrivateData.Category]) {
        let filters: [FilterType] = [
            FilterType.categories(categoryNames)
        ]
        
        let categories = categoryNames.compactMap { name in
            return makeCategory(sut: sut, name: name)
        }
        
        return (filters, categories)
    }
}

class CoreDataInMemoryStackTest: CoreDataStack {
    
    var storeContainer: NSPersistentContainer!
    
    override init() {
        super.init()
        
        let persistentStorageDescription = NSPersistentStoreDescription()
        persistentStorageDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(
            name: CoreDataStack.nameModel,
            managedObjectModel: CoreDataStack.managedObjectModel
        )
        
        container.persistentStoreDescriptions = [persistentStorageDescription]
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
        
        self.storeContainer = container
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = container.persistentStoreCoordinator
        
        managedPrivateObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedPrivateObjectContext!.persistentStoreCoordinator = container.persistentStoreCoordinator
        
    }
}
