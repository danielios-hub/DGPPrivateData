//
//  AuthenticationViewController.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 5/3/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
/*
import UIKit
import LocalAuthentication
import DGPLibrary

protocol AuthenticationDisplayLogic: class {
    func displayLoginSuccess(viewModel: AuthenticationScene.Login.ViewModel)
    func displayError(viewModel: ErrorViewModel)
}

class AuthenticationViewController: UIViewController, AuthenticationDisplayLogic, Storyboarded {
    var interactor: AuthenticationBusinessLogic?
    var router: (NSObjectProtocol & AuthenticationRoutingLogic & AuthenticationDataPassing)?
    
    //MARK: - Instance properties
    
    var authView: AuthenticationView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! AuthenticationView)
    }
    
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
        let interactor = AuthenticationInteractor()
        let presenter = AuthenticationPresenter()
        let router = AuthenticationRouter()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if BETA
            print("beta")
        //router?.routeToListEntry()
        #endif
    }
    
    private func setupView() {
        title = NSLocalizedString("Authentication", comment: "title for authentication screen")
        navigationController?.navigationBar.barTintColor = UIColor.forgottenPurple
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        authView.setup()
        authView.authButton.addTarget(self, action: #selector(launchFaceID), for: .touchUpInside)
    }
    
    // MARK: Output
    
    func doLogin() {
        let request = AuthenticationScene.Login.Request()
        interactor?.doAuthentication(request: request)
    }
        
    //MARK: - Input
    
    func displayLoginSuccess(viewModel: AuthenticationScene.Login.ViewModel) {
        router?.routeToListEntry()
    }
    
    func displayError(viewModel: ErrorViewModel) {
        view.makeToast(viewModel.msg , position: .bottom)
    }
    
    //MARK: - Actions
    
    @objc func launchFaceID() {
        doLogin()
    }
}
*/
