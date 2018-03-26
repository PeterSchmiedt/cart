//
//  ProductCell.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 18/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func addToCart(productId: Int)
}

class ProductCell: UICollectionViewCell {
    private var productId: Int!
    
    // MARK: Public interface
    func setupCell(product: Product, currency: Currency?) {
        productImageView.image = UIImage(named: product.imageAsset)
        productNameLabel.text = product.name
        //I can force unwrap for now 
        productPriceLabel.text = "Price: \(product.priceIn(currency: currency!)) / \(product.unit)"
        productId = product.id
    }
    
    // MARK: Outlets
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    
    // MARK: Actions
    @IBAction func addToCartAction(_ sender: UIButton) {
        guard let product = ProductsService.shared.product(id: productId) else { return }
        CartService.shared.addProduct(product: product)
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        productImageView.image = nil
        productNameLabel.text = nil
        productPriceLabel.text = nil
    }
}
