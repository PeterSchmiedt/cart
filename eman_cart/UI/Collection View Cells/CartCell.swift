//
//  CartCell.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 21/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import UIKit

protocol CartCellDelegate: class {
    func cartContentDidChange()
}

class CartCell: UITableViewCell {
    static let identifier = "CartCell"
    
    weak var cartItem: CartService.CartItem!
    weak var delegate: CartCellDelegate?
    
    //MARK: Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    //MARK: Actions
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        CartService.shared.setProductQuantity(product: cartItem.item, quantity: Int(sender.value))
        delegate?.cartContentDidChange() // Tell the delegate we changed the contents of the cart (it will then reload the table, ensuring the right data)
    }
    
    //MARK: Public Interface
    func setupCell(cartItem: CartService.CartItem, currency: Currency?) {
        productImageView.image = UIImage(named: cartItem.item.imageAsset)
        productLabel.text = cartItem.item.name
        
        quantityStepper.value = Double(cartItem.quantity)
        productQuantity.text = String(cartItem.quantity)
        
        //productPrice.text = String(cartItem.item.price * Double(cartItem.quantity))
        productPrice.text = "\(cartItem.item.priceIn(currency: currency!, quantity: cartItem.quantity))"
        self.cartItem = cartItem
    }
    
    //MARK: Liflecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productLabel.text = nil
        productPrice.text = nil
        productQuantity.text = nil
        productImageView.image = nil
    }
    
}
