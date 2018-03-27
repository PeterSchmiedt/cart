//
//  CartViewController.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let viewModel = CartViewModel()

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier) as? CartCell else { return UITableViewCell() }
        let cartItem = viewModel.data[indexPath.row]
        cell.setupCell(cartItem: cartItem, currency: viewModel.currency)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: CartCellDelegate
    func cartContentDidChange() {
        tableView.reloadData()
    }
}
