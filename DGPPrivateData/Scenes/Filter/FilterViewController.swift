//
//  FilterViewController.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 13/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FilterDisplayLogic: class {
    func displayFilters(viewModel: FilterScene.Load.ViewModel)
}

class FilterViewController: UIViewController, FilterDisplayLogic {
    var interactor: FilterBusinessLogic?
    var router: (NSObjectProtocol & FilterRoutingLogic & FilterDataPassing)?
    
    var filterView: FilterView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! FilterView)
    }
    
    var cellsViewModels: [FilterCellViewModel] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = FilterInteractor()
        let presenter = FilterPresenter()
        let router = FilterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadFilters()
    }
    
    override func loadView() {
        view = FilterView()
    }
    
    private func setupView() {
        navigationItem.title = "Filters"
        filterView.collectionView.dataSource = self
        filterView.collectionView.delegate = self
    }
    
    // MARK: Output
    
    func loadFilters() {
        let request = FilterScene.Load.Request()
        interactor?.doLoadFilters(request: request)
    }
    
    func selectFilter(index: Int) {
        interactor?.doSelectFilter(request: FilterScene.ToggleFilter.Request(index: index))
    }
    
    //MARK: - Input
    
    func displayFilters(viewModel: FilterScene.Load.ViewModel) {
        cellsViewModels = viewModel.cells
        reloadCollectionView()
        
        for (index, model) in cellsViewModels.enumerated() {
            if model.state {
                self.filterView.collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                          animated: false, scrollPosition: .top)
            }
        }
    }
    
    //MARK: - Utils
    
    func reloadCollectionView() {
        filterView.collectionView.reloadData()
    }
}

//MARK: - UICollectionView DataSource

extension FilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCellView.getIdentifier(), for: indexPath) as! FilterCellView
        cell.viewModel = cellsViewModels[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionView DelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectFilter(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectFilter(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FilterCellView.ViewTraits.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 15
        return UIEdgeInsets(top: padding, left: padding, bottom: 0, right: padding)
    }
}