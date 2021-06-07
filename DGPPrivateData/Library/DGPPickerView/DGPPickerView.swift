//
//  DGPDatePicker.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/2/21.
//

import UIKit

public protocol DGPPickerViewModel {
    var selectedIndex: Int { get }
    func numberOfComponents() -> Int
    func numberOfItems() -> Int
    func titleOfItem(with index: Int, component: Int) -> String
    func didSelectItem(with index: Int, component: Int) -> Void
    func finishDGPPickerView()
}

class DGPPickerView: UIView {
    
    //MARK: - Instance properties
    
    public var pickerView: UIPickerView!
    public var stackView: UIStackView!
    
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    private var bottomConstraint: NSLayoutConstraint?
    
    public var heightView: CGFloat = 150
    
    public var okClosure: (() -> Void)?
    public var cancelClosure: (() -> Void)?
    
    public var viewModel: DGPPickerViewModel! {
        didSet {
            pickerView.reloadAllComponents()
            pickerView.selectRow(viewModel.selectedIndex, inComponent: 1, animated: false)
        }
    }
    
    //MARK: - Life cicle
    
    convenience init(frame: CGRect, viewModel: DGPPickerViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        pickerView.selectRow(viewModel.selectedIndex, inComponent: 0, animated: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        pickerView = UIPickerView()
        stackView = UIStackView()
        okButton = UIButton()
        cancelButton = UIButton()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(stackView)
        self.addSubview(pickerView)
        
        NSLayoutConstraint.activate( [
            
            self.heightAnchor.constraint(equalToConstant: heightView),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pickerView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])

        
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .equalCentering
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        okButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
}

//MARK: - UIPickerView DataSource

extension DGPPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleOfItem(with: row, component: component)
    }
    
}

//MARK: - UIPickerView Delegate

extension DGPPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectItem(with: row, component: component)
    }
    
}

//MARK: - Transitions

extension DGPPickerView {
    
    var duration: TimeInterval {
        return 0.7
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightView)
        NSLayoutConstraint.activate ( [
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        bottomConstraint?.isActive = true
        view.layoutIfNeeded()
        
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: duration) {
            view.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        bottomConstraint?.constant = heightView
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        } completion: { [weak self] (state) in
            if state {
                self?.viewModel.finishDGPPickerView()
                self?.removeFromSuperview()
            }
        }
    }
}
