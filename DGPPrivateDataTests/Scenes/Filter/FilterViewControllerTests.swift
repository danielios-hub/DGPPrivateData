//
//  FilterViewControllerTests.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 30/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import DGPPrivateData
import XCTest

class FilterViewControllerTests: XCTestCase {
    
    var spy = InteractorSpy()
    
    override func setUp() {
        super.setUp()
        spy = InteractorSpy()
    }
    
    func test_viewDidLoad_setupView() {
        let sut = makeSUT()
        XCTAssertEqual(sut.navigationItem.title, NSLocalizedString("Filters", comment: "Filters title"))
        XCTAssertNotNil(sut.filterView.collectionView.dataSource)
        XCTAssertNotNil(sut.filterView.collectionView.delegate)
        
        let layout = sut.filterView.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        XCTAssertEqual(layout.scrollDirection, .vertical)
        XCTAssert(sut.filterView.collectionView.allowsMultipleSelection)
        XCTAssertEqual(sut.filterView.collectionView.superview, sut.filterView)
    }
    
    func test_viewDidLoad_loadFilters() {
        _ = makeSUT()
        XCTAssert(spy.isLoadFilters)
    }
    
    //MARK: - CollectionView
    
    func test_displayFilters_emptyData() {
        let sut = makeSUT()
        let viewModel = getViewModel(numberCategories: 0, numberOrder: 0)
        sut.displayFilters(viewModel: viewModel)
        
        XCTAssertEqual(sut.filterView.collectionView.numberOfSections, 2)
        for section in (0..<sut.tableViewModel.numberOfSection) {
            XCTAssertEqual(sut.filterView.collectionView.numberOfItems(inSection: section), 0)
        }
    }
    
    func test_oneCategory_ZeroOrder_displayFilters() {
        let sut = makeSUT()
        let viewModel = getViewModel(numberCategories: 1, numberOrder: 0)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: 1, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: 0, sut: sut, viewModel: viewModel)
        
    }
    
    func test_multipleCategory_ZeroOrder_displayFilters() {
        let sut = makeSUT()
        let numberItems = 8
        let viewModel = getViewModel(numberCategories: numberItems, numberOrder: 0)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: numberItems, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: 0, sut: sut, viewModel: viewModel)
    }
    
    func test_zeroCategory_OneOrder_displayFilter() {
        let sut = makeSUT()
        let numberItems = 1
        let viewModel = getViewModel(numberCategories: 0, numberOrder: numberItems)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: 0, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: numberItems, sut: sut, viewModel: viewModel)
    }
    
    
    func test_zeroCategory_multipleOrder_displayFilter() {
        let sut = makeSUT()
        let numberItems = 8
        let viewModel = getViewModel(numberCategories: 0, numberOrder: numberItems)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: 0, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: numberItems, sut: sut, viewModel: viewModel)
    }
    
    func test_oneCategory_oneOrder_displayFilter() {
        let sut = makeSUT()
        let numberItems = 1
        let viewModel = getViewModel(numberCategories: numberItems, numberOrder: numberItems)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: numberItems, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: numberItems, sut: sut, viewModel: viewModel)
    }
    
    func test_multipleCategory_multipleOrder_displayFilter() {
        let sut = makeSUT()
        let numberItems = 8
        let viewModel = getViewModel(numberCategories: numberItems, numberOrder: numberItems)
        sut.displayFilters(viewModel: viewModel)
        checkCategoryCells(numberCategories: numberItems, sut: sut, viewModel: viewModel)
        checkOrderCells(section: 1, numberOfOrders: numberItems, sut: sut, viewModel: viewModel)
    }
    
    func checkCategoryCells(section: Int = 0, numberCategories: Int, sut: FilterViewController, viewModel: FilterScene.Load.ViewModel) {
        let collectionView = sut.filterView.collectionView!
        XCTAssertEqual(collectionView.numberOfItems(inSection: section), numberCategories)
        
        
        for indexToTest in (0..<numberCategories) {
            let cell = collectionView.cell(at: indexToTest) as! FilterCellView
            XCTAssertNotNil(cell)
            XCTAssertEqual(cell.titleLabel.text, viewModel.cellsCategoryModel[indexToTest].title)
            XCTAssertEqual(cell.isSelected, viewModel.cellsCategoryModel[indexToTest].state)
            let imageName = "\(viewModel.cellsCategoryModel[indexToTest].icon)_big"
            let image = UIImage(named: imageName)!
            
            XCTAssert(cell.iconImage.image == image)
            
            
            let oldState = cell.isSelected
            if cell.isSelected {
                collectionView.deselect(row: indexToTest, section: section)
            } else {
                collectionView.select(row: indexToTest, section: section)
            }
            
            let cellUpdated = collectionView.cell(at: indexToTest, section: section)
            XCTAssertNotEqual(cellUpdated!.isSelected, oldState)
            XCTAssert(spy.isSelectFilters)

        }
        
        resetSpy()
    }
    
    func checkOrderCells(section: Int = 1, numberOfOrders: Int, sut: FilterViewController, viewModel: FilterScene.Load.ViewModel) {
        let collectionView = sut.filterView.collectionView!
        XCTAssertEqual(collectionView.numberOfItems(inSection: section), numberOfOrders)
        
        for indexToTest in (0..<numberOfOrders) {
            let cell = collectionView.cell(at: indexToTest, section: section) as! OrderFilterViewCell
            XCTAssertNotNil(cell)
            XCTAssertEqual(cell.titleLabel.text, viewModel.cellsOrderModel[indexToTest].title)
            XCTAssertEqual(cell.switchControl.isOn, viewModel.cellsOrderModel[indexToTest].state)
            
            collectionView.select(row: indexToTest, section: section)
            XCTAssertFalse(spy.isSelectFilters)
            
            cell.switchControl.setOn(!cell.switchControl.isOn, animated: false)
            cell.onValueChange(sender: cell.switchControl)
            
            
            
            XCTAssert(spy.isSelectOrderFilter)
        }
        
        resetSpy()
    }
    
    func test_sizeForItem() {
        let sut = makeSUT()
        let collectionView = sut.filterView.collectionView!
        let sectionCategories = FilterViewController.TableViewModel.Section.categories.rawValue
        let sectionOrder = FilterViewController.TableViewModel.Section.orders.rawValue
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let indexPathCategory = IndexPath(
            item: 0,
            section: sectionCategories)
        let indexPathOrder = IndexPath(
            item: 0,
            section: sectionOrder)
        let sizeCategory = sut.collectionView(collectionView, layout: layout, sizeForItemAt: indexPathCategory)
        let sizeOrder = sut.collectionView(collectionView, layout: layout, sizeForItemAt: indexPathOrder)
        
        XCTAssertEqual(sizeCategory, FilterCellView.ViewTraits.cellSize)
        XCTAssertEqual(sizeOrder.height, OrderFilterViewCell.ViewTraits.heightCell)
    }
    
    //MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FilterViewController {
        let sut = FilterViewController()
        sut.interactor = spy
        _ = sut.view
        self.trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func resetSpy() {
        spy.reset()
    }
    
    func getViewModel(numberCategories: Int = 0,
                      numberOrder: Int = 0
                      ) -> FilterScene.Load.ViewModel {
        
        let categoriesTotal: [Filter] = [
            Filter(title: "General", icon: "folder", state: true),
            Filter(title: "SocialNetwork", icon: "social", state: false),
            Filter(title: "Email", icon: "email", state: true),
            Filter(title: "SocialNetwork", icon: "social", state: false),
            Filter(title: "General", icon: "folder", state: true),
            Filter(title: "SocialNetwork", icon: "social", state: false),
            Filter(title: "Email", icon: "email", state: true),
            Filter(title: "SocialNetwork", icon: "social", state: false)
        ]
        
        let ordersTotal: [Filter] = [
            Filter(title: "Group by Categories", icon: "", state: true),
            Filter(title: "Alphabetically", icon: "", state: false),
            Filter(title: "Modified Date", icon: "", state: true),
            Filter(title: "Modified Date", icon: "", state: false),
            Filter(title: "Group by Categories", icon: "", state: true),
            Filter(title: "Alphabetically", icon: "", state: false),
            Filter(title: "Modified Date", icon: "", state: true),
            Filter(title: "Modified Date", icon: "", state: false)
        ]
        
        let categories = categoriesTotal[0..<numberCategories]
        let orders = ordersTotal[0..<numberOrder]
        return FilterScene.Load.ViewModel(categoryFilters: Array(categories), orderFilters: Array(orders))
    }
    
    //MARK: - Spy
    class InteractorSpy: FilterBusinessLogic {
        
        var isLoadFilters = false
        var isSelectFilters = false
        var isSelectOrderFilter = false
        var filters: [Filter] = []
        
        func doLoadFilters(request: FilterScene.Load.Request) {
            isLoadFilters = true
        }
        
        func doSelectFilter(request: FilterScene.ToggleFilter.Request) {
            isSelectFilters = true
        }
        
        func doSaveOrderFilters(request: FilterScene.OrderFilters.Request) {
            isSelectOrderFilter = true
        }
        
        func reset() {
            isLoadFilters = false
            isSelectOrderFilter = false
            isSelectFilters = false
        }
        
    }
}


