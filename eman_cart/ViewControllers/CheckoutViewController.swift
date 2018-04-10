//
//  CheckoutViewController.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 02/04/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import UIKit
import Foundation

class CheckoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let viewModel = CheckoutViewModel()
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var computedPriceLabel: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        createToolbar()
        
        
    }
    
    //MARK: UIPickerView - Create
    func createPickerView() {
        let pickerView = UIPickerView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(149, inComponent: 0, animated: true)
        
        currencyTextField.inputView = pickerView
        
        priceLabel.text = String(viewModel.sumInCurrency(currencyKey: "USD"))
        computedPriceLabel.text = String(viewModel.sumInCurrency(currencyKey: "USD"))
    }
    
    //MARK: UIPickerView - ToolBar
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CheckoutViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        currencyTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: UIPickerVIew
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencies.count
    }
    
    //MARK: UIViewPicker - title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyCodes = [String](viewModel.currencies.keys).sorted()
        return "\(currencyCodes[row]) - \(String(describing: viewModel.currencies[currencyCodes[row]]!.name))"
    }
    
    //MARK: UIViewPicker - when user selects a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyCodes = [String](viewModel.currencies.keys).sorted()
        currencyTextField.text = currencyCodes[row]
        computedPriceLabel.text = String(viewModel.sumInCurrency(currencyKey: currencyCodes[row]))
    }
}
