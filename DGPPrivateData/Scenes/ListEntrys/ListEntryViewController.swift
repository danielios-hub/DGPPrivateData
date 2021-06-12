//
//  ListEntryViewController.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 4/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol ListEntryDisplayLogic: class {
    func displayListEntries(viewModel: ListEntryScene.Load.ViewModel)
}

class ListEntryViewController: UIViewController, ListEntryDisplayLogic, Storyboarded {
    
    var interactor: ListEntryBusinessLogic?
    var router: (NSObjectProtocol & ListEntryRoutingLogic & ListEntryDataPassing)?
    
    private var sections: [ListEntrySection] = []
    
    var listView: ListEntryView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! ListEntryView)
    }
    
    var tableView: UITableView {
        return listView.tableView
    }
    
    var selectedRow: Int? {
        return listView.tableView.indexPathForSelectedRow?.row
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
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
        let interactor = ListEntryInteractor()
        let presenter = ListEntryPresenter()
        let router = ListEntryRouter()
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
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInitialData()
    }
    
    func setupNavigationBar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createEntry))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(symbol: .lineHorizontal3DecreaseCircleFill),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(filterEntrys))
        navigationItem.rightBarButtonItem = barButton
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.forgottenPurple
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        searchBar.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.addToolbar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func setupView() {
        listView.setup()
    }
    
    // MARK: Request
    
    func loadInitialData() {
        let request = ListEntryScene.Load.Request()
        interactor?.doLoadInitialData(request: request)
    }
    
    func displayListEntries(viewModel: ListEntryScene.Load.ViewModel) {
        self.sections = viewModel.sections
        self.listView.tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @objc func createEntry() {
        router?.routeToAddEntry()
    }
    
    @objc func filterEntrys() {
        router?.routeToFilters()
    }
}

//MARK: - UITableView DataSource

extension ListEntryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListEntryViewCell.getIdentifier(), for: indexPath) as! ListEntryViewCell
        let model = sections[indexPath.section].cellsModel[indexPath.row]
        cell.viewModel = model
        return cell
    }
    
}

//MARK: - UITableView Delegate

extension ListEntryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToEditEntry()
    }
}

extension ListEntryViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //searchBar.showsCancelButton = false
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.doFilterByText(request: ListEntryScene.FilterBy.Request(text: searchText))
    }
}
