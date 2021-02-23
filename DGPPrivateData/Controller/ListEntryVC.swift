//
//  ViewController.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 18/2/21.
//

import UIKit
import DGPLibrary

class ListEntryVC: UIViewController, Storyboarded {

    //MARK: - Instance properties
    
    public var viewModel : ListEntryViewModel!
    public weak var coordinator: MainCoordinator?
    
    private var listEntryView : ListEntryView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! ListEntryView)
    }
    
    
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        self.title = NSLocalizedString("Entrys", comment: "Title entry list")
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createEntry))
        navigationItem.rightBarButtonItem = barButton
        navigationController?.navigationBar.barTintColor = UIColor.lavender_tea
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    private func setupViewModel() {
        viewModel.showAlertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.view.makeToast(message)
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.listEntryView.tableView.reloadData()
        }
        
        viewModel.initFetch()
    }
    
    //MARK: - Actions
    
    @objc func createEntry() {
        coordinator?.showAddEntry()
    }
}

//MARK: - UITableView DataSource

extension ListEntryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListEntryViewCell.getIdentifier(), for: indexPath) as! ListEntryViewCell
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ListEntryVC: UITableViewDelegate {
    
}
